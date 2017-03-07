 /*
 #####################################################################
 # File    : SBCollectionView.h
 # Project :
 # Created : 2016-05-02
 # DevTeam : thomas only one
 # Author  : roronoa
 # Notes   : 封装UICollectionView
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

#import "SBCollectionView.h"            //Collcetion 控件
#import "SBCollectionFlowLayout.h"

@implementation SBCollectionView


#pragma mark -
#pragma mark 生命周期

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    self.backgroundColor = [UIColor clearColor];
    
    self.flowLayout = layout;
    
    //列表数据
    self.arrCollectionData = [[NSMutableArray alloc] init];
    
    //列表配制
    self.dataSource = self;
    self.delegate = self;
    self.alwaysBounceVertical = YES;
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self = [self initWithFrame:frame collectionViewLayout:flowLayout];
    return self;
}

- (void)dealloc {
    self.delegate = nil;
    self.dataSource = nil;
}

//重写设置下拉
- (void)setIsRefreshType:(BOOL)isRefreshType {
    _isRefreshType = isRefreshType;

    [self reloadRefreshHeader];
}

//更新刷新头部
- (void)reloadRefreshHeader {
    if(_isRefreshType){
        SBWS(__self)
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [__self doRefreshData];
        }];
    }else{
        self.mj_header = nil;
    }
}

//一次刷新
- (void)doRefreshData {
    //0号位的段数据 重新请求数据
    SBCollectionData *sectionData = [self dataOfSection:0];
    //从第一页开始
    sectionData.pageAt = 1;
    //加载数据
    [sectionData loadData];
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.referenceSizeForHeader) {
        return self.referenceSizeForHeader(self, collectionViewLayout, section);
    }
    return CGSizeMake(CGRectGetWidth(self.bounds), 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (self.referenceSizeForFooter) {
        return self.referenceSizeForFooter(self, collectionViewLayout, section);
    }
    return CGSizeMake(CGRectGetWidth(self.bounds), 0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (self.insetForSection) {
        return self.insetForSection(self, collectionViewLayout, section);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SBCollectionData *sectionData = [self dataOfSection:indexPath.section];
//    DataItemDetail *itemDetail = [self dataOfIndexPath:indexPath];
    NSUInteger rowCount = [sectionData.tableDataResult count];
    
    CGFloat width = CGRectGetWidth(collectionView.bounds);
    CGFloat height = CGRectGetHeight(collectionView.bounds);
        
    //加载状态，显示加载样式
    if (SBTableDataStatusLoading == sectionData.httpStatus && indexPath.row >= [sectionData.tableDataResult count]) {
        return CGSizeMake(width, APPCONFIG_UI_TABLE_CELL_HEIGHT);
    }
    //数据空 或 错误
    else if (rowCount == 0 && sectionData.pageAt == 1) {
        //如果明确的给过高度
        if (sectionData.emptyItemHeight >= APPCONFIG_UI_TABLE_CELL_HEIGHT) {
            return CGSizeMake(width, sectionData.emptyItemHeight);
        }
        return CGSizeMake(width, height);
    }
    //这里是最后一行，一般是出错了，加载中的单元格样式
    else {
        if (indexPath.row >= rowCount) {
            CGFloat left = 0;
            if ([self.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
                UICollectionViewFlowLayout *fLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
                UIEdgeInsets sectionInset = [fLayout sectionInset];
                left = sectionInset.left;
            }
            return CGSizeMake(width - left * 2, APPCONFIG_UI_TABLE_CELL_HEIGHT);
        }
        //正常数据
        else {
            if (self.sizeForItem) {
                return self.sizeForItem(self, collectionViewLayout, indexPath);
            } else {
                return CGSizeMake(width / 2, width / 2);
            }
        }
    }
}

#pragma mark - UICollectionView DataSource && Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SBCollectionData *sectionData = [self dataOfSection:indexPath.section];
    if (!sectionData) {
        NSAssert(nil != sectionData, @"不允许没有列表数据");
        return nil;
    }
    
    DataItemDetail *itemDetail = [self dataOfIndexPath:indexPath];
    NSString *cellIdentifier = nil;
    
    //加载状态，显示加载样式
    if (SBTableDataStatusLoading == sectionData.httpStatus && indexPath.row >= [sectionData.tableDataResult count]) {
        cellIdentifier = [self cellWithIdentifier:sectionData.mLoadingCellClass];
    }
    //这里是最后一行，一般是出错了，加载中的单元格样式
    else {
        //无数据
        if ([sectionData.tableDataResult count] == 0) {
            //加载失败
            if(!sectionData.isLoadDataOK) {
                if (sectionData.pageAt == 1) {
                    cellIdentifier = [self cellWithIdentifier:sectionData.mErrorCellClass];
                } else {
                    cellIdentifier = [self cellWithIdentifier:[SBErrorCollectionCell class]];
                }
            } else {
                cellIdentifier = [self cellWithIdentifier:sectionData.mEmptyCellClass];
            }
        }
        //超出数据
        else if (indexPath.row >= [sectionData.tableDataResult count]) {
            //加载完单元格
            if (sectionData.hasFinishCell && sectionData.isLoadDataComplete) {
                cellIdentifier = [self cellWithIdentifier:sectionData.mFinishedCellClass];
            }
            //加载失败
            else if(!sectionData.isLoadDataOK) {
                cellIdentifier = [self cellWithIdentifier:[SBErrorCollectionCell class]];
            }
            //更多
            else {
                cellIdentifier = [self cellWithIdentifier:sectionData.mMoreCellClass];
            }
        }
        //正常数据
        else {
            //修改数据
            if(NULL != self.modifiItemClass) {
                Class modifiRowClass = self.modifiItemClass(self, sectionData.mDataCellClass, indexPath);
                [self registerClass:modifiRowClass];
                cellIdentifier = [self cellWithIdentifier:modifiRowClass];
            } else {
                cellIdentifier = [self cellWithIdentifier:sectionData.mDataCellClass];
            }
        }
    }
    
    
    UICollectionViewCell<SBCollectionCellDelegate> *cell = [self dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    assert(nil != cell);
    
    cell.collectionView = self;
    cell.collectionData = sectionData;
    cell.indexPath = indexPath;
    cell.itemDetail = itemDetail;
    
    //绑定数据
    [cell bindItemData];
    
    return cell;
}

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (self.viewForSupplementaryElement) {
        return self.viewForSupplementaryElement(self, kind, indexPath);
    }
    
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    SBCollectionData *sectonData = [self dataOfSection:section];
    
    assert(nil != sectonData);
    
    NSUInteger rowCount = [sectonData.tableDataResult count];
    
    SBTableDataStatus tableDataStatus = sectonData.httpStatus;
    
    if (tableDataStatus == SBTableDataStatusNotStart) {
        //无加载情况，显示数等于数据个数 （多半是无网络请求的）
        return rowCount;
    }
    
    //加载中
    else if (tableDataStatus == SBTableDataStatusLoading) {
        if (self.isRefreshType && sectonData.pageAt == 1) {
            return rowCount;
        }else {
            return rowCount + 1;
        }
    }
    //加载完毕
    else {
        //如果不是最后一个section
        if (sectonData != self.arrCollectionData.lastObject) {
            return rowCount;
        }
        else {
            //无数据，加载完毕
            if (rowCount == 0) {
                //空单元格
                return 1;
            }
            //有数据，加载完毕
            else {
                if ([sectonData isLoadDataComplete]) {
                    //最后一个已完成
                    if (!sectonData.hasFinishCell) {
                        return rowCount;
                    }
                    //加载更多 或 已完成
                    else {
                        return rowCount + 1;
                    }
                }
                //有更多数据
                else {
                    return rowCount + 1;
                }
            }
        }
    }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [self.arrCollectionData count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    DataItemDetail *detail = [self dataOfIndexPath:indexPath];
    SBCollectionData *sectionData = [self dataOfSection:indexPath.section];
    
    assert(nil != sectionData);
    assert(indexPath.row >= 0);
    
    //数据状态
    SBTableDataStatus httpStatus = sectionData.httpStatus;
    NSUInteger rowCount = [sectionData.tableDataResult count];
    
    //异常情况 点击让用户重试
    if (indexPath.row >= rowCount) {
        //以下是默认的错误处理
        if (SBTableDataStatusFinished == httpStatus) {
            //出错数据 数据为空
            if (rowCount == 0) {
                if (self.emptyItemClicked) {
                    self.emptyItemClicked(sectionData);
                }
                else {
                    //数据出错
                    [sectionData refreshData];
                }
            }
            //更多
            else {
                if (![sectionData isLoadDataComplete]) {
                        //更多数据
                    [sectionData loadDataforNextPage];
                }
                else {
                    if (self.didSelectFinish) {
                        self.didSelectFinish(self, indexPath);
                    }
                }
            }
        }
    }
    
    else{
        //点击回调
        if (self.didSelectItem) {
            self.didSelectItem(self, indexPath);
        }
    }
}

// cell点击变色
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// cell高亮
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didHighlightItem) {
        self.didHighlightItem(self, indexPath);
    }
}

// cell高亮消失
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didUnhighlightItem) {
        self.didUnhighlightItem(self, indexPath);
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.willDisplayCell) {
        self.willDisplayCell(self, cell, indexPath);
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if (self.willDisplaySupplementaryView) {
        self.willDisplaySupplementaryView(self, view, indexPath);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didEndDisplayingCell) {
        self.didEndDisplayingCell(self, cell, indexPath);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if (self.didEndDisplayingSupplementaryView) {
        self.didEndDisplayingSupplementaryView(self, view, indexPath);
    }
}

#pragma mark -
#pragma mark 数据方法
// 自动检测和加载最后一个表格数据段的下一页数据
- (void)autoCheckAndLoadNextPage:(UIScrollView *)scrollView {
    if (nil == self.arrCollectionData || [self.arrCollectionData count] < 1) {
        return;
    }
    
    //判断是否加载到底部
    if(!(scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.size.height) < 0.5f)){
        return;
    }
    
    //最底部的表段数据
    SBCollectionData *lastSectionData = self.arrCollectionData[[self.arrCollectionData count] - 1];
    
    
    //加载中或者无后续数据不用去处理
    if ([lastSectionData isLoadDataComplete]) {
        return;
    }
    else if (lastSectionData.httpStatus == SBTableDataStatusLoading) {
        return;
    }
    else if(lastSectionData.httpStatus == SBTableDataStatusNotStart) {
        
    }
    else {
        //加载完毕后判断状态
        if (![lastSectionData isLoadDataComplete]) {
            [lastSectionData loadDataforNextPage];
        } else {
            [lastSectionData loadData];
        }
    }
}

/** view已经停止滚动 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //加载下一页
    if (![scrollView isKindOfClass:[SBCollectionView class]]) {
        return;
    }
    
    if (self.endDecelerating) {
        self.endDecelerating(self);
    } else {
        [self autoCheckAndLoadNextPage:scrollView];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.willBeginDragging) {
        self.willBeginDragging(self);
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (self.willEndDragging) {
        self.willEndDragging(self);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollViewDidScroll != NULL) {
        self.scrollViewDidScroll(scrollView);
    }
}


#pragma mark -
#pragma mark 数据方法
/** 为表格添加一个表格段 */
- (void)addSectionWithData:(SBCollectionData *)sectionData {
    NSAssert(nil != sectionData.mDataCellClass, @"不允许加一个空的列表数据进来");
    
    sectionData.collectionView = self;
    [self registerClass:sectionData.mDataCellClass];
    [self registerClass:sectionData.mEmptyCellClass];
    [self registerClass:sectionData.mErrorCellClass];
    [self registerClass:sectionData.mMoreCellClass];
    [self registerClass:sectionData.mLoadingCellClass];
    [self registerClass:sectionData.mFinishedCellClass];
    
    //队列中添加数据
    [self.arrCollectionData addObject:sectionData];
}

