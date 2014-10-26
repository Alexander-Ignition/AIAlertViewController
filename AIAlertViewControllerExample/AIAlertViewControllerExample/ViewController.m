//
//  ViewController.m
//  AIAlertViewController
//
//  Created by Александр Игнатьев on 25.10.14.
//  Copyright (c) 2014 Alexander Ignition. All rights reserved.
//

#import "ViewController.h"
#import "AIAlertViewController.h"
#import "AIView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)alertAction:(UIButton *)sender {
    AIView *myView = [[[NSBundle mainBundle] loadNibNamed:@"AIView" owner:self options:nil] lastObject];
    AIAlertViewController *alertView = [[AIAlertViewController alloc] initWithView:myView outsideClose:YES];
    [alertView show];
}

@end
