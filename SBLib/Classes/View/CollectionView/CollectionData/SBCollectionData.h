/*
 #####################################################################
 # File    : SBCollectionData.h
 # Project :
 # Created : 2016-05-02
 # DevTeam : thomas only one
 # Author  : roronoa
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

@class SBCollectionView;
@protocol SBCollectionCellDelegate;

//Collection数据
@interface SBCollectionData : NSObject<SBHttpDataLoaderDelegate> 

/**  普通Cell的class */
@property (nonatomic, assign) Class<SBCollectionCellDelegate> mDataCellClass;

/**  空Cell的class */
@property (nonatomic, assign) Class<SBCollectionCellDelegate>   mEmptyCellClass;

/**  错误信息Cell的class */
@property (nonatomic, assign) Class<SBCollectionCellDelegate>   mErrorCellClass;

/**  底部样式 更多 加载 结束 */
@property (nonatomic, assign) Class mFooterClass;


@property (nonatomic, weak) SBCollectionView *collectionView;           //数据对应的
@property (nonatomic, assign) NSInteger tag;                //一个tag，没事情别乱用

@property (nonatomic, strong) DataItemResult *tableDataResult;          //列表数据

@property (nonatomic, retain) SBHttpDataLoader *dataLoader;            //数据请求句柄

@property (nonatomic, assign) SBTableDataStatus httpStatus;      //状态
@property (nonatomic, assign) NSUInteger pageAt;            //pageAt即是tailPage
@property (nonatomic, assign) NSUInteger pageSize;              //每页的数据大小
@property (nonatomic, assign) NSUInteger totalItems;               //当前多少个数据
@property (nonatomic, assign) BOOL isLoadDataOK;                //是否加载完毕
@property (nonatomic, assign) BOOL hasFinishCell;                //是否有显示完毕的单元格
@property (nonatomic, strong) NSDate *lastUpdateTime;               //最后刷新时间
@property (nonatomic, assign) CGFloat emptyItemHeight;                   //空列表的高度 （指定空单元格的高度）


//刷新数据
- (void)refreshData;

//替换数据
- (void)replaceData;

//加载数据
- (void)loadData;

//停止加载数据
- (void)stopLoadData;

//清除数据
- (void)clearData;

//加载下一页的数据
- (void)loadDataforNextPage;

//加载完毕，并且这里的意思是没有后续数据了，对应 hasNextPage 方法
- (BOOL)isLoadDataComplete;

//配置参数项
- (void)createParams;

//配置单元格项
- (void)createCellClass;

//缓存列表数据
- (BOOL)storeCacheData:(NSString *)cacheKey cacheData:(DataItemResult *)cacheResult;

//加载列表缓存
- (DataItemResult *)loadCacheData:(NSString *)cacheKey;

//清理并添加列表数据
- (void)clearAndLoadResult:(DataItemResult *)result;

//销毁数据
- (void)dispatchView;

#pragma mark -
#pragma mark 默认配置
/** 设置默认的pagesize 大小 **/
+ (void)setDPageSize:(NSInteger)page;

/** 设置默认的空单元格样式 **/
+ (void)setDEmptyCellCls:(NSString *)cString;

/** 设置默认的错误单元格样式 **/
+ (void)setDErrorCellCls:(NSString *)cString;

/** 设置默认的footer样式 **/
+ (void)setDFooterCls:(NSString *)cString;
@end