- (NSString *)cellWithIdentifier:(Class)cellClass {
    NSString *cellIdentifier = [NSString stringWithFormat:@"dequeueReusableCellWithIdentifier-%@", cellClass];
    return cellIdentifier;
}

/** 注册单元格类型 */
- (void)registerClass:(Class)cellClass {
    //注册该单元格类型
    [self registerClass:cellClass forCellWithReuseIdentifier:[self cellWithIdentifier:cellClass]];
}

- (void)removeSection:(NSUInteger)section {
    if (section < self.arrCollectionData.count) {
        [self.arrCollectionData removeObjectAtIndex:section];
    }
}

/** 获取指定表格段的数据 */
- (SBCollectionData *)dataOfSection:(NSInteger)section {
    if(section > -1 && section < [self.arrCollectionData count]){
        return self.arrCollectionData[section];
    }
    
    return nil;
}

/** 获取指定单元格的数据 */
- (DataItemDetail *)dataOfIndexPath:(NSIndexPath *)indexPath {
    assert(nil != indexPath);
    
    SBCollectionData *data = [self dataOfSection:indexPath.section];
    
    if (nil == data) {
        return nil;
    }
    
    assert(nil != data.tableDataResult);
    
    return [data.tableDataResult getItem:indexPath.row];
}


/** 获取指定单元格的数据 */
- (DataItemDetail *)dataOfCellTag:(NSInteger)cellTag {
    for (int i = 0 ; i<[self.arrCollectionData count]; i++) {
        SBCollectionData *data = [self dataOfSection:i];
        for (int j = 0; j<data.tableDataResult.count; j++) {
            DataItemDetail *cellDetail = [self dataOfIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            if ([cellDetail tableCellTag] == cellTag) {
                return cellDetail;
            }
        }
    }
    
    return nil;
}

/** 清除所有表内容 */
- (void)clearCollectionData {
    [self.arrCollectionData removeAllObjects];
}



@end
