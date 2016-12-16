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

@property (nonatomic, assign) BOOL isFirstLetter;       //是否是显示首字母
@property (nonatomic, strong) NSString   *indexKey;
@property (nonatomic, assign)Class<SBTableViewCellDelegate> listDataCellClass;

//中文的拼音首字母
- (NSString *)firstLetter:(NSString *)hanzi;

//添加数据
- (void)appendResult:(DataItemResult *)result;

@end

