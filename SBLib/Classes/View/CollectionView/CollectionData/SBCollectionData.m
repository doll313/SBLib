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

#import "SBCollectionData.h"        //Collection数据

@implementation SBCollectionData

#pragma mark -
#pragma mark 生命周期
- (id)init {
    self = [super init];
    
    if (self) {
        self.tableDataResult = [[DataItemResult alloc] init];
        self.httpStatus = SBTableDataStatusNotStart;         //默认没开始加载
        self.pageAt = 1;                //默认第一页
        self.pageSize = 20;             //默认一页xx条
        self.isLoadDataOK = YES;             //默认加载完毕      //加载单元格的高度
        
        self.tag = 0;
        
        self.mDataCellClass  = nil;
        self.mErrorCellClass = [SBErrorCollectionCell class];
        self.mEmptyCellClass = [SBEmptyCollectionCell class];
        self.mMoreCellClass  = [SBMoreCollectionCell class];
        self.mLoadingCellClass = [SBLoadingCollectionCell class];
        self.mFinishedCellClass = [SBFinishedCollectionCell class];
    }
    
    return self;
}

- (void)dealloc {
    [self.dataLoader stopLoading];
}

//总页数
- (NSUInteger)totalPage {
    NSUInteger totalPage = (NSUInteger)ceilf((float)self.tableDataResult.maxCount / self.pageSize);
    return totalPage;
}

#pragma mark -
#pragma mark 数据操作
//刷新数据
- (void)refreshData {
    //数据不在加载状态
    if (self.httpStatus == SBTableDataStatusLoading) {
        return;
    }
    
    //从第一页开始
    self.pageAt = 1;
    
    //下拉刷新效果
    if (self.collectionView.isRefreshType) {
        //这里beginrefersh后会自动进入 回调 不要人为再发起请求
        [self.collectionView.mj_header beginRefreshing];
    }else {
        //加载数据
        [self loadData];
    }
    
}

//加载数据
- (void)loadData {
    if(!self.collectionView) {
        return;
    }
    
    //将要发起请求
    if (self.collectionView.willRequestData) {
        self.collectionView.willRequestData(self);
    }
    
    //记载状态
    self.httpStatus = SBTableDataStatusLoading;
    
    if (self.pageAt == 1) {
        //如果是下拉列表
        if (!self.collectionView.isRefreshType) {
            //删除老数据
            [self.tableDataResult clear];
            
            //显示刷新样式
            [self.collectionView reloadData];
        }
    }
    else {
        //显示刷新样式
        [self.collectionView reloadData];
    }
    
    
    //获取网络接口
    [self.dataLoader stopLoading];
    
    NSAssert(NULL != self.collectionView.requestData, @"请求数据不允许不实现");
    //发起请求
    self.dataLoader = self.collectionView.requestData(self);
}


//停止加载数据
- (void)stopLoadData {
    self.httpStatus = SBTableDataStatusFinished;
    [self.dataLoader stopLoading];
    [self.collectionView reloadData];
}

//清除数据
- (void)clearData {
    [self.tableDataResult clear];
    self.httpStatus = SBTableDataStatusNotStart;         //默认没开始加载
    self.pageAt = 1;                //默认第一页
}

//加载下一页
- (void)loadDataforNextPage {
    if ([self isLoadDataComplete]) {
        return;
    }
    
    //页码自动加1 并加载数据
    self.pageAt++;
    
    [self loadData];
}

//缓存列表数据
- (BOOL)storeCacheData:(NSString *)cacheKey cacheData:(DataItemResult *)cacheResult {
    //确保列表不为空
    if(nil == self.collectionView) {
        return NO;
    }
    
    //只缓存第一页的数据
    if (self.pageAt != 1) {
        return NO;
    }
    
    //存入数据库
    [[SBAppCoreInfo getCacheDB] setResultValue:STORE_CACHE_TABLEDATA dataKey:cacheKey data:cacheResult];
    
    return YES;
}

//加载列表缓存
- (DataItemResult *)loadCacheData:(NSString *)cacheKey {
    if(nil == self.collectionView) {
        return nil;
    }
    
    //只缓存第一页的数据
    if (self.pageAt != 1) {
        return nil;
    }
    
    //缓存数据
    DataItemResult *cacheResult = [[SBAppCoreInfo getCacheDB] getResultValue:STORE_CACHE_TABLEDATA dataKey:cacheKey];
    if (cacheResult.count == 0) {
        return nil;
    }
    
    return cacheResult;
}

//清理并添加列表数据
- (void)clearAndLoadResult:(DataItemResult *)result {
    if (result == nil || result.count == 0) {
        return;
    }
    
    //这里注意了，有可能是什么数据页没处理过的原子添加
    self.httpStatus = SBTableDataStatusFinished;
    [self.tableDataResult clear];
    [self.tableDataResult appendItems:result];
    [self.collectionView reloadData];
}

//网络请求回调
- (void)dataLoader:(SBHttpDataLoader *)dataLoader onReceived:(DataItemResult *)result {
    //列表数据的状态
    self.isLoadDataOK = !result.hasError;
    self.tableDataResult.message = result.message;
    
    //如果是下拉列表
    if (self.collectionView.isRefreshType) {
        //下拉列表下拉请求，加载成功
        if (self.pageAt == 1) {
            //数据如果有问题，则还是上一次的数据
            if (self.isLoadDataOK) {
                
                self.lastUpdateTime = [NSDate new];
                
                //只留下section 0 号
                for (NSInteger i = self.collectionView.arrCollectionData.count; i > 0; i--) {
                    [self.collectionView removeSection:i];
                }
                
                [self.tableDataResult clear];
            }
        }
    }
    
    //加载完毕
    self.httpStatus = SBTableDataStatusFinished;
    
    //接受数据，理论上是必实现的
    if (self.collectionView.receiveData) {
        self.collectionView.receiveData(self.collectionView, self, result);
    }
    
    //如果是下拉列表
    if (self.collectionView.isRefreshType) {
        if (self.pageAt == 1) {
            // 拿到当前的下拉刷新控件，结束刷新状态
            [self.collectionView.mj_header endRefreshing];
        }
    }
    
    // 刷新表格
    [self.collectionView reloadData];
}

//加载完毕，并且这里的意思是没有后续数据
- (BOOL)isLoadDataComplete {
    if (self.httpStatus == SBTableDataStatusFinished) {
        //section 数量
        NSInteger sectionCount = self.collectionView.arrCollectionData.count;
        
        //总数
        NSUInteger maxCount = self.tableDataResult.maxCount;
        
        //目前单元格数
        NSUInteger currentCount = 0;
        for (int i=0; i<sectionCount; i++) {
            SBCollectionData *tableData = [self.collectionView dataOfSection:i];
            currentCount += tableData.tableDataResult.count;
        }
        
        if (maxCount <= currentCount) {
            return YES;
        }
        
    }
    
    return NO;
}

#pragma mark -
#pragma mark 界面操作
//销毁数据加载等
- (void)dispatchView {
    self.collectionView = nil;
    [self.dataLoader stopLoading];
    self.dataLoader = nil;
}

@end
