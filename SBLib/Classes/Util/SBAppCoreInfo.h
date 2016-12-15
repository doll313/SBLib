/*
#####################################################################
# File    : AppCoreInfo.h
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
#import "SBObjectSingleton.h"

/** 有关内存泄漏的调试信息 */
#define DEBUG_MALLOC_FOR_CTRL             @"DEBUG_MALLOC_FOR_CTRL" // 打印 界面 资源释放和分配的情况
#define DEBUG_MALLOC_FOR_TABLE_CELL             @"DEBUG_MALLOC_FOR_TABLE_CELL" // 打印 单元格 资源释放和分配的情况
#define DEBUG_MALLOC_FOR_COLLECTION_CELL             @"DEBUG_MALLOC_FOR_COLLECTION_CELL" // 打印 单元格 资源释放和分配的情况
#define DEBUG_MALLOC_FOR_DATA_ITEM              @"DEBUG_MALLOC_FOR_DATA_ITEM"  // 打印 DataItemDetail DataItemResult 资源释放和分配的情况

/** 其他自定义调试信息 */
#define DEBUG_HTTP_REQUEST_URL_PRINT            @"DEBUG_HTTP_REQUEST_URL_PRINT"  // 打印 HTTP 请求的网址
#define DEBUG_HTTP_RECIEVE_RAM                  @"DEBUG_HTTP_RECIEVE_RAM"  // 打印 HTTP 请求的包的大小
#define DEBUG_LOG_CLICK_EVENT                   @"DEBUG_LOG_CLICK_EVENT"  //统计点打印

@class DataAppCacheDB;
@class DataAppCoreDB;

/**
 *   1.应用级别的方法
 */
@interface SBAppCoreInfo : NSObject {
@private
}

//app相关
@property (nonatomic, strong) NSMutableArray *controllerStack;       //ctrl路径
@property (nonatomic, assign) NSInteger netWorkIndicatorCount;     //请求转子flag
@property (nonatomic, strong) DataAppCacheDB *appCacheDB;        //缓存数据库
@property (nonatomic, strong) DataAppCoreDB *appCoreDB;      //核心数据库
@property (nonatomic, strong) NSOperationQueue *appCacheQueue;      //缓存任务队列
@property (nonatomic, strong) NSOperationQueue *appCoreQueue;      //核心任务队列
@property (nonatomic, strong) DataItemDetail *appConfig;      //应用配制
@property (nonatomic, copy) NSString *clientSign;      //客户端标记
@property (nonatomic, copy) NSString *appDownloadUrl;/** 获取字符形式的应用下载地址 */
@property (nonatomic, copy) NSString *appCommentUrl;/** 获取字符形式的应用评论地址 */
@property (nonatomic, copy) NSString *appDisplayName;/** 获取字符形式的应用名 */
@property (nonatomic, copy) NSString *appVersionName;/** 获取字符形式的应用版本号 */
@property (nonatomic, copy) NSString *appProductName;/** 获取字符形式的工程名 */
@property (nonatomic, copy) NSString *appBuildVersion;/** 获取字符形式的build版本  */
@property (nonatomic, copy) NSString *appClientName;/** 获取客户端名称 */
@property (nonatomic, copy) NSString *deviceToken;/** 获取应用的推送token */
@property (nonatomic, assign) NSInteger appVersionCode;/** 获取整数型应用版本号 */


//设备相关
@property (nonatomic, assign) CGFloat systemVersionCode; //当前系统浮点型版本号

@property (nonatomic, copy) NSString *mac;/** 获取设备的mac地址 */
@property (nonatomic, copy) NSString *idfa;/** 广告标示符 用于app推广 */
@property (nonatomic, copy) NSString *idfv;/** 应用标示符 这个删应用会重置 */
@property (nonatomic, copy) NSString *keychainId;/** 保存在钥匙串中的唯一标识 */
@property (nonatomic, copy) NSString *clientOS;/** 获取本地设备的操作系统及版本 */
@property (nonatomic, copy) NSString *clientMachine;/** 获取设备的类型 */
@property (nonatomic, assign) BOOL isJailBreak;/** 设备是否越狱 */

SB_ARC_SINGLETON_DEFINE(SBAppCoreInfo);

/** 开始当前实例 很重要，最好在launch中率先运行 */
+ (void)install;

/** 销毁当前实例 */
+ (void)destroy;

/** 获取全局缓存数据库对象 */
+ (DataAppCacheDB *)getCacheDB;

/** 获取全局应用设定数据库对象 */
+ (DataAppCoreDB *)getCoreDB;

/** 当前设备的系统版本 */
+ (CGFloat)systemVersion;

/** 当前应用的版本 */
+ (NSString *)shortVersionString;

/** 推送用的标识码 */
+ (NSString *)deviceToken;

/** 设备唯一标识 */
+ (NSString *)idfv;

//运营商
+ (NSString *)telephonyNetworkInfo;

/** 获取全局缓存任务队列 */
+ (NSOperationQueue *)getCacheQueue;

/** 获取全局应用任务队列 */
+ (NSOperationQueue *)getCoreQueue;

/** 从一个 NSError 对象中解析错误信息 */
+ (NSString *)descriptionFromError:(NSError *)error;

/** 语言包提取函数 */
+ (NSString *)getLocalizedString:(NSString *)key;

/** 获取app的描述 **/
+(NSString *)sb_description;

@end
 
