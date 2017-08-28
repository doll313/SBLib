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

@class DataAppCacheDB;
@class DataAppCoreDB;
@class DataItemDetail;

/**
 *   1.应用级别的方法
 */
@interface SBAppCoreInfo : NSObject {
@private
}

//app相关
@property (nonatomic, strong) NSMutableArray * _Nullable controllerStack;       //ctrl路径
@property (nonatomic, assign) NSInteger netWorkIndicatorCount;     //请求转子flag
@property (nonatomic, strong) DataAppCacheDB * _Nullable appCacheDB;        //缓存数据库
@property (nonatomic, strong) DataAppCoreDB * _Nullable appCoreDB;      //核心数据库
@property (nonatomic, strong) NSOperationQueue * _Nullable appCacheQueue;      //缓存任务队列
@property (nonatomic, strong) NSOperationQueue * _Nullable appCoreQueue;      //核心任务队列
@property (nonatomic, strong) DataItemDetail * _Nullable appConfig;      //应用配制
@property (nonatomic, copy) NSString * _Nullable clientSign;      //客户端标记
@property (nonatomic, copy) NSString * _Nullable appDownloadUrl;/** 获取字符形式的应用下载地址 */
@property (nonatomic, copy) NSString * _Nullable appCommentUrl;/** 获取字符形式的应用评论地址 */
@property (nonatomic, copy) NSString *_Nonnull appDisplayName;/** 获取字符形式的应用名 */
@property (nonatomic, copy) NSString *_Nonnull appVersionName;/** 获取字符形式的应用版本号 */
@property (nonatomic, copy) NSString *_Nonnull appProductName;/** 获取字符形式的工程名 */
@property (nonatomic, copy) NSString *_Nonnull appBuildVersion;/** 获取字符形式的build版本  */
@property (nonatomic, copy) NSString *_Nonnull appClientName;/** 获取客户端名称 */
@property (nonatomic, copy) NSString *_Nonnull deviceToken;/** 获取应用的推送token */
@property (nonatomic, assign) NSInteger appVersionCode;/** 获取整数型应用版本号 */


//设备相关
@property (nonatomic, assign) CGFloat systemVersionCode; //当前系统浮点型版本号

@property (nonatomic, copy) NSString * _Nonnull mac;/** 获取设备的mac地址 */
@property (nonatomic, copy) NSString * _Nonnull idfa;/** 广告标示符 用于app推广 */
@property (nonatomic, copy) NSString * _Nonnull idfv;/** 应用标示符 这个删应用会重置 */
@property (nonatomic, copy) NSString * _Nonnull keychainId;/** 保存在钥匙串中的唯一标识 */
@property (nonatomic, copy) NSString * _Nonnull clientOS;/** 获取本地设备的操作系统及版本 */
@property (nonatomic, copy) NSString * _Nonnull clientMachine;/** 获取设备的类型 */
@property (nonatomic, assign) BOOL isJailBreak;/** 设备是否越狱 */

SB_ARC_SINGLETON_DEFINE(SBAppCoreInfo);

/** 开始当前实例 很重要，最好在launch中率先运行 */
+ (void)install;

/** 销毁当前实例 */
+ (void)destroy;

/** 获取全局缓存数据库对象 */
+ (DataAppCacheDB *_Nonnull)getCacheDB;

/** 获取全局应用设定数据库对象 */
+ (DataAppCoreDB *_Nonnull)getCoreDB;

/** 当前设备的系统版本 */
+ (CGFloat)systemVersion;

/** 当前应用的版本 */
+ (NSString *_Nonnull)shortVersionString;

/** 推送用的标识码 */
+ (NSString *_Nullable)deviceToken;

/** 设备唯一标识 */
+ (NSString *_Nonnull)idfv;

//运营商
+ (NSString *_Nullable)telephonyNetworkInfo;

/** 获取全局缓存任务队列 */
+ (NSOperationQueue *_Nonnull)getCacheQueue;

/** 获取全局应用任务队列 */
+ (NSOperationQueue *_Nonnull)getCoreQueue;

/** 从一个 NSError 对象中解析错误信息 */
+ (NSString *_Nonnull)descriptionFromError:(NSError *_Nullable)error;

/** 语言包提取函数 */
+ (NSString *_Nullable)getLocalizedString:(NSString *_Nonnull)key;

/** 获取应用当前的 CPU */
+ (CGFloat)getCpuUsage;

/** 获取当前应用的内存 */
+ (CGFloat)getUsedMemory;

/** 获取app的描述 **/
+(NSString *_Nonnull)sb_description;

@end
 
