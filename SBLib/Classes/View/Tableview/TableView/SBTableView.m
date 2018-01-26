/*
 #####################################################################
 # File    : TableView.m
 # Project : 
 # Created : 2013-03-30
 # DevTeam : thomas only one
 # Author  : roronoa
 # Notes   : 封装tableview
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

#import "SBTableView.h"
#import "MJRefresh.h"       //下拉表头
#import "SBDataTableCell.h"         //单元格

@interface SBTableView ()

// 将要发起网络请求
@property (nonatomic, strong) NSMutableArray *arrTableData;                     //列表数据

@end

@implementation SBTableView

#pragma mark -
#pragma mark 生命周期

- (id)init {
    return [self initWithStyle:NO];
}

/** 初始化表格，isGrouped为YES时，表示初始化一个圆角表格 */
- (id)initWithStyle:(BOOL)isGrouped {
	self = [super initWithFrame:CGRectZero style:isGrouped ? UITableViewStyleGrouped : UITableViewStylePlain];

    //列表数据
    self.arrTableData = [[NSMutableArray alloc] init];
    
    //列表配制
	[self customInit];
    
	return self;
}

- (void)customInit {
    //默认给个
    self.frame = CGRectMake(0, 0, 1, 1);
    self.backgroundColor = [UIColor clearColor];
    if (APPCONFIG_VERSION_OVER_9) {
        self.cellLayoutMarginsFollowReadableWidth = NO;
    }
    
    self.delegate = self;
    self.dataSource = self;
    
    self.estimatedRowHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.tableFooterView = [[UIView alloc] init];
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
    SBTableData *sectionData = [self dataOfSection:0];
    //从第一页开始
    sectionData.pageAt = 1;
    //加载数据
    [sectionData loadData];
}

#pragma mark -
#pragma mark UITableView UI回调
/** 撑满列表的单元格高度 */
- (CGFloat)fullCellHeight {
    CGFloat tableHeight = CGRectGetHeight(self.bounds);
    //tableHeight = tableHeight - self.contentInset.top - self.contentInset.bottom;
    CGFloat tableHeaderHeight = CGRectGetHeight(self.tableHeaderView.bounds);
    if (tableHeight - tableHeaderHeight >= APPCONFIG_UI_TABLE_CELL_HEIGHT) {
        //撑满屏幕
        return tableHeight - tableHeaderHeight;
    } else {
        return tableHeight;
    }
}
//单元格高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SBTableData *sectionData = [self dataOfSection:indexPath.section];
    NSUInteger rowCount = [sectionData.tableDataResult count];
    
    //没有数据，或者异常数据， 全文提示
    if (rowCount == 0) {
        
        //错误与空 只有第一页有效
        if (sectionData.httpStatus != SBTableDataStatusLoading) {
            //如果明确的给过高度
            if (sectionData.emptyCellHeight >= 0) {
                return sectionData.emptyCellHeight;
            }
            
            return [self fullCellHeight];
            
        }
        //加载中
        else {
            //如果明确的给过高度
            if (sectionData.loadingCellHeight >= 0) {
                return sectionData.loadingCellHeight;
            }
            return [self fullCellHeight];
        }
    }
    
    //加载更多与更多错误
    else if (indexPath.row >= rowCount) {
        return APPCONFIG_UI_TABLE_CELL_HEIGHT;
    }
    
    //是否响应给单元格高度的回调
    else if(self.heightForRow){
        //这里保存一下列表的宽度 这时候的宽度比较真实
        DataItemDetail *cellDetail = [self dataOfIndexPath:indexPath];
        [cellDetail setFloat:CGRectGetWidth(self.frame) forKey:__KEY_CELL_WIDTH];
        
        return self.heightForRow(self, indexPath);
    }
    
    else if (self.rowHeight > 44) {
        return self.rowHeight;
    }
    
    return UITableViewAutomaticDimension;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    SBTableData *sectionData = [self dataOfSection:indexPath.section];
//    NSUInteger rowCount = [sectionData.tableDataResult count];
//    
//    //加载中
//    if (indexPath.row >= rowCount) {
//        if (sectionData.httpStatus == SBTableDataStatusLoading) {
//            return sectionData.loadingCellHeight;
//        }
//    }
//    return UITableViewAutomaticDimension;
//}

//指定表格段的标题 
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	SBTableData *sectionData = [self dataOfSection:section];
    
	assert(nil != sectionData);
    
	return sectionData.headerTitle;
}


