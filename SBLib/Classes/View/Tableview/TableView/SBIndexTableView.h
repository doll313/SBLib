/*
 #####################################################################
 # File    : TableViewIndex.h
 # Project : SBLib
 # Created : 14-6-11
 # DevTeam : eastmoney
 # Author  : Thomas
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

#import "SBTableView.h"

@interface SBIndexTableView : SBTableView {
@private
}

//不要赋值
@property (nonatomic, strong) NSArray *compositorArray;  //排序后的索引数组

//赋值
@property (nonatomic, strong) NSString   *indexKey;         //索引字段的key
@property (nonatomic, assign) BOOL isFirstLetter;       //是否是显示首字母
@property (nonatomic, assign) BOOL isIndexUppercase;       //索引是否大写 只有isFirstLetter为YES时 才生效
@property (nonatomic, assign) Class<SBTableViewCellDelegate> listDataCellClass;
@property (nonatomic, assign) Class<SBTableViewCellDelegate> listEmptyCellClass;
@property (nonatomic, assign) Class<SBTableViewCellDelegate> listErrorCellClass;

//添加数据
- (void)appendResult:(DataItemResult *)result;

// 索引目录
@property (nonatomic, copy) NSArray * (^sectionIndexTitles)(SBTableView *tableView);
// 查看索引
@property (nonatomic, copy) NSInteger (^fetchIndexTitle)(SBTableView *tableView, NSString *title, NSInteger index);

@end

