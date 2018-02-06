//
//  SBSmallWindowPresentAnimator.m
//  SBLib
//
//  Created by thomas on 2017/7/6.
//  Copyright © 2017年 roronoa. All rights reserved.
//

#import "SBSmallWindowPresentAnimator.h"
#import "SBSmallWindow.h"
#import "UIView+SBMODULE.h"

@implementation SBSmallWindowPresentAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIView *containerView = transitionContext.containerView;
    
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    fromView.userInteractionEnabled = NO;
    
    self.toCtrl = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = self.toCtrl.view;
    
    UIView *maskView = [[UIView alloc] initWithFrame:fromView.bounds];
    maskView.backgroundColor = self.toCtrl.hideMask ? [UIColor clearColor] : [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    if (self.toCtrl.needTapGesture) {
        [maskView sb_setTapGesture:self action:@selector(dismissSmallWindow:)];
    }

    [containerView addSubview:maskView];
    [containerView addSubview:toView];

    maskView.frame = containerView.bounds;

    toView.width = self.toCtrl.windowW;
    toView.height = self.toCtrl.windowH;
    CGFloat top = self.toCtrl.windowY;
    CGFloat left = (containerView.width - toView.width) / 2;
    CGFloat width = self.toCtrl.windowW;
    CGFloat height = self.toCtrl.windowH;

    if (top == -1) {//默认上下居中
        top = (containerView.height - toView.height) / 2;
        top = MAX(top, 10);
    }

    if (width == 0) {
        width = toView.width;
    }

    if (width == 0) {
        height = toView.height;
    }

    toView.left = left;
    toView.top = top;
    toView.width = width;
    toView.height = height;
    
    toView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8f, 0.8f);
    [UIView animateWithDuration:[self transitionDuration:transitionContext] // 动画时长
                          delay:0.0 // 动画延迟
         usingSpringWithDamping:0.5 // 类似弹簧振动效果 0~1
          initialSpringVelocity:5.0 // 初始速度
                        options:UIViewAnimationOptionCurveEaseInOut // 动画过渡效果
                     animations:^{
                         toView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
    
}

- (void)dismissSmallWindow:(id)sender {
    [self.toCtrl dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)hasTextFieldInView:(UIView *)view {
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[UITextField class]]) {
            return YES;
        } else {
            if ([self hasTextFieldInView:v]) {
                return YES;
            }
        }
    }
    return NO;
}


@end

@implementation SBPresentFromBottomAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIView *containerView = transitionContext.containerView;
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    fromView.userInteractionEnabled = NO;
    
    self.toCtrl = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = self.toCtrl.view;

    UIView *maskView = [[UIView alloc] initWithFrame:fromView.bounds];
    maskView.backgroundColor = self.toCtrl.hideMask ? [UIColor clearColor] : [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    if (self.toCtrl.needTapGesture) {
        [maskView sb_setTapGesture:self action:@selector(dismissSmallWindow:)];
    }
    [containerView addSubview:maskView];
    [containerView addSubview:toView];

    maskView.frame = containerView.bounds;
    
    if (self.toCtrl.isFullWidth) {
        toView.top = containerView.bottom;
        toView.width = containerView.width;
        if (self.toCtrl.windowH > 0) {
            toView.height = self.toCtrl.windowH;
        }
    } else{
        CGFloat left = (containerView.width - toView.width) / 2;
        toView.top = containerView.bottom;
        toView.left = left;

        //外面写死高宽的情况
        if (self.toCtrl.windowH > 0) {
            toView.height = self.toCtrl.windowH;
        }
        if (self.toCtrl.windowW) {
            toView.width = self.toCtrl.windowW;
        }
    }

    [containerView layoutIfNeeded];

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        maskView.backgroundColor = self.toCtrl.hideMask ? [UIColor clearColor] : [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        toView.bottom = containerView.bottom;
        [containerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

- (void)dismissSmallWindow:(id)sender {
    [self.toCtrl dismissViewControllerAnimated:YES completion:nil];
}

@end