//表头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SBTableData *sectionData = [self dataOfSection:section];
    
	assert(nil != sectionData);
    
    //有文字
	if (sectionData.headerTitle.length > 0) {
		return APPCONFIG_UI_TABLE_CELL_HEIGHT;
	}
    
    //有自定义界面
    if (NULL != self.headerForSection && ((SBTableData *)self.arrTableData[section]).hasHeaderView) {
        UIView *_sectionHeaderView = self.headerForSection(self, section);
        if (nil == _sectionHeaderView) {
            return 0;
        }
        CGFloat sectionHeaderHeight = CGRectGetHeight(_sectionHeaderView.bounds);
        return sectionHeaderHeight;
    }
    
    if (tableView.style == UITableViewStyleGrouped) {
        return APPCONFIG_UI_TABLE_PADDING;
    }
	
    return 0;
}

//表尾高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
#ifdef DEBUG
    SBTableData *sectionData = [self dataOfSection:section];
    NSAssert(nil != sectionData, @"不允许没有列表数据");
#endif
    
    //有自定义界面
    if (NULL != self.footerForSection && ((SBTableData *)self.arrTableData[section]).hasFooterView) {
        UIView *sectionFooterView = self.footerForSection(self, section);
        if (nil == sectionFooterView) {
            return 0;
        }
        CGFloat sectionFooterHeight = CGRectGetHeight(sectionFooterView.bounds);
        return sectionFooterHeight;
    }
    
    if (tableView.style == UITableViewStyleGrouped) {
        return 1.0f;
    }
	
    return 0;
}

//表格端的顶部视图 
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SBTableData *sectionData = [self dataOfSection:section];

    if (sectionData) {
        //有文字 返回nil
        if (sectionData.headerTitle.length > 0) {
            return nil;
        }

        if (self.headerForSection && sectionData.hasHeaderView) {
            return self.headerForSection(self, section);
        }
    }
    
    return [[UIView alloc] init];
}

//表格段的底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    SBTableData *sectionData = [self dataOfSection:section];
    if (sectionData) {
        if (self.footerForSection && sectionData.hasFooterView) {
            return self.footerForSection(self, section);
        }
    }
    
    return [[UIView alloc] init];
}

//选中某行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SBTableData *sectionData = [self dataOfSection:indexPath.section];
    
    assert(nil != sectionData);
	assert(indexPath.row >= 0);
    
    //数据状态
    SBTableDataStatus httpStatus = sectionData.httpStatus;
    
    //异常情况 点击让用户重试
	if (indexPath.row >= [sectionData.tableDataResult count]) {
		assert(SBTableDataStatusNotStart != httpStatus);
        
        //如果外部已经有处理错误代码了，这里就引到外面去，自己不做处理
        if (self.errorHandle != NULL) {
            self.errorHandle(self,sectionData);
            return;
        }
        
        //以下是默认的错误处理
        if (SBTableDataStatusFinished == sectionData.httpStatus) {
            //出错数据 数据为空
            NSUInteger rowCount = [sectionData.tableDataResult count];
			if (rowCount == 0) {
                //空单元格点击事件
                if(self.emptyCellClicked){
                    self.emptyCellClicked(sectionData);
                }
                else{
                    //数据出错
                    if (!sectionData.isLoadDataOK) {
                        [sectionData refreshData];
                    }
                    else if (sectionData.isEmptyCellEnableClick) {
                        [sectionData refreshData];
                    }
                }
            }
            //更多
            else {
                if (![sectionData isLoadDataComplete]) {
                    if (self.didSelectMore) {
                        self.didSelectMore(self, indexPath);
                    } else {
                        //更多数据
                        [sectionData loadDataforNextPage];
                    }
                }
                else {
                    if (sectionData.hasFinishCell) {
                        if (self.didSelectFinish) {
                            self.didSelectFinish(self, indexPath);
                        }
                    }

                }
			}
		}
	}
    
    else{
        //点击回调
        if (NULL != self.didSelectRow) {
            self.didSelectRow(self, indexPath);
        }
    }
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// 响应列表右边小箭头的点击事件
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    if (NULL != self.tapAccessoryButton) {
        self.tapAccessoryButton(self, indexPath);
    }
}

//可否移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if  (NULL != self.canMoveRow) {
        return self.canMoveRow(self,indexPath);
    }
    return NO;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath  {
    if  (NULL != self.moveRowToIndex) {
        self.moveRowToIndex(self,sourceIndexPath,destinationIndexPath);
    }
}

