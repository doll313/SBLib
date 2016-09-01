/*
 #####################################################################
 # File    : SBTitleCell.h
 # Project : StockBar
 # Created : 14/10/27
 # DevTeam : Thomas
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

#import "SBCellLabel.h"
#import "SBDataTableCell.h"


extern CGFloat const SBTitleCellHeight;
extern CGFloat const SBTitleSubtitleFont;      //标题字体
#define __SB_COLOR_TCELL_SUBTITLE                RGB(0x80, 0x80, 0x80)       //标题颜色

@interface SBTitleCell : SBDataTableCell

@property (nonatomic, strong) SBCellLabel *titleLbl;            //标题
@property (nonatomic, strong) SBCellLabel *subTitleLbl;            //副标题

-(void)layoutTitleCellVerticalFrame;//垂直布局

@end
