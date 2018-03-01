//
//  UIViewController+SBMODULE.m
//  SBLib
//
//  Created by roronoa on 2018/1/19.
//

#import "UIViewController+SBMODULE.h"       //UIViewController 扩展
#import "UIImage+SBMODULE.h"

//为SDK自带的 UIViewController 类添加一些实用方法
@implementation UIViewController (sbmodule)

/** 分享沙盒地址 **/
- (void)sb_shareDocumentPath:(NSString *_Nonnull)path {

    NSURL *url = [NSURL fileURLWithPath:path];
    NSArray *objectsToShare = @[url];

    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    NSArray *excludedActivities = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,
                                    UIActivityTypePostToWeibo,
                                    UIActivityTypeMessage, UIActivityTypeMail,
                                    UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                    UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    controller.excludedActivityTypes = excludedActivities;

    if (SBISiPad) {
        controller.popoverPresentationController.sourceView = self.view;
        controller.popoverPresentationController.sourceRect = CGRectMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height, 10, 10);
    }
    [self presentViewController:controller animated:YES completion:nil];
}

@end


@implementation UINavigationController (sbmodule)

/** 全透明 **/
- (void)sb_beTranslucent {
    //
    self.navigationBar.barStyle = UIBarStyleBlack;
    //透明色
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //横线
    self.navigationBar.shadowImage = [UIImage new];
    //导航条不透明（不模糊）
    self.navigationBar.translucent = YES;
}

/** 色调模式 **/
- (void)sb_beColored:(UIColor *)color {
    //默认黑色风格
    self.navigationBar.barStyle = UIBarStyleBlack;
    //自定义背景
    UIImage *nImage = [UIImage sb_imageWithColor:color];
    [self.navigationBar setBackgroundImage:nImage forBarMetrics:UIBarMetricsDefault];
    //消除阴影
    self.navigationBar.shadowImage = [UIImage new];
    //导航条不透明（不模糊）
    self.navigationBar.translucent = NO;
}

@end


/** controller的扩展方法 */
@implementation UIWindow (sbmodule)

/** 猜测的 root ctrl **/
+ (UINavigationController *_Nullable)sb_rootNav {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIViewController *rCtrl = window.rootViewController;
    if ([rCtrl isKindOfClass:[UITabBarController class]]) {
        UITabBarController *mainTabBarController = (UITabBarController *)rCtrl;
        UIViewController *sCtrl = mainTabBarController.selectedViewController;
        if ([sCtrl isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)sCtrl;
        }
    }
    else if ([rCtrl isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)rCtrl;
    }
    return rCtrl.navigationController;
}


/** 猜测的 root ctrl **/
+ (UIViewController *_Nullable)sb_rootCtrl {
    UINavigationController *navCtrl = [UIWindow sb_rootNav];
    return navCtrl.topViewController;
}

@end

