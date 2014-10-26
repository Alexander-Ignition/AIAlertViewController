//
//  AIAlertViewController.h
//  TLAlertView
//
//  Created by Александр Игнатьев on 18.10.14.
//  Copyright (c) 2014 Teehan+Lax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AIAlertViewController : UIView

- (instancetype)initWithView:(UIView *)view outsideClose:(BOOL)tap2close;

- (void)show;
- (void)dismiss;

@end
