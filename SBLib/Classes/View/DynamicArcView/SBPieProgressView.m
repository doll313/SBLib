//
//  SBPieProgressView.m
//  SBLib
//
//  Created by roronoa on 2017/4/13.
//  Copyright © 2017年 roronoa. All rights reserved.
//

#import "SBPieProgressView.h"           //转圈进度
#import "SBCONSTANT.h"

@implementation SBPieProgressView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;


    CGFloat radius = MIN(rect.size.width * 0.5, rect.size.height * 0.5) - 10;

    // 背景遮罩
    [RGB_A(240, 240, 240, 0.7) set];
//    CGFloat lineW = MAX(rect.size.width, rect.size.height) * 0.5;
//    CGContextSetLineWidth(ctx, lineW);
//    CGContextAddArc(ctx, xCenter, yCenter, radius + lineW * 0.5 + 5, 0, M_PI * 2, 1);
//    CGContextStrokePath(ctx);

    // 进程圆
    //[SDColorMaker(0, 0, 0, 0.3) set];
    CGContextSetLineWidth(ctx, 1);
    CGContextMoveToPoint(ctx, xCenter, yCenter);
    CGContextAddLineToPoint(ctx, xCenter, 0);
    CGFloat to = - M_PI * 0.5 + self.progress * M_PI * 2 + 0.001; // 初始值
    CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 1);
    CGContextClosePath(ctx);

    CGContextFillPath(ctx);
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;

    if (progress >= 1.0 || progress <= 0) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
        [self setNeedsDisplay];
    }
}

- (void)setCenterProgressText:(NSString *)text withAttributes:(NSDictionary *)attributes
{
    CGFloat xCenter = self.frame.size.width * 0.5;
    CGFloat yCenter = self.frame.size.height * 0.5;

    CGSize strSize = [text sizeWithAttributes:attributes];
    CGFloat strX = xCenter - strSize.width * 0.5;
    CGFloat strY = yCenter - strSize.height * 0.5;
    [text drawAtPoint:CGPointMake(strX, strY) withAttributes:attributes];
}

// 清除指示器
- (void)dismiss
{
    self.progress = 1.0;
}

+ (id)progressView
{
    return [[self alloc] init];
}


@end
