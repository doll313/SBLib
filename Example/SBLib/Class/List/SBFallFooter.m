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
            self.label.text = @"普通闲置状态…";
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"正在刷新中的状态…";
            break;
        case MJRefreshStateNoMoreData:
            self.label.text = @"所有数据加载完毕，没有更多的数据了!!";
            break;
        default:
            break;
    }
}

@end
