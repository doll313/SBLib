/*
#####################################################################
# File    : UIButtonCagegory.h
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

#import <UIKit/UIKit.h>


//为SDK自带的 UIButton 类添加一些实用方法
@interface UIButton (sbmodule) 

//按钮文字在图片下方
- (void)sb_titleUnderIcon;

//按钮文字在图片下方多少像素（实验证明是不大准确的）
- (void)sb_titleUnderIcon:(CGFloat)padding;

// 按钮文字在图片下方多少像素,并且固定图片大小
- (void)sb_titleUnderIcon:(CGFloat)paddingText imageSize:(CGSize)imageSize imageY:(float)imageY;

//按钮文字在图片左方
- (void)sb_titleLeftIcon;

//按钮文字在图片右方
- (void)sb_titleRightIcon;

//右上方加图标
- (void)sb_subViewToRightTop:(UIView *)view;

@end
