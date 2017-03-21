/*
#####################################################################
# File    : TableViewData.h
# Project : 
# Created : 2013-03-30
# DevTeam : Thomas Develop
# Author  : 
# Notes   :
#####################################################################
### Change Logs   ###################################################
#####################################################################
---------------------------------------------------------------------
# Date  :
# Author:
# Notes :
#
#####################################################################
*/


#import "SBHttpDataLoader.h"

@class SBTableView;
@class SBTableData;
@protocol SBTableViewCellDelegate;

//列表数据封装
@interface SBTableData : NSObject<SBHttpDataLoaderDelegate> {
}

/**  普通Cell的class */
@property (nonatomic, assign) Class<SBTableViewCellDelegate>   mDataCellClass; 

/**  空Cell的class */
@property (nonatomic, assign) Class<SBTableViewCellDelegate>   mEmptyCellClass;

/**  错误信息Cell的class */
@property (nonatomic, assign) Class<SBTableViewCellDelegate>   mErrorCellClass;

/**  重新加载加载中 Cell的class */
@property (nonatomic, assign) Class<SBTableViewCellDelegate>   mLoadingCellClass;

/** 更多Cell的class */
@property (nonatomic, assign) Class<SBTableViewCellDelegate>   mMoreCellClass;

/** 列表都结束后，最后多出的一个单元格Cell的class */
@property (nonatomic, assign) Class<SBTableViewCellDelegate>   mFinishedCellClass;

@property (nonatomic, weak) SBTableView *tableView;           //列表数据对应的列表
@property (nonatomic, assign) NSInteger tag;                //一个tag，没事情别乱用

@property (nonatomic, strong) DataItemResult *tableDataResult;          //列表数据

@property (nonatomic, retain) SBHttpDataLoader *dataLoader;            //数据请求句柄
@property (nonatomic, copy) NSString  *headerTitle;                 //段标题

@property (nonatomic, assign) SBTableDataStatus httpStatus;      //状态
@property (nonatomic, assign) NSUInteger pageAt;            //pageAt即是tailPage
@property (nonatomic, readonly) NSUInteger totalPage;               //数据总大小
@property (nonatomic, assign) NSUInteger pageSize;              //每页的数据大小
@property (nonatomic, assign) BOOL isLoadDataOK;                //是否加载完毕
@property (nonatomic, assign) BOOL hasFinishCell;                //是否有显示完毕的单元格
@property (nonatomic, assign) BOOL hasHeaderView;                   //是否有悬浮段头
@property (nonatomic, assign) BOOL hasFooterView;                   //是否有悬浮段尾
@property (nonatomic, assign) BOOL isEmptyCellEnableClick;                   //空单元格是否允许点击 默认no
@property (nonatomic, assign) CGFloat emptyCellHeight;                   //空列表的高度 （指定空单元格的高度）
@property (nonatomic, assign) CGFloat loadingCellHeight;                   //加载列表的高度 （指定加载单元格的高度）
@property (nonatomic, strong) NSDate *lastUpdateTime;               //最后刷新时间

//刷新数据
- (void)refreshData;

//加载数据
- (void)loadData;

//停止加载数据
- (void)stopLoadData;

//清除数据
- (void)clearData;

//加载下一页的数据
- (void)loadDataforNextPage;

//缓存列表数据 只对第一页做处理
- (BOOL)storeCacheData:(NSString *)cacheKey cacheData:(DataItemResult *)cacheResult;

//加载列表缓存 只对第一页做处理
- (DataItemResult *)loadCacheData:(NSString *)cacheKey;

//清理并添加列表数据
- (void)clearAndLoadResult:(DataItemResult *)result;

//加载完毕，并且这里的意思是没有后续数据了，对应 hasNextPage 方法
- (BOOL)isLoadDataComplete;

//销毁数据
- (void)dispatchView;

@end
