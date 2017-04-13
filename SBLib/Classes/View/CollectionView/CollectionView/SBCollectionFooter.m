//
//  SBCollectionFooter.m
//  Pods
//
//  Created by roronoa on 2017/4/13.
//
//

#import "SBCollectionFooter.h"          //底部

@interface SBCollectionFooter()
@property (weak, nonatomic) UILabel *label;
@end

@implementation SBCollectionFooter

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
            self.label.text = @"上拉加载更多…";
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"数据载入中…";
            break;
        case MJRefreshStateNoMoreData:
            self.label.text = @"数据已经加载完毕!";
            break;
        default:
            break;
    }
}

@end
