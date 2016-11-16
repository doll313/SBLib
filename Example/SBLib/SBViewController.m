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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIButton *bb = [[UIButton alloc] init];
    bb.backgroundColor = [UIColor redColor];
    bb.frame = CGRectMake(110, 110, 44, 44);
    [bb addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bb];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)clicked {
    //UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [UIWindow sb_showTips:@"jjjjj"];
//    [self sb_showConfirm:@"111" cancel:^(UIAlertAction *action) {
//
//    } handler:^(UIAlertAction *action) {
//
//    }];
}

@end
