//
//  SBRefreshHeader.h
//  Pods
//
//  Created by roronoa on 2017/7/4.
//
//  橡皮糖刷新头

#import <UIKit/UIKit.h>

@interface SBRefreshHeader : UIView

/** 是否正在刷新 */
@property (nonatomic, assign, readonly) BOOL isRefreshing;

/** 便利构造器 */
+ (instancetype)headerWithRefreshingBlock:(void(^)(void))refreshBlock;

/** 开始刷新 */
- (void)beginRefreshing;

/** 结束刷新 */
- (void)endRefreshing;

@end


@interface UIScrollView (sbmoudle)
@property (nonatomic, strong) SBRefreshHeader *mj_header;           //注意 这个名字一定要叫 mj_header  否则做不了这个功能
@end
