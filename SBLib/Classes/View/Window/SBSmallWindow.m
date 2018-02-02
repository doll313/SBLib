//
//  SBSmallWindow.m
//  SBLib
//
//  Created by thomas on 2017/5/22.
//  Copyright © 2017年 roronoa. All rights reserved.
//

#import "SBSmallWindow.h"
#import "SBSmallWindowDismissAnimator.h"
#import "SBSmallWindowPresentAnimator.h"

@interface SBSmallWindow ()<UIViewControllerTransitioningDelegate>
{
    id<UIViewControllerAnimatedTransitioning> _presentedTransitioning;
    id<UIViewControllerAnimatedTransitioning> _dimissTransitioning;
}


@end

@implementation SBSmallWindow

-(instancetype)init {
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
        self.windowY = -1;//默认-1，上下居中。
        self.needTapGesture = YES;
        self.modalPresentationStyle = UIModalPresentationCustom;//必须加这句，否则弹出小窗时，原来的controller会走进viewWillDisappear
    }
    return self;
}

- (void)dealloc {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    if (_presentStyle == SBSmallWindowPresentStyle_Normal) {
        _presentedTransitioning = [SBSmallWindowPresentAnimator new];
        
    } else if (_presentStyle == SBSmallWindowPresentStyle_FromBottom) {
        _presentedTransitioning = [ELPresentFromBottomAnimator new];
    }
    return _presentedTransitioning;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if (_presentStyle == SBSmallWindowPresentStyle_Normal) {
        _dimissTransitioning = [SBSmallWindowDismissAnimator new];

    } else if (_presentStyle == SBSmallWindowPresentStyle_FromBottom) {
        _dimissTransitioning = [SBDismissToBottomAnimator new];
    } 
    return _dimissTransitioning;
}

@end
