//
//  AIAlertViewController.m
//  TLAlertView
//
//  Created by Александр Игнатьев on 18.10.14.
//  Copyright (c) 2014 Teehan+Lax. All rights reserved.
//

#import "AIAlertViewController.h"

static const CGFloat kAIAnimationDuration = 0.4f;


@interface AIAlertViewController ()

@property (nonatomic, assign) BOOL tap2close;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *customAlertView;
@property (nonatomic, strong) UIDynamicAnimator *animator;

@end


@implementation AIAlertViewController

- (instancetype)initWithView:(UIView *)view outsideClose:(BOOL)tap2close
{
    if (self = [super init]) {
        self.tap2close = tap2close;
        self.customAlertView = view;
        [self setupCustomView];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)setupCustomView
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    self.frame = keyWindow.bounds;
    
    // Set up our subviews
    self.backgroundView                 = [[UIView alloc] initWithFrame:keyWindow.bounds];
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f]; // Determined empirically
    self.backgroundView.alpha           = 0.0f;
    [self addSubview:self.backgroundView];
    
    [self addSubview:self.customAlertView];
    
    // Adjust our keyWindow's tint adjustment mode to make everything behind the alert view dimmed
    keyWindow.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    [keyWindow tintColorDidChange];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    
    // add custom gestures.
    if (self.tap2close == YES) {
        [self setupGestures];
    }
}

- (void)show {
    // Assume the view is offscreen. Use a Snap behaviour to position it in the center of the screen.
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    [keyWindow addSubview:self];
    
    __weak AIAlertViewController *weakSelf = self;
    // Animate in the background blind
    [UIView animateWithDuration:kAIAnimationDuration animations:^{
        weakSelf.backgroundView.alpha = 1.0f;
    }];
    
    // Use UIKit Dynamics to make the alertView appear.
    UISnapBehavior *snapBehaviour = [[UISnapBehavior alloc] initWithItem:self.customAlertView snapToPoint:keyWindow.center];
    snapBehaviour.damping = 0.65f;
    [self.animator addBehavior:snapBehaviour];
    
}

- (void)dismiss
{
    // Assume that the view is currently in the center of the screen. Add some gravity to make it disappear.
    // It *should* disappear before the animation fading away the background completes.
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    [self.animator removeAllBehaviors];
    
    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self.customAlertView]];
    gravityBehaviour.gravityDirection = CGVectorMake(0.0f, 10.0f);
    [self.animator addBehavior:gravityBehaviour];
    
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.customAlertView]];
    [itemBehaviour addAngularVelocity:-M_PI_2 forItem:self.customAlertView];
    [self.animator addBehavior:itemBehaviour];
    
    __weak AIAlertViewController *weakSelf = self;
    // Animate out our background blind
    [UIView animateWithDuration:kAIAnimationDuration animations:^{
        weakSelf.backgroundView.alpha = 0.0f;
        keyWindow.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
        [keyWindow tintColorDidChange];
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}


#pragma mark - gesture actions

- (void)setupGestures
{
    // Add lister main view to close if tapped
    UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTapBlurArea:)];
    [tap2 setNumberOfTapsRequired:1];
    [self.backgroundView setUserInteractionEnabled:YES];
    [self.backgroundView setMultipleTouchEnabled:NO];
    [self.backgroundView addGestureRecognizer:tap2];
}

-(void)closeTapBlurArea:(UITapGestureRecognizer *)sender
{
    UIView *senderview = sender.view;
    
    UIView *childView = nil;
    for (UIView *child in [senderview subviews]){
        if([child isKindOfClass:[self class]]){
            childView = child;
        }
    }
    
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        
        CGPoint location = [sender locationInView:senderview.superview];
        BOOL closeSuperView = [self isTappedOutsideRegion:childView withLocation: location];
        if(closeSuperView == YES){
            [self dismiss];
        }
        
    }
}

- (BOOL)isTappedOutsideRegion:(UIView *)view withLocation : (CGPoint)location
{
    CGFloat endX = (view.frame.origin.x + view.frame.size.width);
    CGFloat endY = (view.frame.origin.y + view.frame.size.height);
    BOOL isValid;
    if(
       (location.x < view.frame.origin.x || location.y < view.frame.origin.y) ||
       (location.x > endX || location.y > endY)
       ){
        isValid = YES;
    }else{
        isValid = NO;
    }
    
    return isValid;
}

@end
