/*
 #####################################################################
 # File    : SBExceptionLog.m
 # Project : GubaModule
 # Created : 14/12/29
 # DevTeam : eastmoney
 # Author  : Thomas
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

#import "SBExceptionLog.h"          //日志系统
#import "SBHttpTask.h"
#import "SBHttpDataLoader.h"
#import "SBNetworkReachability.h"
#import "SBAppCoreInfo.h"
#import "NSDictionary+SBMODULE.h"

NSString * const SBHttpRequestExceptionCacheKey = @"SBHttpRequestExceptionCacheKey";    // 存放http请求异常记录
NSString * const SBUncaughtExceptionCacheKey = @"SBUncaughtExceptionCacheKey";
NSUInteger const kOperationStackMaxCount = 50;

@interface SBExceptionLog()

@end

@implementation SBExceptionLog

SB_ARC_SINGLETON_IMPLEMENT(SBExceptionLog);

- (id)init {
    self = [super init];
    if (self) {
        AppCreateTime = [[NSDate alloc] init];
        recordStack = [[NSMutableDictionary alloc] init];
        
        //记录app事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveMemoryWarningNotification) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminateNotification) name:UIApplicationWillTerminateNotification object:nil];
    }
    return self;
}

- (void)dealloc {
}

- (void)applicationWillEnterForegroundNotification {
    [SBExceptionLog record:@"UIApplicationWillEnterForegroundNotification" key:SBKEY_RECORD_OPERATION];
}

- (void)applicationDidEnterBackground {
    [SBExceptionLog record:@"UIApplicationDidEnterBackgroundNotification" key:SBKEY_RECORD_OPERATION];
}

- (void)applicationDidBecomeActiveNotification {
    [SBExceptionLog record:@"UIApplicationDidBecomeActiveNotification" key:SBKEY_RECORD_OPERATION];
}

- (void)applicationWillResignActiveNotification {
    [SBExceptionLog record:@"UIApplicationWillResignActiveNotification" key:SBKEY_RECORD_OPERATION];
}

- (void)applicationDidReceiveMemoryWarningNotification {
    [SBExceptionLog record:@"UIApplicationDidReceiveMemoryWarningNotification" key:SBKEY_RECORD_OPERATION];
}

- (void)applicationWillTerminateNotification {
    [SBExceptionLog record:@"UIApplicationWillTerminateNotification" key:SBKEY_RECORD_OPERATION];
}
/** 记录 */
+ (void)record:(NSString *)log key:(NSString *)key {
    [[SBExceptionLog sharedSBExceptionLog] record:log key:key];
}

/** 记录 */
- (void)record:(NSString *)log key:(NSString *)key {
    if (SBStringIsEmpty(log) || ![log isKindOfClass:[NSString class]]) {
        return;
    }
    
    NSMutableArray *stack = recordStack[key];
    if (!stack) {
        stack = [NSMutableArray new];
        recordStack[key] = stack;
    }
    
    @synchronized(stack) {
        while (stack.count>=kOperationStackMaxCount) {
            [stack removeLastObject];
        }
        
        NSDate *date = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: date];
        NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
        
        NSDictionary *stackInfo = @{@"time":localeDate, @"log":log};
        [stack insertObject:stackInfo atIndex:0];
    }
}


/** 获取记录 */
+ (NSArray *)getRecordList:(NSString *)key {
    return [[SBExceptionLog sharedSBExceptionLog] getRecordList:key];
}

/** 获取记录 */
- (NSArray *)getRecordList:(NSString *)key {
    NSMutableArray *stack = recordStack[key];
    if (!stack) {
        return @[];
    }
    
    return stack;
}

/** 获取记录 */
+ (NSString *)getRecord:(NSString *)key {
    return [[SBExceptionLog sharedSBExceptionLog] getRecord:key];
}

/** 获取记录 */
- (NSString *)getRecord:(NSString *)key {
    NSMutableArray *stack = recordStack[key];
    if (!stack) {
        return @"";
    }
    NSString *ss = @"";
    for (NSDictionary *stackInfo in stack) {
        ss = [ss stringByAppendingString:[NSString stringWithFormat:@"%@", stackInfo[@"time"]]];
        ss = [ss stringByAppendingString:@"\r\n"];
        ss = [ss stringByAppendingString:stackInfo[@"log"]];
        ss = [ss stringByAppendingString:@"\n========================\n"];
        
    }
    return ss;
}

/** * 获取股吧的接口错误日志 */
+ (NSString *)getSBHttpException {
    //获取旧的未发送成功的异常
    NSString *oldExcetionReport = [[SBAppCoreInfo getCoreDB] getStrValue:STORE_EXCEPTION_INFO dataKey:SBHttpRequestExceptionCacheKey];
    return oldExcetionReport;
}


/** * 获取应用崩溃日志 */
+ (NSString *)getSBCrashException {
    //获取旧的未发送成功的异常
    NSString *oldExcetionReport = [[SBAppCoreInfo getCoreDB] getStrValue:STORE_EXCEPTION_INFO dataKey:SBUncaughtExceptionCacheKey];
    return oldExcetionReport;
}


@end
