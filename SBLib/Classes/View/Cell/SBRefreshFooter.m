//
//  SBRefreshFooter.m
//  Pods
//
//  Created by roronoa on 2017/9/7.
//
//

#import "SBRefreshFooter.h"
#import "SBNetworkReachability.h"

@implementation SBRefreshFooter

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];

    if (self.state != MJRefreshStateIdle || !self.automaticallyRefresh || self.mj_y == 0) return;

    //非wifi下 忽略预加载
    if (SBGetNetworkReachability() != SBNetworkReachabilityWifi) return;

    if (self.preAutomaticallyHeightPercent == 0) return;

    CGFloat contentH = _scrollView.mj_contentH;
    CGFloat fH = _scrollView.mj_h;
    if (_scrollView.mj_insetT + contentH > fH) { // 内容超过一个屏幕
        // 这里的_scrollView.mj_contentH替换掉self.mj_y更为合理
        if (self.state == MJRefreshStateNoMoreData) {
            return;
        }

        if (self.hasPreRefreshed) {
            return;
        }

        CGFloat preRefreshingInsetHeight = self.preAutomaticallyHeightPercent * fH;
        CGFloat triggerHeight = self.mj_h * self.triggerAutomaticallyRefreshPercent;
        CGFloat sb_offsetY = contentH - fH + triggerHeight + _scrollView.mj_insetB - self.mj_h - preRefreshingInsetHeight;
        if (_scrollView.mj_offsetY >= sb_offsetY) {
            // 防止手松开时连续调用
            CGPoint old = [change[@"old"] CGPointValue];
            CGPoint new = [change[@"new"] CGPointValue];
            if (new.y <= old.y) return;

            // 当底部刷新控件完全出现时，才刷新
            [self beginRefreshing];
            self.hasPreRefreshed = YES;
        }
    }
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];

    self.hasPreRefreshed = NO;
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

@end
