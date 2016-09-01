/*
 #####################################################################
 # File    : TableViewIndex.h
 # Project : GubaModule
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
    NSArray                     *compositorArray;   //排序后的索引数组
}

@property (nonatomic, copy)NSString   *indexKey;
@property (assign)Class<SBTableViewCellDelegate> listDataCellClass;

- (void)appendResult:(DataItemResult *)result;//添加数据

@end

