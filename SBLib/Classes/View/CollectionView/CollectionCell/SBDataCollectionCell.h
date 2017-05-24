/*
 #####################################################################
 # File    : SBCollectionViewCell.h
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

#import <UIKit/UIKit.h>
#import "SBCONSTANT.h"

//Collocation 默认单元格
@interface SBDataCollectionCell : UICollectionViewCell

/** 单元格的表格视图，当单元格显示时会被重新赋值 */
@property (nonatomic,assign) SBCollectionView *collectionView;

/** 单元格在表格中的位置，当单元格显示时会被重新赋值 */
@property (nonatomic,retain) NSIndexPath *indexPath;

/** 单元格对应的数据，当单元格显示时会被重新赋值 */
@property (nonatomic,strong) DataItemDetail *itemDetail;

/** 单元个所在的表格节点对应的节点数据 */
@property (nonatomic,retain) SBCollectionData *collectionData;

//一个默认的标签控件
@property (nonatomic, strong) UILabel *displayLabel;

//创建单元格
+ (id)createCell:(CGRect)rect;

/** 获取单元格的ID */
+ (NSString *)cellID:(SBCollectionView *)table;

//绑定单元格的控件
- (void)bindItemData;

/** 绑定数据到单元格上的UI，单元格停止滑动时被调用 */
- (void)preItemData;

@end
