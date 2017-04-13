/*
 #####################################################################
 # File    : SBFinishedCell.m
 # Project :
 # Created : 2015-1-15
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

#import "SBFinishedTableCell.h"

@implementation SBFinishedTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    //没箭头，不能点击
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.userInteractionEnabled = NO;

    return self;
}

- (void)bindCellData {
    [super bindCellData];
    
    self.displayLabel.text = @"数据已经加载完毕!";
}

@end

