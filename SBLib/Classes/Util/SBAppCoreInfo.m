/*
#####################################################################
# File    : AppCoreInfo.m
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

#import "SBAppCoreInfo.h"

#import "STORE.h"
#import "SBExceptionLog.h"
#import "SBFileManager.h"
#import "DataAppCacheDB.h"
#import "DataAppCoreDB.h"
#import "SBNetworkReachability.h"
#import "STKeychain.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

//
#include <sys/utsname.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

//for idfa
#import <AdSupport/AdSupport.h>

#import <mach/mach.h>


static int const kMultiteNetWorkCount = 20;          //并行的网络请求数

@implementation SBAppCoreInfo

SB_ARC_SINGLETON_IMPLEMENT(SBAppCoreInfo);

-(void)destroySBAppCoreInfo {
    
}

/** 初始化变量和数据库 */
- (id)init {
    self = [super init];
    
    // 初始化应用生命期间内相关的一揽子变量
    self.netWorkIndicatorCount = 0;
    
    self.appCoreDB = [[DataAppCoreDB alloc] init];
    self.appCacheDB = [[DataAppCacheDB alloc] init];
    self.appCacheQueue = [[NSOperationQueue alloc] init];
    self.appCoreQueue = [[NSOperationQueue alloc] init];
    self.appCoreQueue.maxConcurrentOperationCount = kMultiteNetWorkCount;
    self.appCacheQueue.maxConcurrentOperationCount = kMultiteNetWorkCount;
    self.appConfig = [[DataItemDetail alloc] init];
    
    self.mac = [self macString];/** 获取设备的mac地址 */
    self.idfa = [self idfaString];/** 广告标示符 用于app推广 */
    self.idfv = [self idfvString];/** 应用标示符 这个删应用会重置 */
    self.keychainId = [self keychainIdString];   /** 保存在钥匙串中的唯一标识 */
    self.clientOS = [self getOS];/** 获取本地设备的操作系统及版本 */
    self.clientMachine = [self getMachine];/** 获取设备的类型 */
    self.appClientName = [[UIDevice currentDevice] model];
    
    /** 获取字符形式的应用名 */
    self.appDisplayName = SBAppDisplayName;
    
    /** 获取字符形式的应用版本号 */
    self.appVersionName = SBAppVersion;
    
    /** 获取字符形式的工程名 */
    self.appProductName = SBAppBundleName;

    /** 获取字符形式的build版本 */
    self.appBuildVersion = SBAppBuildVersion;
    
    // 获取当前系统浮点型版本号
    self.systemVersionCode = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    //是否越狱
    self.isJailBreak = [SBAppCoreInfo isJailed];
    
    self.clientSign = [SBFileManager stringFromResource:@"Config/client.sign"] ;
    self.controllerStack = [[NSMutableArray alloc] init];
    
    //日志
    [SBExceptionLog sharedSBExceptionLog];
    
    return self;
}

/** 销毁时，释放内存 */
- (void)dealloc {
    self.appCoreDB = nil;
    self.appCacheDB = nil;
    self.clientSign = nil;
    self.controllerStack = nil;
    self.appCoreQueue = nil;
    self.appCacheQueue = nil;
}

/** 开始当前实例 很重要，最好在launch中率先运行 */
+ (void)install {
    [SBAppCoreInfo sharedSBAppCoreInfo];
}

/** 销毁当前实例 */
+ (void)destroy {
    //销毁单例
}

/** 获取全局缓存数据库对象 */
+ (DataAppCacheDB *)getCacheDB {
    return [SBAppCoreInfo sharedSBAppCoreInfo].appCacheDB;
}

/** 获取全局应用设定数据库对象 */
+ (DataAppCoreDB *)getCoreDB {
    return [SBAppCoreInfo sharedSBAppCoreInfo].appCoreDB;
}

/** 获取全局缓存任务队列 */
+ (NSOperationQueue *)getCacheQueue {
    return [SBAppCoreInfo sharedSBAppCoreInfo].appCacheQueue;
}

/** 获取全局应用任务队列 */
+ (NSOperationQueue *)getCoreQueue {
    return [SBAppCoreInfo sharedSBAppCoreInfo].appCoreQueue;
}