//指定的单元格滑动后是否能编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	SBTableData *data = [self dataOfSection:indexPath.section];
    
	if ([data isLoadDataComplete]) {
		if ([data.tableDataResult count] == 0) {
            return NO;
        }
    } else {
        if (indexPath.row >= [data.tableDataResult count]) {
            return NO;
        }
    }
    
    if (NULL != self.canEditRow) {
        return self.canEditRow(self, indexPath);
    }
    
	return self.editing;
}

//编辑单元格时的事件 
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //只做了删除现在
    
	if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.preCommitEditRow) {
            self.preCommitEditRow(self, editingStyle, indexPath);
        }
        
		if (NULL != self.commitEditRow) {
            self.commitEditRow(self, editingStyle, indexPath);
        }else{
            //删除该行
            [self removeCell:indexPath];
        }
        
        if (self.postCommitEditRow) {
            self.postCommitEditRow(self, editingStyle, indexPath);
        }
	}
}

/** 为列表增加功能 **/
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    if (self.editActions) {
        return self.editActions(self, indexPath);
    }

    return nil;
}

//删除按钮显示
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

#pragma mark -
#pragma mark UITableView 数据回调
//返回表格端的数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [self.arrTableData count];
}

//一个单元中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SBTableData *sectonData = [self dataOfSection:section];
    
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
    
    //加载完成
    else {
        //交给外面自己处理单元格个数
        if (self.numberOfRow) {
            return self.numberOfRow(self, section);
        }
        
        //如果不是最后一个section
        if (sectonData != self.arrTableData.lastObject) {
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
                    //加载更多
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

//绘制列表的背景色
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //判断是否有临时修改样式的需求，有的话使用返回的Class
    if(NULL != self.willDisplayRow){
        self.willDisplayRow(self, cell, indexPath);
    } else {
        
    }
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    
}

//创建表格中的一个单元格
- (id)cellWithClass:(Class<SBTableViewCellDelegate>)cellClass indexPath:(NSIndexPath *)indexPath {
	assert(nil != cellClass);
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"dequeueReusableCellWithIdentifier-%@", cellClass] ;
    
	UITableViewCell<SBTableViewCellDelegate> *cell = [self dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if (nil == cell) {
        //创建单元格
        cell = [cellClass createCell:cellIdentifier];
        cell.frame = CGRectMake(0, 0, self.frame.size.width, APPCONFIG_UI_TABLE_CELL_HEIGHT);
    }
    
    assert(nil != cell);
    
    SBTableData *sectionData = [self dataOfSection:indexPath.section];
    cell.table = self;
    cell.tableData = sectionData;
    cell.indexPath = indexPath;
    cell.cellDetail = [sectionData.tableDataResult getItem:indexPath.row];

    //绑定数据
    [cell bindCellData];
        
	return cell;
}

/** 创建指定单元格的 UITableViewCell */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	SBTableData *sectionData = [self dataOfSection:indexPath.section];
    if (!sectionData) {
        NSAssert(nil != sectionData, @"不允许没有列表数据");
        return nil;
    }
    
    UITableViewCell *cell = nil;
    
    //加载状态，显示加载样式
    if (SBTableDataStatusLoading == sectionData.httpStatus && indexPath.row >= [sectionData.tableDataResult count]) {
        cell = [self cellWithClass:sectionData.mLoadingCellClass indexPath:indexPath];
    }
    //这里是最后一行，一般是出错了，加载中的单元格样式
    else {
        //无数据
        if ([sectionData.tableDataResult count] == 0) {
            //加载失败
            if(!sectionData.isLoadDataOK) {
                if (sectionData.pageAt == 1) {
                    return [self cellWithClass:sectionData.mErrorCellClass indexPath:indexPath];
                } else {
                    return [self cellWithClass:NSClassFromString(@"SBErrorTableCell") indexPath:indexPath];
                }
            } else {
                cell = [self cellWithClass:sectionData.mEmptyCellClass indexPath:indexPath];
            }
        }
        //超出数据
        else if (indexPath.row >= [sectionData.tableDataResult count]) {
            //加载完单元格
            if (sectionData.hasFinishCell && sectionData.isLoadDataComplete) {
                cell = [self cellWithClass:sectionData.mFinishedCellClass indexPath:indexPath];
            }
            //加载失败
            else if(!sectionData.isLoadDataOK) {
                return [self cellWithClass:NSClassFromString(@"SBErrorTableCell") indexPath:indexPath];
            }
            //更多
            else {
                cell = [self cellWithClass:sectionData.mMoreCellClass indexPath:indexPath];
            }
        }
        //正常数据
        else {
            if(NULL != self.modifiRowClass) {
                Class modifiRowClass = self.modifiRowClass(self, sectionData.mDataCellClass, indexPath);
                cell = [self cellWithClass:modifiRowClass indexPath:indexPath];
            } else {
                cell = [self cellWithClass:sectionData.mDataCellClass indexPath:indexPath];
            }
        }
    }
    return cell;
}

