//
//  SBSmallWindowDismissAnimator.h
//  SBLib
//
//  Created by thomas on 2017/7/6.
//  Copyright © 2017年 roronoa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define SBSmallWindowDismissDuration   0.3f

/**一般消失*/
@interface SBSmallWindowDismissAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, copy) void(^dismissWindowBlock)(void); //弹窗消失完成回调

// 注意 下面都是指向 assign类型，不会增加内存
@property (nonatomic, assign) UIView *fromView; //来源视图
@property (nonatomic, assign) UIView *toView; //显示视图

@end


@interface SBDismissToBottomAnimator : SBSmallWindowDismissAnimator

@end


@interface SBDismissToRightAnimator : SBSmallWindowDismissAnimator

@end