/** 当前设备的系统版本 */
+ (CGFloat)systemVersion {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

/** 当前应用的版本 */
+ (NSString *)shortVersionString {
    NSString *shortVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if (SBStringIsEmpty(shortVersionString)) {
        shortVersionString = @"";
    }
    return shortVersionString;
}

- (void)setDeviceToken:(NSString *)deviceToken {
    if (SBStringIsEmpty(deviceToken)) {
        _deviceToken = @"";
    } else {
        _deviceToken = [NSString stringWithFormat:@"%@", deviceToken];
        [[SBAppCoreInfo getCoreDB] setStrValue:STORE_KEY_DEVICE_UUID dataKey:@"deviceToken" dataValue:deviceToken];
    }
    
}

/** 推送用的标识码 */
+ (NSString *)deviceToken {
    NSString *dt = [SBAppCoreInfo sharedSBAppCoreInfo].deviceToken;
    if (SBStringIsEmpty(dt)) {
        dt = [[SBAppCoreInfo getCoreDB] getStrValue:STORE_KEY_DEVICE_UUID dataKey:@"deviceToken"];
    }
    if (SBStringIsEmpty(dt)) {
        return @"";
    }
    return dt;
}


/** 设备唯一标识 */
+ (NSString *)idfv {
    return [[SBAppCoreInfo sharedSBAppCoreInfo] idfvString];
}

/** 从一个 NSError 对象中解析错误信息 */
+ (NSString *)descriptionFromError:(NSError *)error {
    if (nil == error) {
        return nil;
    }
    
    NSString *errDomain = [error domain];
    
    if (nil != errDomain && [errDomain isEqualToString:APPCONFIG_CONN_ERROR_MSG_DOMAIN]) {
        NSDictionary *userInfo = [error userInfo];
        
        if (nil != userInfo) {
            NSString *errorInfo = userInfo[APPCONFIG_CONN_ERROR_MSG_DOMAIN];
            if (!errorInfo && errorInfo.length > 0) {
                return errorInfo;
            }
        }
        
        return @"网路未链接!";
    }
    
    NSString *localizedDescription = [error localizedDescription];
    
    if (nil != localizedDescription && [localizedDescription length] > 0) {
        return @"网络貌似不给力，请稍后再来!";
    }
    
    return @"未知错误!";
}

- (NSString * )macString{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return macString;
}

- (NSString *)idfaString {
    NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
    [adSupportBundle load];
    if (adSupportBundle == nil) {
        return @"";
    }
    else{
        Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
        if(asIdentifierMClass == nil){
            return @"";
        }
        else{
            //for no arc
            //ASIdentifierManager *asIM = [[[asIdentifierMClass alloc] init] autorelease];
            //for arc
            ASIdentifierManager *asIM = [[asIdentifierMClass alloc] init];
            if (asIM == nil) {
                return @"";
            }
            else{
                if(asIM.advertisingTrackingEnabled){
                    return [asIM.advertisingIdentifier UUIDString];
                }
                else{
                    return [asIM.advertisingIdentifier UUIDString];
                }
            }
        }
    }
}

/** 手机唯一码 */
- (NSString *)keychainIdString {
    NSString *userName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    NSString *servername = [[NSBundle mainBundle] bundleIdentifier];
    
    NSString* identifier = [STKeychain getPasswordForUsername:userName andServiceName:servername error:nil];
    
    //先获取钥匙串中的
    if(identifier && identifier.length > 0) {
        return identifier;
    }
    else {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            identifier = [self idfvString];
        } else {
            NSString *macaddress = [SBAppCoreInfo sharedSBAppCoreInfo].mac;
            NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
            
            NSString *stringToHash = [NSString stringWithFormat:@"%@%@", macaddress, bundleIdentifier];
            identifier = [stringToHash sb_md5];
            
        }
        
        [STKeychain storeUsername:userName andPassword:identifier forServiceName:servername updateExisting:YES error:nil];
        return identifier;
    }
}


