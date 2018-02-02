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

/**一般弹窗，默认在中间*/
@interface SBSmallWindowPresentAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) SBSmallWindow *toCtrl;       //所处控制器

@end


/**从下弹窗，在底部*/
@interface ELPresentFromBottomAnimator : SBSmallWindowPresentAnimator

@end

