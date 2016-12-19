/*
#####################################################################
# File    : SBDataTableCell.h
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

#import "SBCONSTANT.h"
#import "SBTableView.h"
#import "UILabel+SBMODULE.h"            //标签扩展

@interface DataItemDetail (DataTableCell)

@property (getter = tableCellTag, setter = setTableCellTag:) int tag;

/** 设定单元格数据为空 */
- (void)setEmptyTableCell;

/** 设定单元格数据为空/不为空 */
- (void)setEmptyTableCell:(BOOL)isEmpty;

/** 单元格数据是否为空 */
- (BOOL)tableCellIsEmpty;

/** 设定单元格选中/未选中状态 */
- (void)setSelectedTableCell:(BOOL)isSelected;

/** 单元格是否被选中状态 */
- (BOOL)tableCellIsSelected;

/** 设定单元格标记 */
- (void)setTableCellTag:(NSInteger)tag;

/** 获取单元格标记 */
- (NSInteger)tableCellTag;

@end


@class SBDataTableCell;

@interface SBDataTableCell : UITableViewCell <SBTableViewCellDelegate>{
}

/** 单元格的表格视图，当单元格显示时会被重新赋值 */
@property (nonatomic,assign) SBTableView *table;

/** 单元格在表格中的位置，当单元格显示时会被重新赋值 */
@property (nonatomic,retain) NSIndexPath *indexPath;

/** 单元格对应的数据，当单元格显示时会被重新赋值 */
@property (nonatomic,retain) DataItemDetail *cellDetail;

/** 单元个所在的表格节点对应的节点数据 */
@property (nonatomic,retain) SBTableData *tableData;

//一个默认的标签控件
@property (nonatomic, strong) UILabel *displayLabel;

//创建单元格
+ (id)createCell:(NSString *)reuseIdentifier;

/** 获取单元格的ID */
+ (NSString *)cellID:(SBTableView *)table;

//绑定单元格的控件
- (void)bindCellData;

@end
