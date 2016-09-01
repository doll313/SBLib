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


#import "SBCollectionData.h"        //Collection数据
#import "SBCollectionViewDelegate.h"    //Collection协议

//封装Collection
@interface SBCollectionView : UICollectionView <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/** 一般对应列表所在的viewctroller **/
@property (nonatomic, assign) UIViewController *ctrl;

/** 是否是下拉类型的列表 */
@property (nonatomic, assign) BOOL isRefreshType;

/** 扩展一个列表的节点，做应急用，请不要随意使用这个节点 **/
@property (nonatomic, assign) int emunTag;

//列表数据
@property (nonatomic, strong) NSMutableArray *arrCollectionData;

//布局
@property (nonatomic, strong) UICollectionViewLayout *flowLayout;


// 将要发起网络请求
@property (nonatomic, copy) void(^willRequestData)(SBCollectionData *collectionData);
// 发起网络请求
@property (nonatomic, copy) SBHttpDataLoader *(^requestData)(SBCollectionData *collectionData);
// 接受网络数据
@property (nonatomic, copy) void(^receiveData)(SBCollectionView *collectionView, SBCollectionData *collectionData, DataItemResult *result);
;
// scrollview delegate引出
@property (nonatomic, copy) void (^scrollViewDidScroll)(UIScrollView *scroll);
// 开始拖动
@property (nonatomic, copy) void (^willBeginDragging)(SBCollectionView *collectionView);
// 结束拖动
@property (nonatomic, copy) void (^willEndDragging)(SBCollectionView *collectionView);
// 滑动松手
@property (nonatomic, copy) void(^endDecelerating)(SBCollectionView *collectionView);


//边距 默认都是0
@property (nonatomic, copy) UIEdgeInsets(^insetForSection)(SBCollectionView *collectionView, UICollectionViewLayout *collectionViewLayout,  NSInteger section);
//头部大小 默认没有
@property (nonatomic, copy) CGSize(^referenceSizeForHeader)(SBCollectionView *collectionView, UICollectionViewLayout *collectionViewLayout,  NSInteger section);
//item大小 默认是 屏幕一半小20像素
@property (nonatomic, copy) CGSize(^sizeForItem)(SBCollectionView *collectionView, UICollectionViewLayout *collectionViewLayout,  NSIndexPath *indexPath);
//点击
@property (nonatomic, copy) void(^didSelectItem)(SBCollectionView *collectionView, NSIndexPath *indexPath);
//高亮
@property (nonatomic, copy) void(^didHighlightItem)(SBCollectionView *collectionView, NSIndexPath *indexPath);
//高亮消失
@property (nonatomic, copy) void(^didUnhighlightItem)(SBCollectionView *collectionView, NSIndexPath *indexPath);
//header or footer
@property (nonatomic, copy) UICollectionReusableView *(^viewForSupplementaryElement)(SBCollectionView *collectionView, NSString *kind, NSIndexPath *indexPath);
// 空单元格点击事件
@property (nonatomic, copy) void (^emptyItemClicked)(SBCollectionData *collectionData);
// 临时修改item的显示样式
@property (nonatomic, copy) Class(^modifiItemClass)(SBCollectionView *collectionView, Class<SBCollectionCellDelegate> originClass, NSIndexPath *indexPath);


/** 为表格添加一个表格段 */
- (void)addSectionWithData:(SBCollectionData *)sectionData;

/** 注册单元格类型 */
- (void)registerClass:(Class)cellClass;

/** 删除一个表格段 */
- (void)removeSection:(NSUInteger)section;

/** 获取指定表格段的数据 */
- (SBCollectionData *)dataOfSection:(NSInteger)section;

/** 获取指定单元格的数据 */
- (DataItemDetail *)dataOfIndexPath:(NSIndexPath *)indexPath;

/** 获取指定单元格的数据 */
- (DataItemDetail *)dataOfCellTag:(NSInteger)cellTag;

/** 清除所有表内容 */
- (void)clearCollectionData;

@end
