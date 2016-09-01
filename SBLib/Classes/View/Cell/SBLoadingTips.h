/*
#####################################################################
# File    : LoadingView.h
# Project : 
# Created : 2013-04-01
# DevTeam : thomas
# Author  : thomas
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

//加载圈 + 文字提示
@interface SBLoadingTips : UIView {
}

@property (nonatomic, readonly) UIActivityIndicatorView *activityView;
@property (nonatomic, readonly) UILabel *loadingLabel;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) UIColor  *textColor;

//显示加载信息
- (void)showLoadingView;

@end
