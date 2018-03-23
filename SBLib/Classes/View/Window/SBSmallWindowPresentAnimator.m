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

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return SBSmallWindowPresentDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    [self commonInit:transitionContext];
    [self presentSmallWindow:transitionContext];
    
}

- (void)commonInit:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.containerView = transitionContext.containerView;
    
    self.fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    self.fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    self.fromView.userInteractionEnabled = NO;
    
    self.toCtrl = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    self.toView = self.toCtrl.view;
    
    self.maskView = [[UIView alloc] initWithFrame:self.fromView.bounds];
    [self.maskView sb_setTapGesture:self action:@selector(dismissSmallWindow:)];
    
    [self.containerView addSubview:self.maskView];
    [self.containerView addSubview:self.toView];
    
    self.maskView.frame = self.containerView.bounds;
}

- (void)presentSmallWindow:(id <UIViewControllerContextTransitioning>)transitionContext  {
    self.toView.width = self.toCtrl.windowW;
    self.toView.height = self.toCtrl.windowH;
    CGFloat top = self.toCtrl.windowY;
    CGFloat left = (self.containerView.width - self.toView.width) / 2;
    CGFloat width = self.toCtrl.windowW;
    CGFloat height = self.toCtrl.windowH;
    
    if (top == -1) {//默认上下居中
        top = (self.containerView.height - self.toView.height) / 2;
        top = MAX(top, 10);
    }
    
    if (width == 0) {
        width = self.toView.width;
    }
    
    if (width == 0) {
        height = self.toView.height;
    }
    
    self.toView.left = left;
    self.toView.top = top;
    self.toView.width = width;
    self.toView.height = height;
    
    self.toView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8f, 0.8f);
    [UIView animateWithDuration:SBSmallWindowPresentDuration // 动画时长
                          delay:0.0 // 动画延迟
         usingSpringWithDamping:0.5 // 类似弹簧振动效果 0~1
          initialSpringVelocity:5.0 // 初始速度
                        options:UIViewAnimationOptionCurveEaseInOut // 动画过渡效果
                     animations:^{
                         self.maskView.backgroundColor = self.toCtrl.hideMask ? [UIColor clearColor] : [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
                         self.toView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}


- (void)dismissSmallWindow:(id)sender {
    if (self.tapBlankBlock) {
        self.tapBlankBlock();
    }
    
    if (self.toCtrl.needTapGesture) {
        [self.toCtrl dismissViewControllerAnimated:YES completion:^{
            if (self.dismissWindowBlock) {
                self.dismissWindowBlock();
            }
        }];
    }
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
    return SBSmallWindowPresentDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    [self commonInit:transitionContext];
    [self presentSmallWindow:transitionContext];
    
}

//重写
- (void)presentSmallWindow:(id <UIViewControllerContextTransitioning>)transitionContext  {
    
    if (self.toCtrl.isFullWidth) {
        self.toView.top = self.containerView.bottom;
        self.toView.width = self.containerView.width;
        if (self.toCtrl.windowH > 0) {
            self.toView.height = self.toCtrl.windowH;
        }
    } else{
        CGFloat left = (self.containerView.width - self.toView.width) / 2;
        self.toView.top = self.containerView.bottom;
        self.toView.left = left;
        
        //外面写死高宽的情况
        if (self.toCtrl.windowH > 0) {
            self.toView.height = self.toCtrl.windowH;
        }
        if (self.toCtrl.windowW) {
            self.toView.width = self.toCtrl.windowW;
        }
    }
    
    [self.containerView layoutIfNeeded];
    
    [UIView animateWithDuration:SBSmallWindowPresentDuration animations:^{
        self.maskView.backgroundColor = self.toCtrl.hideMask ? [UIColor clearColor] : [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        self.toView.bottom = self.containerView.bottom;
        [self.containerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end

@implementation SBPresentFromRightAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return SBSmallWindowPresentDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    [self commonInit:transitionContext];
    [self presentSmallWindow:transitionContext];
}

//重写
- (void)presentSmallWindow:(id <UIViewControllerContextTransitioning>)transitionContext  {
    if (self.toCtrl.isFullHeight) {
        self.toView.top = 0;
        self.toView.height = self.containerView.height;
        self.toView.left = self.containerView.right;
        if (self.toCtrl.windowW > 0) {
            self.toView.width = self.toCtrl.windowW;
        }
    } else{
        
        self.toView.left = self.containerView.right;
        self.toView.centerY = self.containerView.height / 2;
        //外面写死高宽的情况
        if (self.toCtrl.windowH > 0) {
            self.toView.height = self.toCtrl.windowH;
        }
        if (self.toCtrl.windowW) {
            self.toView.width = self.toCtrl.windowW;
        }
    }
    
    [self.containerView layoutIfNeeded];
    [UIView animateWithDuration:SBSmallWindowPresentDuration animations:^{
        self.maskView.backgroundColor = self.toCtrl.hideMask ? [UIColor clearColor] : [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        
        self.toView.right = self.containerView.right;
        
        [self.containerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}
@end


