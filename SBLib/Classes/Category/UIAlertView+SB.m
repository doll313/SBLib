/*
#####################################################################
# File    : UIAlertViewCategory.m
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


#import "UIAlertView+SB.h"


@implementation UIWindow (sbalert)

/** 获取window 弹出的时候不会被键盘遮住 */
+ (UIView *)systemKeyboardView {
    UIView *view =  [[UIApplication sharedApplication].delegate window];
    return view;
}

/** 隐藏当前实例 */
+ (void)sb_hiddenTips {
    UIView *keyView = [UIWindow systemKeyboardView];
    [self sb_hiddenTipsInView:keyView];
}

+ (void)sb_hiddenTipsInView:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:YES];
}

/** 显示提示信息 */
+ (void)sb_showTips:(NSString *)tips {
	[UIWindow sb_showTips:tips showIndicator:NO hiddenAfterSeconds:0];
}

/** 显示提示信息（可设定自动隐藏时间） */
+ (void)sb_showTips:(NSString *)tips hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds {
	[UIWindow sb_showTips:tips showIndicator:NO hiddenAfterSeconds:hiddenAfterSeconds];
}

/** 显示提示信息（可设定是否显示转子） */
+ (void)sb_showTips:(NSString *)tips showIndicator:(BOOL)showIndicator {
	[UIWindow sb_showTips:tips showIndicator:showIndicator hiddenAfterSeconds:0];
}

/** 显示提示信息（可设定自动隐藏时间、是否显示转子） */
+ (void)sb_showTips:(NSString *)tips showIndicator:(BOOL)showIndicator hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds {
    UIView *keyView = [UIWindow systemKeyboardView];
    [UIWindow sb_showTips:tips inView:keyView showIndicator:showIndicator hiddenAfterSeconds:hiddenAfterSeconds];
}

// ///////////////////////////////////////////////////////////////////////////

// 显示提示信息 （无按钮）
+ (void)sb_showTips:(NSString *)tips inView:(UIView *)view {
    [UIWindow sb_showTips:tips inView:view showIndicator:YES hiddenAfterSeconds:0];
}

// 显示提示信息（可设定自动隐藏时间）
+ (void)sb_showTips:(NSString *)tips inView:(UIView *)view hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds {
    [UIWindow sb_showTips:tips inView:view showIndicator:NO hiddenAfterSeconds:hiddenAfterSeconds];
}

// 显示提示信息（可设定是否显示转子）
+ (void)sb_showTips:(NSString *)tips inView:(UIView *)view showIndicator:(BOOL)showIndicator {
    [UIWindow sb_showTips:tips inView:view showIndicator:showIndicator hiddenAfterSeconds:0];
}

// 显示提示信息（可设定自动隐藏时间、是否显示转子）
+ (void)sb_showTips:(NSString *)tips inView:(UIView *)view showIndicator:(BOOL)showIndicator hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds {
    BOOL hasTips = (tips.length == 0 || [tips isKindOfClass:[NSNull class]]);

    //不带文字 并且也不是转圈的
    if (hasTips && !showIndicator) {
        return;
    }
    
    [MBProgressHUD hideHUDForView:view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = tips;
    hud.label.numberOfLines = 10;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];
    
    NSString *customViewImage = [[NSBundle mainBundle] infoDictionary][@"SBModuleConfig"][@"ProgressHudCustomView"];
    if (customViewImage.length > 0) {
        hud.mode = MBProgressHUDModeCustomView;
        UIImage *image = [[UIImage imageNamed:customViewImage] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        hud.customView = [[UIImageView alloc] initWithImage:image];
        hud.square = YES;
    }
    else if (!showIndicator) {
        hud.mode = MBProgressHUDModeText;
    }
    else {
        hud.mode = MBProgressHUDModeIndeterminate;
    }
    
    //隐藏
    if (hiddenAfterSeconds > 0) {
        [hud hideAnimated:YES afterDelay:hiddenAfterSeconds];
    }
}

@end


//通过ctrl弹窗
@implementation UIViewController (sbalert)

// 隐藏当前提示
- (void)sb_hiddenTips {
    [UIWindow sb_hiddenTipsInView:self.view];
}

// 显示提示信息 （无按钮）
- (void)sb_showTips:(NSString *)tips {
    [UIWindow sb_showTips:tips inView:self.view];
}

// 显示提示信息（可设定自动隐藏时间）
- (void)sb_showTips:(NSString *)tips hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds {
    [UIWindow sb_showTips:tips inView:self.view hiddenAfterSeconds:hiddenAfterSeconds];
}

// 显示提示信息（可设定是否显示转子）
- (void)sb_showTips:(NSString *)tips showIndicator:(BOOL)showIndicator {
    [UIWindow sb_showTips:tips inView:self.view showIndicator:showIndicator];
}

// 显示提示信息（可设定自动隐藏时间、是否显示转子）
- (void)sb_showTips:(NSString *)tips showIndicator:(BOOL)showIndicator hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds {
    [UIWindow sb_showTips:tips inView:self.view showIndicator:showIndicator hiddenAfterSeconds:hiddenAfterSeconds];
}

// 显示提示对话框
- (void)sb_showAlert:(NSString *)msg {
    [self sb_showAlert:msg handler:nil];
}

// 显示提示对话框(只有一个确定)
- (void)sb_showAlert:(NSString *)msg handler:(void (^ __nullable)(UIAlertAction *action))handler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler(action);
        }
    }];
    
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 显示提示对话框(一个确定和一个取消)
- (void)sb_showConfirm:(nonnull NSString *)msg cancel:(void (^ __nullable)(UIAlertAction *action))cancel handler:(void (^ __nullable)(UIAlertAction *action))handler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancel) {
            cancel(action);
        }
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler(action);
        }
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end


//通过view弹窗
@implementation UIView (sbalert)
// 隐藏当前提示
- (void)sb_hiddenTips {
    [UIWindow sb_hiddenTipsInView:self];
}

// 显示提示信息 （无按钮）
- (void)sb_showTips:(NSString *)tips {
    [UIWindow sb_showTips:tips inView:self];
}

// 显示提示信息（可设定自动隐藏时间）
- (void)sb_showTips:(NSString *)tips hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds {
    [UIWindow sb_showTips:tips inView:self hiddenAfterSeconds:hiddenAfterSeconds];
}

// 显示提示信息（可设定是否显示转子）
- (void)sb_showTips:(NSString *)tips showIndicator:(BOOL)showIndicator {
    [UIWindow sb_showTips:tips inView:self showIndicator:showIndicator];
}

// 显示提示信息（可设定自动隐藏时间、是否显示转子）
- (void)sb_showTips:(NSString *)tips showIndicator:(BOOL)showIndicator hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds {
    [UIWindow sb_showTips:tips inView:self showIndicator:showIndicator hiddenAfterSeconds:hiddenAfterSeconds];
}

@end
