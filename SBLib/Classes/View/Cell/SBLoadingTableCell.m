/*
#####################################################################
# File    : LoadingTableCell.m
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

#import "SBLoadingTableCell.h"

@implementation SBLoadingTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    //没箭头，不能点击
	self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.userInteractionEnabled = NO;

    self.loadingView = [[SBLoadingTips alloc] initWithFrame:CGRectZero];
    self.loadingView.textColor = __SB_COLOR_TABLE_DEFAULT_TIPS;
	[self addSubview:self.loadingView];

    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.loadingView.frame = CGRectMake(2 * APPCONFIG_UI_TABLE_PADDING, 0, CGRectGetWidth(self.bounds) - 4 * APPCONFIG_UI_TABLE_PADDING, CGRectGetHeight(self.bounds));
}
- (void)bindCellData {
    [super bindCellData];
    
    //默认加载中
    self.loadingView.loadingLabel.text = @"数据载入中…";
    [self.loadingView showLoadingView];
}

@end

@implementation SBLoadingCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.userInteractionEnabled = NO;
    
    self.loadingView = [[SBLoadingTips alloc] initWithFrame:CGRectZero];
    self.loadingView.textColor = __SB_COLOR_TABLE_DEFAULT_TIPS;
    [self addSubview:self.loadingView];
    
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.loadingView.frame = CGRectMake(2 * APPCONFIG_UI_TABLE_PADDING, 0, CGRectGetWidth(self.bounds) - 4 * APPCONFIG_UI_TABLE_PADDING, CGRectGetHeight(self.bounds));
}

- (void)bindItemData {
    [super bindItemData];
    
    //默认加载中
    self.loadingView.loadingLabel.text = @"数据载入中…";
    [self.loadingView showLoadingView];
}

@end
