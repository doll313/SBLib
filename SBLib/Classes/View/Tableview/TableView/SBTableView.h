/*
 #####################################################################
 # File    : TableView.h
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

#import "SBTableData.h"               //列表数据
#import "SBTableViewDelegate.h"         //列表协议

#pragma mark -
#pragma mark 分装列表类
/** 该类用于 UITableView 表格二次封装显示 */
@interface SBTableView : UITableView <UITableViewDelegate, UITableViewDataSource> {
@private
    
}

/** 一般对应列表所在的viewctroller **/
@property (nonatomic, assign) UIViewController *ctrl;

/** 是否是下拉类型的列表 */
@property (nonatomic, assign) BOOL isRefreshType;

/** 扩展一个列表的节点，做应急用，请不要随意使用这个节点 **/
@property (nonatomic, assign) int emunTag;

// 将要发起网络请求
@property (nonatomic, strong) NSMutableArray *arrTableData;                     //列表数据

//提前加载(滑动至底部x加载下一页) 默认5
@property (nonatomic, assign) NSInteger preLoadCount;

// 将要发起网络请求
@property (nonatomic, copy) void (^willRequestData)(SBTableData *tableViewData);
// 发起网络请求
@property (nonatomic, copy) SBHttpDataLoader* (^requestData)(SBTableData *tableViewData);
// 接受网络数据
@property (nonatomic, copy) void (^receiveData)(SBTableView *tableView, SBTableData *tableViewData, DataItemResult *result);
// cache加载完成时的block
@property (nonatomic, copy) void (^cacheLoad)(SBTableView *tableView, SBTableData *tableViewData, DataItemResult *result);
// 点击单元格
@property (nonatomic, copy) void (^didSelectRow)(SBTableView *tableView, NSIndexPath *indexPath);
// 点击更多单元格
@property (nonatomic, copy) void (^didSelectMore)(SBTableView *tableView, NSIndexPath *indexPath);
// 点击完成单元格
@property (nonatomic, copy) void (^didSelectFinish)(SBTableView *tableView, NSIndexPath *indexPath);
// 单元格个数
@property (nonatomic, copy) CGFloat (^numberOfRow)(SBTableView *tableView, NSInteger section);
// 单元格高度
@property (nonatomic, copy) CGFloat (^heightForRow)(SBTableView *tableView, NSIndexPath *indexPath);
// 段的头部视图
@property (nonatomic, copy) UIView *(^headerForSection)(SBTableView *tableView, NSInteger section);
// 段的尾部视图
@property (nonatomic, copy) UIView *(^footerForSection)(SBTableView *tableView, NSInteger section);
// 能否编辑单元格
@property (nonatomic, copy) BOOL (^canEditRow)(SBTableView *tableView, NSIndexPath *indexPath);
//删除Row数据之前执行
@property (nonatomic, copy) BOOL (^preCommitEditRow)(SBTableView *tableView, UITableViewCellEditingStyle editingStyle, NSIndexPath *indexPath);
//删除Row数据 默认是 [self removeCell:]，如果实现了这个block则覆盖默认行为
@property (nonatomic, copy) BOOL (^commitEditRow)(SBTableView *tableView, UITableViewCellEditingStyle editingStyle, NSIndexPath *indexPath) ;
//删除Row之后执行
@property (nonatomic, copy) BOOL (^postCommitEditRow)(SBTableView *tableView, UITableViewCellEditingStyle editingStyle, NSIndexPath *indexPath);
//编辑选项
@property (nonatomic, copy) NSArray<UITableViewRowAction *> *(^editActions)(SBTableView *tableView, NSIndexPath *indexPath);
// 点击箭头
@property (nonatomic, copy) void (^tapAccessoryButton)(SBTableView *tableView, NSIndexPath *indexPath);
// 临时修改单元格的显示样式
@property (nonatomic, copy) Class(^modifiRowClass)(SBTableView *tableView, Class<SBTableViewCellDelegate> originClass, NSIndexPath *indexPath);
// 临时修改单元格背景
@property (nonatomic, copy) void (^willDisplayRow)(SBTableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath);
// scrollview delegate引出
@property (nonatomic, copy) void (^scrollViewDidScroll)(UIScrollView *scroll);
// 移动单元格
@property (nonatomic, copy) BOOL (^canMoveRow)(SBTableView *tableView, NSIndexPath *indexPath);
// 移动单元格回调
@property (nonatomic, copy) void (^moveRowToIndex)(SBTableView *tableView, NSIndexPath *fromindexPath, NSIndexPath *toIndexPath);
// 网络异常处理
@property (nonatomic, copy) void (^errorHandle)(SBTableView *tableView, SBTableData *section);
// 结束滑动
@property (nonatomic, copy) void (^endDecelerating)(SBTableView *table);
// 开始拖动
@property (nonatomic, copy) void (^willBeginDragging)(SBTableView *table);
// 结束拖动
@property (nonatomic, copy) void (^willEndDragging)(SBTableView *table);
// 空单元格点击事件
@property (nonatomic, copy) void (^emptyCellClicked)(SBTableData *tableViewData);


/** 初始化表格，isGrouped为YES时，表示初始化一个圆角表格 */
- (id)initWithStyle:(BOOL)isGrouped;

/**  表格初始化，会在initWithStyle:时调用 */
- (void)customInit;

/** 为表格添加一个表格段 */
- (void)addSectionWithData:(SBTableData *)sectionData;

/** 删除一个表格段 */
- (void)removeSection:(NSUInteger)section;

/** 删除一个单元格  ui和 数据上  */
- (void)removeCell:(NSIndexPath *)indexPath;
- (void)removeCell:(NSIndexPath *)indexPath animation:(UITableViewRowAnimation)animation;

/** 获取指定表格段的数据 */
- (SBTableData *)dataOfSection:(NSInteger)section;

/** 获取指定单元格的数据 */
- (DataItemDetail *)dataOfIndexPath:(NSIndexPath *)indexPath;

/** 获取指定单元格的数据 */
- (DataItemDetail *)dataOfCellTag:(NSInteger)cellTag;

/** 清除所有表内容 */
- (void)clearTableData;

@end
