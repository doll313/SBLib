/*
 #####################################################################
 # File    : SBCONSTANT.h
 # Project :
 # Created : 14-2-14
 # DevTeam : eastmoney
 # Author  : Thomas
 # Notes   : warning测试下
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
#ifndef SBCONSTANT_H
#define SBCONSTANT_H

//常用键值
#define __KEY_CELL_TITLE      @"<&__KEY_CELL_TITLE&>"           //表示标题
#define __KEY_CELL_VALUE      @"<&__KEY_CELL_VALUE&>"     //表示内容
#define __KEY_CELL_ICON      @"<&__KEY_CELL_ICON&>"     //表示图标
#define __KEY_CELL_CODE       @"<&__KEY_CELL_CODE&>"             //表示代码
#define __KEY_CELL_SKIN       @"<&__KEY_CELL_SKIN&>"             //表示皮肤
#define __KEY_CELL_SUBTITLE      @"<&__KEY_CELL_SUBTITLE&>"           //表示副标题
#define __KEY_CELL_TIME      @"<&__KEY_CELL_TIME&>"           //表示时间
#define __KEY_CELL_LOCATION      @"<&__KEY_CELL_LOCATION&>"           //表示地点
#define __KEY_CELL_USER      @"<&__KEY_CELL_USER&>"           //表示用户

#define __KEY_CELL_EMPTY      @"<&__KEY_CELL_EMPTY&>"                //表示空数据
#define __KEY_CELL_SELECTED   @"<&__KEY_CELL_SELECTED&>"             //表示是否选中
#define __KEY_CELL_TAG        @"<&__KEY_CELL_TAG&>"                  //表示标记
#define __KEY_CELL_WIDTH      @"<&__KEY_CELL_WIDTH&>"               //单元格宽度
#define __KEY_CELL_HEIGHT     @"<&__KEY_CELL_HEIGHT&>"               //单元格高度
#define __KEY_CELL_INDEXTITLE      @"<&__KEY_CELL_INDEXTITLE&>"           //表示索引标题


#define __KEY_SECTION_HEADER_HEIGHT        @"<&__KEY_SECTION_HEADER_HEIGHT&>"       //表示段头的高度
#define __KEY_SECTION_FOOTER_HEIGHT        @"<&__KEY_SECTION_FOOTER_HEIGHT&>"            //表示段尾的高度

#define __SB_FONT_TABLE_DEFAULT_TIPS           14.0f               //提示默认字体
#define __SB_COLOR_TABLE_DEFAULT_TIPS           RGB(0x88, 0x88, 0x88)          //提示默认颜色

#define N2S(num) [NSString stringWithFormat:@"%lu", (num ? (unsigned long)num : 0)]
// 应用程序常规数据加密密码
#define APPCONFIG_APP_DATA_ENCRYPT_PASS     @"APPCONFIG_APP_DATA_ENCRYPT_PASS"

#define APPCONFIG_CONN_ERROR_MSG_DOMAIN     @"SBHttpTaskError"  // 连接出错信息标志

/** 色值 RGBA **/
#define RGB_A(r, g, b, a) [UIColor colorWithRed:(CGFloat)(r)/255.0f green:(CGFloat)(g)/255.0f blue:(CGFloat)(b)/255.0f alpha:(CGFloat)(a)]

/** 色值 RGB **/
#define RGB(r, g, b) RGB_A(r, g, b, 1)
#define RGB_HEX(__h__) RGB((__h__ >> 16) & 0xFF, (__h__ >> 8) & 0xFF, __h__ & 0xFF)

/** 弱引用自己 */
#define SBWS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

/** 是否为空 */
#define SBStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
#define SBArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
#define SBDictionaryIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
#define SBObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

/** 简写 */
#define SBApplication        [UIApplication sharedApplication]
#define SBKeyWindow          [UIApplication sharedApplication].keyWindow
#define SBAppDelegate        [UIApplication sharedApplication].delegate
#define SBUserDefaults      [NSUserDefaults standardUserDefaults]
#define SBNotificationCenter [NSNotificationCenter defaultCenter]
#define SBViewWithTag(_OBJECT, _TAG)    [_OBJECT viewWithTag : _TAG]
#define SBLocal(x, ...) NSLocalizedString(x, nil)
#define SBDispatchBack(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define SBDispatchMain(block) dispatch_async(dispatch_get_main_queue(),block)

/** 应用参数 **/
#define SBAppDisplayName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define SBAppBundleName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]
#define SBAppVersion    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define SBAppBuildVersion     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define SBSystemVersion [[UIDevice currentDevice] systemVersion]//系统版本号
#define SBCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])//获取当前语言
#define SBISiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)//判断是否为iPhone
#define SBISiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)//判断是否为iPad获取沙盒Document路径
#define SBDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]//获取沙盒Document路径
#define SBTempPath NSTemporaryDirectory()//获取沙盒temp路径
#define SBCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]//获取沙盒Cache路径

//版本
#define APPCONFIG_VERSION_OVER_5                 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0f)
#define APPCONFIG_VERSION_OVER_6                 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f)
#define APPCONFIG_VERSION_OVER_7                 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
#define APPCONFIG_VERSION_OVER_8                 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f)
#define APPCONFIG_VERSION_OVER_9                 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f)
#define APPCONFIG_VERSION_OVER_10                 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0f)
#define APPCONFIG_VERSION_OVER_(x)                 ([[[UIDevice currentDevice] systemVersion] floatValue] >= x)

