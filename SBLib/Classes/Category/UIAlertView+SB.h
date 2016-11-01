/*
#####################################################################
# File    : UIAlertViewCategory.h
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

//为SDK自带的 UIAlertView 类添加一些实用方法
@interface UIWindow (sbalert)

// 隐藏当前提示
+ (void)sb_hiddenTips;
+ (void)sb_hiddenTipsInView:(nonnull UIView *)view;

// 显示提示信息 （无按钮）
+ (void)sb_showTips:(nonnull NSString *)tips;

// 显示提示信息（可设定自动隐藏时间） 
+ (void)sb_showTips:(nonnull NSString *)tips hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds;

// 显示提示信息（可设定是否显示转子） 
+ (void)sb_showTips:(nonnull NSString *)tips showIndicator:(BOOL)showIndicator;

// 显示提示信息（可设定自动隐藏时间、是否显示转子） 
+ (void)sb_showTips:(nonnull NSString *)tips showIndicator:(BOOL)showIndicator hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds;

@end


//通过ctrl弹窗
@interface UIViewController (sbalert)
// 隐藏当前提示
- (void)sb_hiddenTips;

// 显示提示信息 （无按钮）
- (void)sb_showTips:(nonnull NSString *)tips;

// 显示提示信息（可设定自动隐藏时间）
- (void)sb_showTips:(nonnull NSString *)tips hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds;

// 显示提示信息（可设定是否显示转子）
- (void)sb_showTips:(nonnull NSString *)tips showIndicator:(BOOL)showIndicator;

// 显示提示信息（可设定自动隐藏时间、是否显示转子）
- (void)sb_showTips:(nonnull NSString *)tips showIndicator:(BOOL)showIndicator hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds;


// 显示提示对话框
- (void)sb_showAlert:(nonnull NSString *)msg;

//只在iOS7以后有效
// 显示提示对话框(只有一个确定)
- (void)sb_showAlert:(nonnull NSString *)msg handler:(void (^ __nullable)(UIAlertAction *action))handler;

// 显示提示对话框(一个确定和一个取消)
- (void)sb_showConfirm:(nonnull NSString *)msg cancel:(void (^ __nullable)(UIAlertAction *action))cancel handler:(void (^ __nullable)(UIAlertAction *action))handler;

@end


//通过view弹窗
@interface UIView (sbalert)
// 隐藏当前提示
- (void)sb_hiddenTips;

// 显示提示信息 （无按钮）
- (void)sb_showTips:(nonnull NSString *)tips;

// 显示提示信息（可设定自动隐藏时间）
- (void)sb_showTips:(nonnull NSString *)tips hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds;

// 显示提示信息（可设定是否显示转子）
- (void)sb_showTips:(nonnull NSString *)tips showIndicator:(BOOL)showIndicator;

// 显示提示信息（可设定自动隐藏时间、是否显示转子）
- (void)sb_showTips:(nonnull NSString *)tips showIndicator:(BOOL)showIndicator hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds;

@end