- (NSString *)idfvString {
    if([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    return @"";
}

//判断是否越狱
+ (BOOL)isJailed {
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath] || [[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }
    
    return jailbroken;
}


//运营商
+ (NSString *)telephonyNetworkInfo {
    //设置运营商信息
    CTTelephonyNetworkInfo	* telInfo = [[CTTelephonyNetworkInfo alloc] init];
    NSString  * carrierName = nil;
    if (telInfo.subscriberCellularProvider) {
        carrierName = telInfo.subscriberCellularProvider.carrierName;
    }
    if (SBStringIsEmpty(carrierName)) {
        carrierName = @"无";
    }
    
    return carrierName;
}


/** 获取本地设备的操作系统及版本 */
- (NSString *)getOS {
    UIDevice *device = [UIDevice currentDevice];
    return [NSString stringWithFormat:@"%@ %@", device.systemName, device.systemVersion];
}


/** 获取设备的类型 */
- (NSString *)getMachine {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = @(systemInfo.machine);
    //直接返回厂商给的字符串
    return deviceString;
}

/** 获取应用当前的 CPU */
+ (CGFloat)getCpuUsage {
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;

    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return 0;
    }

    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;

    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;

    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads

    basic_info = (task_basic_info_t)tinfo;

    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return 0;
    }
    if (thread_count > 0)
        stat_thread += thread_count;

    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;

    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return 0;
        }

        basic_info_th = (thread_basic_info_t)thinfo;

        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }

    } // for each thread

    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);

    return tot_cpu;
}

/** 获取当前应用的内存 */
+ (CGFloat)getUsedMemory {
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO, (task_info_t)&taskInfo, &infoCount);

    if(kernReturn != KERN_SUCCESS) {
        return 0;
    }

    return taskInfo.resident_size / 1024.0 / 1024.0;
}


/** 语言包提取函数 */
+ (NSString *)getLocalizedString:(NSString *)key {
    if (nil == key) {
        return nil;
    }
    
    NSString *value;
    
    value = NSLocalizedString(key, nil);
    
#if DEBUG_Not_Found_CN_Lan_Key
    // 开发时用于查看缺失语言包时，可打开此段注释
    if ([value isEqualToString:key]) {
        NSLog(@"MISS-LANGUAGE: %@", key);
    }
#endif
    
    return value;
}

//屏幕分辨率
+ (NSString *)screenResolution {
    CGSize size_screen = [[UIScreen mainScreen]bounds].size;
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    NSString *width = [NSString stringWithFormat:@"%f",size_screen.width*scale_screen];
    NSString *height  = [NSString stringWithFormat:@"%f",size_screen.height*scale_screen];
    NSString *resolution = [NSString stringWithFormat:@"%d*%d",[width intValue],[height intValue]];
    
    return resolution;
}

/** 获取app的描述 **/
+(NSString *)sb_description {
    NSMutableString *dc = [[NSMutableString alloc] initWithCapacity:1000];
    
    SBAppCoreInfo *info = [SBAppCoreInfo sharedSBAppCoreInfo];
    
    NSString *networkType = SBGetNetworkReachabilityDescribe();
    
    [dc appendFormat:@"网络状态  =  %@\n", networkType];
    [dc appendFormat:@"应用名  =  %@\n", info.appDisplayName];
    [dc appendFormat:@"应用版本号  =  %@\n", info.appVersionName];
    [dc appendFormat:@"编译版本号  =  %@\n", info.appBuildVersion];
    [dc appendFormat:@"工程名  =  %@\n", info.appProductName];
    [dc appendFormat:@"客户端名称  =  %@\n", info.appClientName];
    [dc appendFormat:@"系统浮点型版本号=%f\n", info.systemVersionCode];
    [dc appendFormat:@"iPhone的MAC地址  =  %@\n", info.mac];
    [dc appendFormat:@"设备的idfa  =  %@\n", info.idfaString];
    [dc appendFormat:@"设备的idfv  =  %@\n", info.idfvString];
    [dc appendFormat:@"设备的keychainId  =  %@\n", info.keychainIdString];
    [dc appendFormat:@"本地设备的操作系统及版本  =  %@\n", info.clientOS];
    [dc appendFormat:@"设备的类型  =  %@\n", info.clientMachine];
    [dc appendFormat:@"电话运营商  =  %@\n", [SBAppCoreInfo telephonyNetworkInfo]];
    [dc appendFormat:@"屏幕参数  =  %@\n", [SBAppCoreInfo screenResolution]];
    [dc appendFormat:@"是否越狱  =  %@\n", info.isJailBreak ? @"是" : @"否"];
    [dc appendFormat:@"应用的推送token  =  %@\n", info.deviceToken];

    return dc;
}

@end
