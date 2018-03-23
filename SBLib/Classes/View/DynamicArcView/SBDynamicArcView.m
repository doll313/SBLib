//
//  SBDynamicArcView.m
//  SBLib
//
//  Created by roronoa on 2017/7/27.
//  Copyright © 2017年 roronoa. All rights reserved.
//

#import "SBDynamicArcView.h"            //线性转圈
#import "UIImage+SBMODULE.h"

@implementation SBDynamicArcView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        self.image = [UIImage sb_imageWithColor:[UIColor clearColor] withFrame:self.bounds];

        [self initializeReplicatorLayer];
        [self initializeDynamicArc];
    }

    return self;
}


- (void)initializeReplicatorLayer {
    self.replicatorLayer = [[CAReplicatorLayer alloc] init];
    self.replicatorLayer.frame = self.bounds;
    self.replicatorLayer.backgroundColor = [UIColor clearColor].CGColor;

    [self.layer addSublayer:self.replicatorLayer];
}

- (void)initializeDynamicArc {
    self.indicatorCAShapeLayer = [[CAShapeLayer alloc] init];
    self.indicatorCAShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.indicatorCAShapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.indicatorCAShapeLayer.lineWidth = self.width / 24.0f;

    CGFloat length = self.width/5;
    self.indicatorCAShapeLayer.frame = CGRectMake(length, length, length*3, length*3);
    [self.replicatorLayer addSublayer:self.indicatorCAShapeLayer];
}

- (CGPathRef)arcPathWithStartAngle:(CGFloat)startAngle span:(CGFloat)span {
    CGFloat radius = self.width/2 - self.width/5;
    CGFloat x = self.indicatorCAShapeLayer.frame.size.width/2;
    CGFloat y = self.indicatorCAShapeLayer.frame.size.height/2;

    UIBezierPath *arcPath = [UIBezierPath bezierPath];
    [arcPath addArcWithCenter:CGPointMake(x, y) radius:radius startAngle:startAngle endAngle:startAngle+span clockwise:YES];
    return arcPath.CGPath;
}


- (void)addDynamicArcAnimation {
    self.indicatorCAShapeLayer.path = [self arcPathWithStartAngle:-M_PI/2 span:2*M_PI];

    CABasicAnimation *strokeEndAnimation = [[CABasicAnimation alloc] init];
    strokeEndAnimation.keyPath = @"strokeEnd";
    strokeEndAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    strokeEndAnimation.toValue = [NSNumber numberWithFloat:1.0];
    strokeEndAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    strokeEndAnimation.duration = 0.7*2;

    CABasicAnimation *strokeStartAnimation = [[CABasicAnimation alloc] init];
    strokeStartAnimation.keyPath = @"strokeStart";
    strokeStartAnimation.beginTime =strokeEndAnimation.duration/4;
    strokeStartAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    strokeStartAnimation.toValue = [NSNumber numberWithFloat:1.0];
    strokeStartAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    strokeStartAnimation.duration = strokeEndAnimation.duration;

    CABasicAnimation *rotationAnimation = [[CABasicAnimation alloc] init];
    rotationAnimation.keyPath = @"transform.rotation.z";
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    rotationAnimation.toValue = [NSNumber numberWithFloat:2*M_PI];
    rotationAnimation.duration = 2*strokeEndAnimation.duration;
    rotationAnimation.repeatCount = INFINITY;

    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = strokeEndAnimation.duration+strokeStartAnimation.beginTime;
    animationGroup.repeatCount = INFINITY;
    animationGroup.animations = @[strokeEndAnimation, strokeStartAnimation];

    [self.indicatorCAShapeLayer addAnimation:animationGroup forKey:nil];
    [self.indicatorCAShapeLayer addAnimation:rotationAnimation forKey:nil];
}

- (void)removeDynamicArcAnimation {
    [self.indicatorCAShapeLayer removeAllAnimations];
}

@end
