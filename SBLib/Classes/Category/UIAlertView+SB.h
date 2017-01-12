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

NS_ASSUME_NONNULL_BEGIN

//通过ctrl弹窗
@interface UIViewController (sbalert)
// 隐藏当前提示
- (void)sb_hiddenTips;

// 显示提示信息 （无按钮）
- (MBProgressHUD *)sb_showTips:(NSString *)tips;

// 显示提示信息（可设定自动隐藏时间）
- (MBProgressHUD *)sb_showTips:(NSString *)tips hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds;

// 显示提示信息（可设定是否显示转子）
- (MBProgressHUD *)sb_showTips:(NSString *)tips showIndicator:(BOOL)showIndicator;

// 显示提示信息（可设定自动隐藏时间、是否显示转子）
- (MBProgressHUD *)sb_showTips:(NSString *)tips showIndicator:(BOOL)showIndicator hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds;

// 显示提示对话框
- (void)sb_showAlert:(NSString *)msg;

//只在iOS7以后有效
// 显示提示对话框(只有一个确定)
- (void)sb_showAlert:(NSString *)msg handler:(void (^ __nullable)(UIAlertAction *action))handler;

// 显示提示对话框(一个确定和一个取消)
- (void)sb_showConfirm:(NSString *)msg cancel:(void (^ __nullable)(UIAlertAction *action))cancel handler:(void (^ __nullable)(UIAlertAction *action))handler;

@end


//通过view弹窗
@interface UIView (sbalert)
// 隐藏当前提示
+ (void)sb_hiddenTips;
+ (void)sb_hiddenTipsInView:(UIView *)view;

// 显示提示信息 （无按钮）
+ (MBProgressHUD *)sb_showTips:(NSString *)tips;

// 显示提示信息（可设定自动隐藏时间）
+ (MBProgressHUD *)sb_showTips:(NSString *)tips hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds;

// 显示提示信息（可设定是否显示转子）
+ (MBProgressHUD *)sb_showTips:(NSString *)tips showIndicator:(BOOL)showIndicator;

// 显示提示信息（可设定自动隐藏时间、是否显示转子）
+ (MBProgressHUD *)sb_showTips:(NSString *)tips showIndicator:(BOOL)showIndicator hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds;


/** 实例方法 **/

// 隐藏当前提示
- (void)sb_hiddenTips;

// 显示提示信息 （无按钮）
- (MBProgressHUD *)sb_showTips:(NSString *)tips;

// 显示提示信息（可设定自动隐藏时间）
- (MBProgressHUD *)sb_showTips:(NSString *)tips hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds;

// 显示提示信息（可设定是否显示转子）
- (MBProgressHUD *)sb_showTips:(NSString *)tips showIndicator:(BOOL)showIndicator;

// 显示提示信息（可设定自动隐藏时间、是否显示转子）
- (MBProgressHUD *)sb_showTips:(NSString *)tips showIndicator:(BOOL)showIndicator hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds;

// 显示提示信息（可设定自动隐藏时间、是否显示转子， 结束事件）
- (MBProgressHUD *)sb_showTips:(NSString *)tips showIndicator:(BOOL)showIndicator hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds completion:(void (^)())completion;

/** 创建hud **/
- (MBProgressHUD *)sb_createHud:(MBProgressHUDMode)mode;

@end

NS_ASSUME_NONNULL_END