// UI控件常规像素
#define APPCONFIG_UI_TABLE_CELL_HEIGHT      44.0f                       // UITableView 单元格默认高度
#define APPCONFIG_UI_TIPS_SHOW_SECONDS      2.0f                        // 自动隐藏的弹窗，显示的时间（单位秒）
#define APPCONFIG_UI_STATUSBAR_HEIGHT       20.0f                       // 系统自带的状态条的高度
#define APPCONFIG_UI_NAVIGATIONBAR_HEIGHT   44.0f                       // 系统自带的导航条的高度
#define APPCONFIG_UI_TOOLBAR_HEIGHT         44.0f                       // 系统自带的工具条的高度
#define APPCONFIG_UI_TABBAR_HEIGHT          49.0f                       // 系统自带分页条的高度
#define APPCONFIG_UI_SEARCHBAR_HEIGHT       44.0f                       // 系统自带的搜索框的高度

#define APPCONFIG_UI_TABLE_PADDING          10.0f                       // UITableView 的默认边距
#define APPCONFIG_UI_WIDGET_PADDING          5.0f                       // 控件 的默认边距


// UI 界面大小
#define APPCONFIG_UI_SCREEN_SIZE                ([UIScreen mainScreen].bounds.size)             //屏幕大小
#define APPCONFIG_UI_SCREEN_FHEIGHT             ([UIScreen mainScreen].bounds.size.height)              //界面的高度
#define APPCONFIG_UI_SCREEN_FWIDTH              ([UIScreen mainScreen].bounds.size.width)               //界面的宽度
#define APPCONFIG_UI_CONTROLLER_FHEIGHT         (self.view.frame.size.height)                           //界面的高度
#define APPCONFIG_UI_CONTROLLER_FWIDTH          (self.view.frame.size.width)                              //界面的宽度
#define APPCONFIG_UI_VIEW_FHEIGHT               (self.frame.size.height)                                //界面的高度
#define APPCONFIG_UI_VIEW_FWIDTH                (self.frame.size.width)                              //界面的宽度

#define APPCONFIG_UNIT_LINE_WIDTH                (1/[UIScreen mainScreen].scale)       //常用线宽

#define APPCONFIG_AES_KEY                       @"l$LmR+s]7,=t^i+[#m!~]S.nCgKEh*mT"      //AES用的key（32位的）
#define APPCONFIG_LOGIN_DES_KEY                 @"b154054573c72ecd66ab57b1e35c0671"      //登录用的key


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>                         //UI
#import <QuartzCore/QuartzCore.h>               //绘制

//三方
#import "MBProgressHUD.h"           //hud
#import "MJRefresh.h"               //下拉刷新
#import "FMDB.h"                    //fmdb


//数据库键值对宏
#import "STORE.h"
//单例
#import "SBObjectSingleton.h"

//股吧数据类
#import "DataItemDetail.h"
#import "DataItemResult.h"
//缓存数据库
#import "DataAppCacheDB.h"
//核心数据库
#import "DataAppCoreDB.h"
//数据库事件
#import "SBDataBaseEvent+Queue.h"
//文件管理
#import "SBFileManager.h"

//应用级别全局方法
#import "SBAppCoreInfo.h"

//日志系统
#import "SBExceptionLog.h"

//网络状态
#import "SBNetworkReachability.h"

//网络请求
#import "SBHttpTask.h"
#import "SBHttpDataLoader.h"
#import "SBHttpHelper.h"

//扩展
#import "UIView+SBMODULE.h" //视图扩展
#import "NSString+SBMODULE.h"   //字符串扩展
#import "Component+SBMODULE.h"      //一些空间的扩展
#import "UIBarButtonItem+SBMODULE.h"    //导航条按钮扩展
#import "UIButton+SBMODULE.h"           //按钮扩展
#import "UIImage+SBMODULE.h"            //图片扩展
#import "NSData+SBMODULE.h"         //数据扩展
#import "NSDate+SBMODULE.h"     //日期扩展
#import "NSObject+SBMODULE.h"
#import "NSDictionary+SBMODULE.h"       //字典扩展
#import "UIAlertView+SB.h"          //警告扩展

//方法集合
#import "SBPureColorImageGenerator.h"       //纯色图  ps 能不用就不要用了
#import "SBURLAction.h"                 //界面跳转 （url形式）
#import "SBNetworkFlow.h"       //流量信息

//界面
#import "SBBasicController.h"

//列表
#import "SBTableView.h"
#import "SBTableData.h"

//CollectionView
#import "SBCollectionView.h"            //Collcetion 控件
#import "SBCollectionData.h"        //Collection数据
#import "SBDataCollectionCell.h"        //Collocation 默认单元格

//单元格
#import "SBDataTableCell.h"
#import "SBErrorTableCell.h"
#import "SBEmptyTableCell.h"
#import "SBMoreTableCell.h"

#import "SBLoadingTableCell.h"
#import "SBFinishedTableCell.h"

#import "SBTitleCell.h"
#import "SBSwitchCell.h"

//图文标签，点击使用
#import "SBLinkLabel.h"
#import "NSAttributedString+Attributes.h"

//图片选择器
#import "SBImagePickerController.h"

/** 全局调试开关
 //#ifdef assert
 //#undef assert
 //#endif
 //
 //#define assert(x)
 //#define NSLog(s, ...)
 */

#endif

