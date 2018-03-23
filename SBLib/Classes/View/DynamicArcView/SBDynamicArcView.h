//
//  SBDynamicArcView.h
//  SBLib
//
//  Created by roronoa on 2017/7/27.
//  Copyright © 2017年 roronoa. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 加载转圈 我抄的代码 **/
@interface SBDynamicArcView : UIImageView

@property (strong, nonatomic) CAReplicatorLayer *replicatorLayer;
@property (strong, nonatomic) CAShapeLayer *indicatorCAShapeLayer;

/** 开始转圈动画 **/
- (void)addDynamicArcAnimation;

/** 停止转圈动画 **/
- (void)removeDynamicArcAnimation;

@end
