//
//  SBViewController.m
//  SBLib
//
//  Created by yuki.wang on 08/30/2016.
//  Copyright (c) 2016 yuki.wang. All rights reserved.
//

#import "SBViewController.h"
#import "SBCONSTANT.h"

@interface SBViewController ()

@end

@implementation SBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (int i = 0; i < 20; i++) {
        if (APPCONFIG_VERSION_OVER_(i)) {
            NSLog(@"%@", @(i));
        }
    }
    
    [self.view sb_showTips:@"" showIndicator:YES hiddenAfterSeconds:3];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

@end
