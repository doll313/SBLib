//
//  SBSmallWindowPresentAnimator.h
//  SBLib
//
//  Created by thomas on 2017/7/6.
//  Copyright © 2017年 roronoa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class SBSmallWindow;

#define SBSmallWindowPresentDuration   0.3f

/**一般弹窗，默认在中间*/
@interface SBSmallWindowPresentAnimator : NSObject <UIViewControllerAnimatedTransitioning>


@property (nonatomic, copy) void(^tapBlankBlock)(void); //点击空白回调
@property (nonatomic, copy) void(^dismissWindowBlock)(void); //弹窗消失完成回调

// 注意 下面都是指向 assign类型，不会增加内存
@property (nonatomic, assign) SBSmallWindow *toCtrl;       //所处控制器
@property (nonatomic, assign) UIView *containerView; //承载视图
@property (nonatomic, assign) UIView *fromView; //来源视图
@property (nonatomic, assign) UIView *toView; //显示视图
@property (nonatomic, strong) UIView *maskView; //蒙层  strong


- (void)dismissSmallWindow:(id)sender;

@end


/**从下弹窗，在底部*/
@interface SBPresentFromBottomAnimator : SBSmallWindowPresentAnimator

@end



/**从右弹窗，在右侧*/
@interface SBPresentFromRightAnimator : SBSmallWindowPresentAnimator

@end
