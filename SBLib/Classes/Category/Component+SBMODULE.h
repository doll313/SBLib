/*
#####################################################################
# File    : UILabelCagegory.h
# Project : 
# Created : 2013-03-30
# DevTeam : Thomas Develop
# Author  : 
# Notes   :
#####################################################################
### Change Logs   ###################################################
#####################################################################
---------------------------------------------------------------------
# Date  : 2013-06-28
# Author:
# Notes : 加入输入框的扩展
#
#####################################################################
### Change Logs   ###################################################
#####################################################################
---------------------------------------------------------------------
# Date  : 2013-08-27
# Author:
# Notes : 加入工具条的扩展
#
#####################################################################
*/

#import <UIKit/UIKit.h>

//为SDK自带的 UITextField 类添加一些实用方法
@interface UITextField (sbmodule)
//一种hack方式，为textfield设置padding
- (void)sb_addFieldPadding:(CGFloat)padding;

@end

@interface UITextView (sbmodule)

- (void)sb_insertTextAtCursor:(NSString *)text;

/**
 文字的高度，在iOS6下为inset_top + 文字高度（即self.contentSize.height）
 iOS7下因为计算有问题，进行了自定义计算，计算结果符合iOS6的self.contentSize.height结果
 
 @return 文字的高度
 */
- (CGFloat)sb_textHeight;

@end


@interface UIWindow (sbmodule)

/**
 寻找当前ViewController结构中，最上层的ViewController
 */
- (UIViewController *)sb_topMostViewController;

@end

//为 tableviewcell 类添加一些实用方法
@interface UITableViewCell (sbmodule)

/** *  添加点击背景颜色 */
- (void)sb_selectedColor:(UIColor *)color;

@end
