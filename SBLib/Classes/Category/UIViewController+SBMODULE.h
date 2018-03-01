//
//  UIViewController+SBMODULE.h
//  SBLib
//
//  Created by roronoa on 2018/1/19.
//

#import <UIKit/UIKit.h>

//为SDK自带的 UIViewController 类添加一些实用方法
@interface UIViewController (sbmodule)

/** 分享沙盒地址 **/
- (void)sb_shareDocumentPath:(NSString *_Nonnull)path;

@end

//为SDK自带的 UINavigationController 类添加一些实用方法 基本上都是常用色值
@interface UINavigationController (sbmodule)
/** 全透明 **/
- (void)sb_beTranslucent;

/** 色调模式 **/
- (void)sb_beColored:(UIColor *_Nonnull)color;
@end

/** controller的扩展方法 */
@interface UIWindow (sbmodule)

/** 猜测的 root nav **/
+ (UINavigationController *_Nullable)sb_rootNav;

/** 猜测的 root ctrl **/
+ (UIViewController *_Nullable)sb_rootCtrl;

@end
