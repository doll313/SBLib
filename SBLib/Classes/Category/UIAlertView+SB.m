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

//通过ctrl弹窗
@implementation UIViewController (sbalert)

// 隐藏当前提示
- (void)sb_hiddenTips {
    [self.view sb_hiddenTips];
}

// 显示提示信息 （无按钮）
- (MBProgressHUD *)sb_showTips:(NSString *)tips {
   return  [self.view sb_showTips:tips];
}

// 显示提示信息（可设定自动隐藏时间）
- (MBProgressHUD *)sb_showTips:(NSString *)tips hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds {
   return  [self.view sb_showTips:tips hiddenAfterSeconds:hiddenAfterSeconds];
}

// 显示提示信息（可设定是否显示转子）
- (MBProgressHUD *)sb_showTips:(NSString *)tips showIndicator:(BOOL)showIndicator {
    return [self.view sb_showTips:tips showIndicator:showIndicator];
}

// 显示提示信息（可设定自动隐藏时间、是否显示转子）
- (MBProgressHUD *)sb_showTips:(NSString *)tips showIndicator:(BOOL)showIndicator hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds {
    return [self.view sb_showTips:tips showIndicator:showIndicator hiddenAfterSeconds:hiddenAfterSeconds];
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
+ (MBProgressHUD *)sb_showTips:(NSString *)tips {
    return [UIWindow sb_showTips:tips showIndicator:NO hiddenAfterSeconds:0];
}

/** 显示提示信息（可设定自动隐藏时间） */
+ (MBProgressHUD *)sb_showTips:(NSString *)tips hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds {
    return [UIWindow sb_showTips:tips showIndicator:NO hiddenAfterSeconds:hiddenAfterSeconds];
}

/** 显示提示信息（可设定是否显示转子） */
+ (MBProgressHUD *)sb_showTips:(NSString *)tips showIndicator:(BOOL)showIndicator {
    return [UIWindow sb_showTips:tips showIndicator:showIndicator hiddenAfterSeconds:0];
}

/** 显示提示信息（可设定自动隐藏时间、是否显示转子） */
+ (MBProgressHUD *)sb_showTips:(NSString *)tips showIndicator:(BOOL)showIndicator hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds {
    UIView *keyView = [UIWindow systemKeyboardView];
    return [keyView sb_showTips:tips showIndicator:showIndicator hiddenAfterSeconds:hiddenAfterSeconds];
}

// 隐藏当前提示
- (void)sb_hiddenTips {
    [MBProgressHUD hideHUDForView:self animated:YES];
}

// 显示提示信息 （无按钮）
- (MBProgressHUD *)sb_showTips:(NSString *)tips {
    return [self sb_showTips:tips hiddenAfterSeconds:0];
}

// 显示提示信息（可设定自动隐藏时间）
- (MBProgressHUD *)sb_showTips:(NSString *)tips hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds {
    return [self sb_showTips:tips showIndicator:NO hiddenAfterSeconds:hiddenAfterSeconds];
}

// 显示提示信息（可设定是否显示转子）
- (MBProgressHUD *)sb_showTips:(NSString *)tips showIndicator:(BOOL)showIndicator {
    return [self sb_showTips:tips showIndicator:showIndicator hiddenAfterSeconds:0];
}
// 显示提示信息（可设定自动隐藏时间、是否显示转子）
- (MBProgressHUD *)sb_showTips:(NSString *)tips showIndicator:(BOOL)showIndicator hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds {
    return [self sb_showTips:tips showIndicator:showIndicator hiddenAfterSeconds:hiddenAfterSeconds completion:nil];
}

// 显示提示信息（可设定自动隐藏时间、是否显示转子、结束）
- (MBProgressHUD *)sb_showTips:(NSString *)tips showIndicator:(BOOL)showIndicator hiddenAfterSeconds:(CGFloat)hiddenAfterSeconds completion:(void (^__nullable)())completion {
    if (!tips) {
        tips = @"";
    }

    BOOL hasTips = tips.length > 0;

    //不带文字 加载中...
    if (!hasTips || hiddenAfterSeconds == 0) {
        showIndicator = YES;
    }

    [MBProgressHUD hideHUDForView:self animated:YES];

    MBProgressHUDMode mode = showIndicator ? MBProgressHUDModeIndeterminate : MBProgressHUDModeText;
    MBProgressHUD *hud = [self sb_createHud:mode];
    hud.label.text = tips;

    //隐藏
    if (hiddenAfterSeconds > 0) {
        [hud hideAnimated:YES afterDelay:hiddenAfterSeconds];
    }

    //结束
    if (completion) {
        hud.completionBlock = completion;
    }

    return hud;
}

/** 创建hud **/
- (MBProgressHUD *)sb_createHud:(MBProgressHUDMode)mode {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.label.numberOfLines = 10;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];
    hud.mode = mode;

    return hud;
}
@end

