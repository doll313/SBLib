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
#import "MJRefresh.h"
#import "SBCollectionFlowLayout.h"
#import "SBErrorTableCell.h"

@interface SBCollectionView ()

//列表数据
@property (nonatomic, strong) NSMutableArray *arrCollectionData;

@end

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
    SBCollectionData *sectionData = [self dataOfSection:section];
    NSUInteger rowCount = [sectionData.tableDataResult count];

    //数据空 或 错误
    if (rowCount == 0 && sectionData.pageAt == 1) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    else {
        if (self.insetForSection) {
            return self.insetForSection(self, collectionViewLayout, section);
        }
        else {
            return UIEdgeInsetsMake(0, 0, 0, 0);
        }
    }

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SBCollectionData *sectionData = [self dataOfSection:indexPath.section];
//    DataItemDetail *itemDetail = [self dataOfIndexPath:indexPath];
    NSUInteger rowCount = [sectionData.tableDataResult count];
    
    CGFloat width = CGRectGetWidth(collectionView.bounds);
    CGFloat height = CGRectGetHeight(collectionView.bounds) - self.contentInset.top - self.contentInset.bottom;
        
    //加载状态，显示加载样式
    if (SBTableDataStatusLoading == sectionData.httpStatus && indexPath.row >= [sectionData.tableDataResult count]) {
        return CGSizeMake(width, 1);
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
    SBCollectionData *sectionData = [self dataOfSection:section];
    
    assert(nil != sectionData);
    
    NSUInteger rowCount = [sectionData.tableDataResult count];
    
    SBTableDataStatus tableDataStatus = sectionData.httpStatus;
    
    if (tableDataStatus == SBTableDataStatusNotStart) {
        //无加载情况，显示数等于数据个数 （多半是无网络请求的）
        return rowCount;
    }

    //无数据，加载完毕
    if (rowCount == 0) {
        //空单元格
        return 1;
    }
    //有数据，加载完毕
    else {
        return rowCount;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [self.arrCollectionData count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SBCollectionData *sectionData = [self dataOfSection:indexPath.section];
    
    assert(nil != sectionData);
    assert(indexPath.row >= 0);
    
    //数据状态
    NSUInteger rowCount = [sectionData.tableDataResult count];

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
- (void)loadDataforNextPage {
    //最底部的表段数据
    SBCollectionData *lastSectionData = self.arrCollectionData[[self.arrCollectionData count] - 1];
    [lastSectionData loadDataforNextPage];
}

// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

}

/** view已经停止滚动 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.endDecelerating) {
        self.endDecelerating(self);
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
    
    //队列中添加数据
    [self.arrCollectionData addObject:sectionData];

    MJRefreshFooter *footer = self.mj_footer;
    if (!footer) {
        footer = [sectionData.mFooterClass footerWithRefreshingTarget:self refreshingAction:@selector(loadDataforNextPage)];
        self.mj_footer = footer;
        self.mj_footer.hidden = YES;            //一开始隐藏
    }
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


/** section 数量 */
- (NSUInteger)numberOfCollectionData {
    return self.arrCollectionData.count;
}

/** 清除所有表内容 */
- (void)clearCollectionData {
    [self.arrCollectionData removeAllObjects];
}



@end
