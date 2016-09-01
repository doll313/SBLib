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
    if (log.length == 0 || ![log isKindOfClass:[NSString class]]) {
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

/**
 * 记录股吧的接口错误日志
 */
+ (void)logSBHttpException:(SBHttpTask *)httpTask {
    //没有网络这种情况，不算需要记录下来的异常
    if (SBGetNetworkReachability() == SBNetworkReachabilityNone) {
        return;
    }
    
    //本地财付通记录保留
    NSLog(@"网络请求错误 HTTP错误；错误码：%ld \r\n请求地址：%@ \r\n请求参数：%@\r\n", (long)httpTask.statusCode, httpTask.aURLString, httpTask.jsonDict);
    
    //数据库
    DataAppCoreDB *coreDB = [SBAppCoreInfo getCoreDB];
    //获取旧的未发送成功的异常
    NSString *oldExcetionReport = [SBExceptionLog getSBHttpException];
    
    //异常报告
    NSMutableString *exceptionReport = [NSMutableString stringWithString: [httpTask sbHttpDescribe]];
    
    /** 若旧的 SB Exception 报告不为空，则把旧的 SB Exception 报告追加到新的 SB Exception 报告后面，用短杆线隔开 **/
    if(oldExcetionReport.length > 0){
        // 如果 SB Exception 日志超过512k，则丢弃
        if([oldExcetionReport lengthOfBytesUsingEncoding:NSUTF8StringEncoding] > 512 * 1024){
            oldExcetionReport = [NSMutableString stringWithString:@""];
        }
        
        [exceptionReport appendString:@"\r\n----- ----- ----- ----- ----- ----- -----\r\n"];
        [exceptionReport appendString:oldExcetionReport];
    }
    
    //存入数据库
    [coreDB setStrValue:STORE_EXCEPTION_INFO dataKey:SBHttpRequestExceptionCacheKey dataValue:exceptionReport];
}

/** 记录股吧的崩溃日志 */
+ (void)logSBCrashException:(NSException *)exception {
    //存入数据库
    DataAppCoreDB *coreDB = [SBAppCoreInfo getCoreDB];
    
    //异常报告
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *now = [NSDate date];
    NSString *crashTime = [df stringFromDate:now];
    
    NSString *operations = [SBExceptionLog getRecord:SBKEY_RECORD_OPERATION];
    
    NSMutableString *exceptionReport = [NSMutableString stringWithString:exception.description];
    [exceptionReport appendString:@"\r\n崩溃时间:\r\n"];
    [exceptionReport appendString:crashTime];
    [exceptionReport appendString:@"\r\n用户行为:\r\n"];
    [exceptionReport appendString:operations];
    
    [coreDB setStrValue:STORE_EXCEPTION_INFO dataKey:SBUncaughtExceptionCacheKey dataValue:exceptionReport];
    
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
