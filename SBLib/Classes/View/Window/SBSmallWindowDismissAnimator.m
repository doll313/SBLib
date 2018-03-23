//
//  SBSmallWindowDismissAnimator.m
//  SBLib
//
//  Created by thomas on 2017/7/6.
//  Copyright © 2017年 roronoa. All rights reserved.
//

#import "SBSmallWindowDismissAnimator.h"
#import "UIView+SBMODULE.h"

@implementation SBSmallWindowDismissAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return SBSmallWindowDismissDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    [self commonInit:transitionContext];
    [self dismissSmallWindow:transitionContext];
}

- (void)commonInit:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    
    self.toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    self.toView.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
    self.toView.userInteractionEnabled = YES;
}

- (void)dismissSmallWindow:(id <UIViewControllerContextTransitioning>)transitionContext {
    [UIView animateWithDuration:SBSmallWindowDismissDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.fromView.alpha = 0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        
        self.fromView.alpha = 1;
        if (self.dismissWindowBlock) {
            self.dismissWindowBlock();
        }
    }];
}

@end


@implementation SBDismissToBottomAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return SBSmallWindowDismissDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    [self commonInit:transitionContext];
    [self dismissSmallWindow:transitionContext];
}


- (void)dismissSmallWindow:(id <UIViewControllerContextTransitioning>)transitionContext {
    [transitionContext.containerView layoutIfNeeded];
    [UIView animateWithDuration:SBSmallWindowDismissDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.fromView.top = transitionContext.containerView.bottom;
        [transitionContext.containerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        
        if (self.dismissWindowBlock) {
            self.dismissWindowBlock();
        }
    }];
}

@end

@implementation SBDismissToRightAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return SBSmallWindowDismissDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    [self commonInit:transitionContext];
    [self dismissSmallWindow:transitionContext];
}

- (void)dismissSmallWindow:(id <UIViewControllerContextTransitioning>)transitionContext {
    [transitionContext.containerView layoutIfNeeded];
    [UIView animateWithDuration:SBSmallWindowDismissDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.fromView.left = transitionContext.containerView.right;
        [transitionContext.containerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        
        if (self.dismissWindowBlock) {
            self.dismissWindowBlock();
        }
    }];
}

@end
