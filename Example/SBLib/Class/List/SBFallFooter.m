//
//  SBFallFooter.m
//  SBLib
//
//  Created by roronoa on 2017/4/13.
//  Copyright © 2017年 yuki.wang. All rights reserved.
//

#import "SBFallFooter.h"
#import "UILabel+SBMODULE.h"            //标签扩展

@interface SBFallFooter()
@property (weak, nonatomic) UILabel *label;
@end

@implementation SBFallFooter

- (void)prepare
{
    [super prepare];

    //标签
    UILabel *label = [[UILabel alloc] init];
    [label sb_cellLabel];
    [self addSubview:label];

    self.label = label;
}

- (void)placeSubviews
{
    [super placeSubviews];

    self.label.frame = self.bounds;
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;

    switch (state) {
        case MJRefreshStateIdle:
            self.label.text = @"abc…";
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"123…";
            break;
        case MJRefreshStateNoMoreData:
            self.label.text = @"9999999!";
            break;
        default:
            break;
    }
}

@end