#pragma mark -
#pragma mark 数据方法
/** 为表格添加一个表格段 */
- (void)addSectionWithData:(SBTableData *)sectionData {
	NSAssert(nil != sectionData.mDataCellClass, @"不允许加一个空的列表数据进来");
    
	sectionData.tableView = self;
    
    //队列中添加数据
	[self.arrTableData addObject:sectionData];
}

- (void)insertSectionWithData:(SBTableData *)sectionData atIndex:(NSUInteger)index{
    if (sectionData.mDataCellClass && (index <= self.arrTableData.count)) {
        sectionData.tableView = self;
        [self.arrTableData insertObject:sectionData atIndex:index];
    }
}

- (void)removeSection:(NSUInteger)section {
    if (section < self.arrTableData.count) {
        [self.arrTableData removeObjectAtIndex:section];
    }
}

- (void)removeSectionWithRange:(NSRange)range{
     if (range.location + range.length < (self.arrTableData.count +1)) {
        [self.arrTableData removeObjectsInRange:range];
    }
}

/** 获取指定表格段的数据 */
- (SBTableData *)dataOfSection:(NSInteger)section {
	if(section > -1 && section < [self.arrTableData count]){
        return self.arrTableData[section];
    }
    
    return nil;
}

- (SBTableData *)lastSection{
    return self.arrTableData.lastObject;
}

/** 获取指定单元格的数据 */
- (DataItemDetail *)dataOfIndexPath:(NSIndexPath *)indexPath {
    assert(nil != indexPath);
    
    SBTableData *data = [self dataOfSection:indexPath.section];
    
    if (nil == data) {
        return nil;
    }
    
    assert(nil != data.tableDataResult);
    
    return [data.tableDataResult getItem:indexPath.row];
}


/** 获取指定单元格的数据 */
- (DataItemDetail *)dataOfCellTag:(NSInteger)cellTag {
    for (int i = 0 ; i<[self.arrTableData count]; i++) {
        SBTableData *data = [self dataOfSection:i];
        for (int j = 0; j<data.tableDataResult.count; j++) {
            DataItemDetail *cellDetail = [self dataOfIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            if ([cellDetail tableCellTag] == cellTag) {
                return cellDetail;
            }
        }
    }
    
    return nil;
}

/** 删除一个单元格  ui和 数据上 */
- (void)removeCell:(NSIndexPath *)indexPath {
    [self removeCell:indexPath animation:UITableViewRowAnimationFade];
}

/** 删除一个单元格  ui和 数据上 自定义动画 */
- (void)removeCell:(NSIndexPath *)indexPath animation:(UITableViewRowAnimation)animation {
    if (indexPath == nil) {
        return;
    }
    
    DataItemDetail *cellDetail = [self dataOfIndexPath:indexPath];
    if (cellDetail) {
        SBTableData *tableData = [self dataOfSection:indexPath.section];
        [tableData.tableDataResult removeItem:cellDetail];
        
        //TODO: 这问题我解决不了 当列表删除最后一个单元格的时候，动画会导致crash
        if (tableData.tableDataResult.count == 0) {
            [self reloadData];
        } else {
            [self beginUpdates];
            //删除数组 其实这里也就一个
            [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
            [self endUpdates];
        }
    }
}

#pragma mark -
#pragma mark 一些关于用户操作的方法
// 自动检测和加载最后一个表格数据段的下一页数据
- (void)autoCheckAndLoadNextPage:(UIScrollView *)scrollView {
    if (nil == self.arrTableData || [self.arrTableData count] < 1) {
        return;
    }
    
    //判断是否加载到底部
    if(!(scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.size.height) < APPCONFIG_UNIT_LINE_WIDTH)){
        return;
    }
    
    //最底部的表段数据
    SBTableData *lastSectionData = [self.arrTableData lastObject];

    //加载完毕后判断状态
    [lastSectionData loadDataforNextPage];
}


// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.didEndDragging) {
        self.didEndDragging(self, decelerate);
    }
}

/** view已经停止滚动 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.endDecelerating) {
        self.endDecelerating(self);
    }
    [self autoCheckAndLoadNextPage:scrollView];
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
#pragma mark 私有方法
/** section 数量 */
- (NSUInteger)numberOfTableData {
    return self.arrTableData.count;
}

- (void)clearTableData {
    [self.arrTableData removeAllObjects];
}


@end
