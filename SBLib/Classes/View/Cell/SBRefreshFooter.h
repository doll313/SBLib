//
//  SBRefreshFooter.h
//  Pods
//
//  Created by roronoa on 2017/9/7.
//
//

#import <MJRefresh/MJRefresh.h>

@interface SBRefreshFooter : MJRefreshAutoFooter

//提前加载高度  百分比  对应所在的 scroller  默认是 0
@property (nonatomic, assign) CGFloat preAutomaticallyHeightPercent;

//是否提前加载标志位
@property (nonatomic, assign) BOOL hasPreRefreshed;

@end
