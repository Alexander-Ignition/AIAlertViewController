//
//  AIView.m
//  TLAlertView
//
//  Created by Александр Игнатьев on 25.10.14.
//  Copyright (c) 2014 Teehan+Lax. All rights reserved.
//

#import "AIView.h"

@implementation AIView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.layer.cornerRadius = 30.f;
    }
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


#pragma mark - Actions

- (IBAction)buttonAction:(UIButton *)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
