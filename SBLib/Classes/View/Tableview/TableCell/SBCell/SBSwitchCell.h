/*
 #####################################################################
 # File    : SBSwitchCell.h
 # Project : StockBar
 # Created : 14/10/27
 # DevTeam : Thomas
 # Author  : Thomas
 # Notes   : 左边文字，右边选择器的单元格
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

#import "SBTitleCell.h"
#import "SBCellLabel.h"

@interface SBSwitchCell : SBTitleCell

@property (nonatomic, strong) UISwitch *valueSw;            //选择器

//选择器发生改变
- (void)switchDidChange:(id)sender;

@end
