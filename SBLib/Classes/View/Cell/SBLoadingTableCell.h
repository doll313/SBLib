/*
#####################################################################
# File    : LoadingTableCell.h
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

#import "SBDataTableCell.h"
#import "SBLoadingTips.h"

//加载中的列表
@interface SBLoadingTableCell : SBDataTableCell {
    
}
@property (nonatomic, strong) SBLoadingTips *loadingView;           //加载提示
@end
