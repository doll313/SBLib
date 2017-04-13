/*
#####################################################################
# File    : MoreTableCell.m
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

#import "SBMoreTableCell.h"

@implementation SBMoreTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.accessoryType = UITableViewCellAccessoryNone;
	self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return self;
}

- (void)bindCellData{
    [super bindCellData];
    self.displayLabel.text = [NSString stringWithFormat:@"显示下 %ld 条", (long)self.tableData.pageSize];
}

@end
