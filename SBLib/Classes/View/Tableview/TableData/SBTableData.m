/*
#####################################################################
# File    : TaleViewData.m
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

#if !__has_feature(objc_arc)

#error "This file should be compiled with ARC!"

#endif

#import "SBTableData.h"
#import "SBTableView.h"
#import "MJRefresh.h"       //下拉表头

#import "SBLoadingTableCell.h"            //加载中
#import "SBEmptyTableCell.h"          //空
#import "SBFinishedTableCell.h"          //完成
#import "SBAppCoreInfo.h"             //应用信息
#import "DataAppCacheDB.h"          //缓存数据库

@implementation SBTableData

#pragma mark -
#pragma mark 生命周期
- (id)init {
	self = [super init];

    if (self) {
		self.tableDataResult = [[DataItemResult alloc] init];
		self.httpStatus = SBTableDataStatusNotStart;         //默认没开始加载
		self.pageAt = 1;                //默认第一页
		self.pageSize = 20;             //默认一页xx条
		self.isLoadDataOK = YES;             //默认加载完毕
        self.isEmptyCellEnableClick = YES;      //默认允许点击
        self.emptyCellHeight = -1;          //给一个负数
        self.loadingCellHeight = APPCONFIG_UI_TABLE_CELL_HEIGHT;        //加载单元格的高度

        self.tag = 0;

        self.mDataCellClass  = nil;
		self.mErrorCellClass = [SBErrorTableCell class];
        self.mEmptyCellClass = [SBEmptyTableCell class];
        self.mMoreCellClass  = [SBMoreTableCell class];
		self.mLoadingCellClass = [SBLoadingTableCell class];
        self.mFinishedCellClass = [SBFinishedTableCell class];
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
    //
    if (!self.tableView.requestData) {
        return;
    }

    //数据不在加载状态
    if (self.httpStatus == SBTableDataStatusLoading) {
        return;
    }

    void (^refreshBlock)() = ^void(){
        //从第一页开始
        self.pageAt = 1;

        //下拉刷新效果
        if (self.tableView.isRefreshType) {
            //这里beginrefersh后会自动进入 回调 不要人为再发起请求
            [self.tableView.mj_header beginRefreshing];
        }else {
            //加载数据
            [self loadData];
        }
    };
    
    if ([NSThread currentThread] != [NSThread mainThread]) {
        dispatch_sync(dispatch_get_main_queue(), refreshBlock);
    }else{
        refreshBlock();
    }
}

//加载数据
- (void)loadData {
	if(!self.tableView) {
        return;
    }

    //
    if (!self.tableView.requestData) {
        return;
    }
    
    //将要发起请求
    if (self.tableView.willRequestData) {
        self.tableView.willRequestData(self);
    }
    
    //记载状态
    self.httpStatus = SBTableDataStatusLoading;
    
    if (self.pageAt == 1) {
        //如果是下拉列表
        if (!self.tableView.isRefreshType) {
            //删除老数据
            [self.tableDataResult clear];
            
            //显示刷新样式
            [self.tableView reloadData];
        }
    }
    else {
        //显示刷新样式
        [self.tableView reloadData];
    }

    [self.dataLoader stopLoading];
    self.dataLoader = self.tableView.requestData(self);
}


//停止加载数据
- (void)stopLoadData {
    self.httpStatus = SBTableDataStatusFinished;
    [self.dataLoader stopLoading];
    [self.tableView reloadData];
}

//清除数据
- (void)clearData {
    [self.tableDataResult clear];
    self.httpStatus = SBTableDataStatusNotStart;         //默认没开始加载
    self.pageAt = 1;                //默认第一页
}

//加载下一页
- (void)loadDataforNextPage {
    //加载完毕或者正在加载
    if (self.httpStatus == SBTableDataStatusLoading || [self isLoadDataComplete]) {
        return;
    }

    //上次请求成功的情况下
    if (self.isLoadDataOK || self.pageAt == 1) {
        //页码自动加1 并加载数据
        self.pageAt++;
    }
    
	[self loadData];
}

//缓存列表数据
- (BOOL)storeCacheData:(NSString *)cacheKey cacheData:(DataItemResult *)cacheResult {
    //确保列表不为空
    if(nil == self.tableView) {
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
    if(nil == self.tableView) {
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
    [self.tableView reloadData];
}

//网络请求回调
- (void)dataLoader:(SBHttpDataLoader *)dataLoader onReceived:(DataItemResult *)result {
    //列表数据的状态
    self.isLoadDataOK = !result.hasError;
    self.tableDataResult.message = result.message;
    
    //如果是下拉列表
    if (self.tableView.isRefreshType) {
        //下拉列表下拉请求，加载成功
        if (self.pageAt == 1 && self == self.tableView.arrTableData.firstObject) {
            //数据如果有问题，则还是上一次的数据
            if (self.isLoadDataOK) {
                
                self.lastUpdateTime = [NSDate new];
                
                //只留下section 0 号
                for (NSInteger i = self.tableView.arrTableData.count; i > 0; i--) {
                    [self.tableView removeSection:i];
                }
                
                [self.tableDataResult clear];
            }
        }
    }
    
    //接受数据，理论上是必实现的
	if (self.tableView.receiveData) {
        self.tableView.receiveData(self.tableView, self, result);
    }

    // 刷新表格
    [self.tableView reloadData];
    
    //如果是下拉列表
    if (self.tableView.isRefreshType) {
        if (self.pageAt == 1) {
            // 拿到当前的下拉刷新控件，结束刷新状态
            [self.tableView.mj_header endRefreshing];
        }
    }

    //加载完毕
    self.httpStatus = SBTableDataStatusFinished;
}

//加载完毕，并且这里的意思是没有后续数据
- (BOOL)isLoadDataComplete {
	if (self.httpStatus == SBTableDataStatusFinished) {
        //section 数量
        NSInteger sectionCount = self.tableView.arrTableData.count;
        
        //总数
        NSUInteger maxCount = self.tableDataResult.maxCount;
        
        //目前单元格数
        NSUInteger currentCount = 0;
        for (int i=0; i<sectionCount; i++) {
            SBTableData *tableData = [self.tableView dataOfSection:i];
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
    self.tableView = nil;
    [self.dataLoader stopLoading];
    self.dataLoader = nil;
}

@end
