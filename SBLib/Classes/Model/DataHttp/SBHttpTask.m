
/*
 #####################################################################
 # File    : SBHttpTask.m
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

#import "SBHttpTask.h"
#import "SBHttpHelper.h"
#import "SBAppCoreInfo.h"
#import "DataAppCacheDB.h"
#import "SBExceptionLog.h"      //异常记录
#import "SBNetworkReachability.h"
#import <netdb.h>
#import <arpa/inet.h>

static BOOL _url_print_debug;             //调试url输出
static BOOL _recieve_data_ram_debug;             //调试接收数据大小

@interface SBHttpTask ()

@property (nonatomic, copy) NSString *HTTPMethod;
@property (nonatomic, copy) NSDate *startDate;

@end

@implementation SBHttpTask

#pragma mark -
#pragma mark 生命周期

/** 初始化一个HTTP请求 */
- (id)initWithURLString:(NSString *)aURLString
             httpMethod:(NSString *)method
               delegate:(id<SBHttpTaskDelegate>)delegate {
    self = [super init];
    
    self.sbHttpTaskState = SBHttpTaskStateReady;
    
    self.aURLString = aURLString;
    self.HTTPMethod = method;
    self.delegate = delegate;
    
    self.gzip = YES;
    
    self.timeout = APPCONFIG_CONN_TIMEOUT;

    self.recieveData = [[NSMutableData alloc] initWithCapacity:0];
    
    //进入queue
    NSOperationQueue *queue = [SBAppCoreInfo getCoreQueue];
    [queue addOperation:self];
    
    return self;
}

//释放资源
- (void)dealloc {
    [self stopLoading];
    self.urlRequest = nil;
}

- (void)start {
    if (self.isCancelled) {
        self.sbHttpTaskState = SBHttpTaskStateFinished;
        return;
    }
    
    [SBHttpHelper showNetworkIndicator];
    
    //开启网络
    [self doStartRequest];
    
    self.sbHttpTaskState = SBHttpTaskStateExecuting;
}

- (void)doStartRequest {
    
    void (^startBlock)() = ^void(){
        //请求时间
        self.startDate = [NSDate date];
        
        //request
        NSURL *aURL = nil;
        if ([self.HTTPMethod isEqualToString:@"POST"]) {
            NSString *domainURL = [self.aURLString sb_httpGetMethodDomain];
            aURL = [NSURL URLWithString:domainURL];
        } else {
            aURL = [NSURL URLWithString:self.aURLString];
            //使用get方法传入code有xxx|xxx这种带“|”的会使url初始化失败。
            if (aURL == nil) {
                NSString *newUrlString = [self.aURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                aURL = [NSURL URLWithString:newUrlString];
            }
        }
        
        self.urlRequest = [NSMutableURLRequest requestWithURL:aURL
                                                  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                              timeoutInterval:self.timeout];
        
        /** 如果post数据为空，则用GET方式提交数据 */
        [self.urlRequest setHTTPMethod:self.HTTPMethod];
        
        //POST 加入POST数据
        if ([self.HTTPMethod isEqualToString:@"POST"]) {
            //json
            if (self.jsonDict) {
                [self.urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];  //设置请求头
                [self.urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];        //设置请求头
                
                NSError *error;
                self.postData = [NSJSONSerialization dataWithJSONObject:self.jsonDict options:0 error:&error];
                
            } else {
                NSString *paramURL = [self.aURLString sb_httpGetMethodParamsString];
                self.postData = [paramURL dataUsingEncoding:NSUTF8StringEncoding];
                self.jsonDict = [[self.aURLString sb_httpGetMethodParams] mutableCopy];
            }
            
            [self.urlRequest setHTTPBody:self.postData];
        }else{
            NSString *paramURL = [self.aURLString sb_httpGetMethodParamsString];
            self.jsonDict = [[paramURL sb_httpGetMethodParams] mutableCopy];
        }
        
        /** 不支持cookies */
        [self.urlRequest setHTTPShouldHandleCookies:NO];
        
        /** 设定用户代理名 */
        NSString *deviceType = [SBAppCoreInfo sharedSBAppCoreInfo].clientMachine;
        NSString *uuid = [SBAppCoreInfo sharedSBAppCoreInfo].idfv;
        NSString *userAgent = [NSString stringWithFormat:@"%@-%@-%@", APPCONFIG_CONN_USER_AGENT, deviceType, uuid];
        [self.urlRequest setValue:userAgent forHTTPHeaderField:@"User-Agent"];
        
        //header参数
        for (NSString *filedkey in self.aHTTPHeaderField) {
            [self.urlRequest addValue:self.aHTTPHeaderField[filedkey] forHTTPHeaderField:filedkey];
        }
        
        //gzip
        if (self.gzip) {
            [self.urlRequest addValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        }
        
        //
        self.sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.urlSession = [NSURLSession sessionWithConfiguration:self.sessionConfiguration];
        self.sessionDataTask = [self.urlSession dataTaskWithRequest:self.urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            //网络请求返回
            self.urlResponse = response;
            //状态码
            self.statusCode = ((NSHTTPURLResponse *)response).statusCode;
            //错误
            self.httpError = error;
            //赋值数据
            [self.recieveData appendData:data];
            //请求时间
            self.durationTime = [[NSDate date] timeIntervalSinceDate:self.startDate];
            //完成
            [self onFinished:error];
            //状态修改
            self.sbHttpTaskState = SBHttpTaskStateFinished;
        }];
        
        //开始请求
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(taskWillStart:)]) {
            [self.delegate taskWillStart:self];
        }
        
        [self.sessionDataTask resume];
        
        //打印网址
        _url_print_debug = [[NSUserDefaults standardUserDefaults] boolForKey:DEBUG_HTTP_REQUEST_URL_PRINT];
        if (_url_print_debug) {
            NSLog(@"URL: %@", self.aURLString);
        }
    };
    
    //确保在主线程
    if ([NSThread currentThread] != [NSThread mainThread]) {
        dispatch_sync(dispatch_get_main_queue(), startBlock);
    }else{
        startBlock();
    }
}

- (void)cancel {
    if (self.isFinished) {
        return;
    }
    
    self.delegate = nil;
    [self.sessionDataTask cancel];
    
    [super cancel];
}

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isReady {
    return (_sbHttpTaskState == SBHttpTaskStateReady && [super isReady]);
}

- (BOOL)isFinished {
    return (_sbHttpTaskState == SBHttpTaskStateFinished);
}

- (BOOL)isExecuting {
    return (_sbHttpTaskState == SBHttpTaskStateExecuting);
}

//设置状态
- (void)setSbHttpTaskState:(SBHttpTaskState)networkOperationState {
    @synchronized(self){
        //        NSLog(@"%@ state:%d",self, networkOperationState);
        switch (networkOperationState) {
            case SBHttpTaskStateReady:
                [self willChangeValueForKey:@"isReady"];
                break;
            case SBHttpTaskStateExecuting:
                [self willChangeValueForKey:@"isReady"];
                [self willChangeValueForKey:@"isExecuting"];
                break;
            case SBHttpTaskStateFinished:
                [self willChangeValueForKey:@"isExecuting"];
                [self willChangeValueForKey:@"isFinished"];
                break;
        }
        
        _sbHttpTaskState = networkOperationState;
        
        switch (networkOperationState) {
            case SBHttpTaskStateReady:
                [self didChangeValueForKey:@"isReady"];
                break;
            case SBHttpTaskStateExecuting:
                [self didChangeValueForKey:@"isReady"];
                [self didChangeValueForKey:@"isExecuting"];
                break;
            case SBHttpTaskStateFinished:
                [self didChangeValueForKey:@"isExecuting"];
                [self didChangeValueForKey:@"isFinished"];
                break;
        }
    }
}

#pragma mark -
#pragma mark 网络方法
//终止数据加载
- (void)stopLoading {
    [self onFinished:nil];
    
    //这步很重要 调试了n久
    if(self.sbHttpTaskState == SBHttpTaskStateExecuting) {
        self.sbHttpTaskState = SBHttpTaskStateFinished;
    }
}


//请求结束时调用的事件，只调用一次
- (void)onFinished:(NSError *)error {
    
    [SBHttpHelper hiddenNetworkIndicator];
    
    if (self.completed) {
        return;
    }
    
    void (^finishBlock)() = ^void(){
        self.completed = YES;
        
        //记录
        NSMutableString *dc = [[NSMutableString alloc] initWithCapacity:1000];
        [dc appendFormat:@"网络请求=%@\n\n", self.urlRequest];
        [dc appendFormat:@"请求时间=%f\n\n", self.durationTime];
        [dc appendFormat:@"请求参数=%@\n\n", self.jsonDict];
        [dc appendFormat:@"请求地址=%@\n\n", self.aURLString];
        [dc appendFormat:@"收到的数据=%@\n\n", [[NSString alloc] initWithData:self.recieveData encoding:NSUTF8StringEncoding]];
        
        [SBExceptionLog record:dc key:SBKEY_RECORD_HTTP];
        
        //错误
        self.httpError = error;
        
        if(nil != self.delegate){
            if (nil != error) {
                //出错的回调
                [self.delegate task:self onError:error];
                
                //记录错误日志
                [SBExceptionLog logSBHttpException:self];
                
            } else {
                //正确接收数据的回调
                [self.delegate task:self onReceived:self.recieveData];
            }
        }
        
        [self cancel];
        
        //打印接收字节
        _recieve_data_ram_debug = [[NSUserDefaults standardUserDefaults] boolForKey:DEBUG_HTTP_RECIEVE_RAM];
        if (_recieve_data_ram_debug) {
            NSLog(@"接收到的数据大小:%fk", self.recieveData.length / 1024.0f);
        }
    };
    
    if ([NSThread currentThread] != [NSThread mainThread]) {
        dispatch_sync(dispatch_get_main_queue(), finishBlock);
    }else{
        finishBlock();
    }
}

#pragma mark -
#pragma mark 私有方法
//设置 HTTP 请求头报错时的错误信息
- (void)onHttpStatusCodeError:(NSString *)errorDomain {
    if (SBStringIsEmpty(errorDomain)) {
        errorDomain = [SBHttpHelper httpStatusErrorStr:self.statusCode];
    }
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    userInfo[APPCONFIG_CONN_ERROR_MSG_DOMAIN] = errorDomain;
    
    NSError *statusError = [NSError errorWithDomain:APPCONFIG_CONN_ERROR_MSG_DOMAIN code:self.statusCode userInfo:userInfo];
    [self onFinished:statusError];
}

/** 网络任务描述 */
- (NSString *)sbHttpDescribe {
    @try {
        
        NSMutableString *dc = [[NSMutableString alloc] initWithCapacity:1000];
        
        NSString *networkType = SBGetNetworkReachabilityDescribe();
        
        [dc appendFormat:@"触发时间=%@\n\n", [NSDate date]];
        [dc appendFormat:@"请求时间=%f\n\n", self.durationTime];
        [dc appendFormat:@"网络请求=%@\n\n", self.urlRequest];
        [dc appendFormat:@"网络接收=%@\n\n", self.urlResponse];
        [dc appendFormat:@"网络状态=%@\n\n", networkType];
        [dc appendFormat:@"接收到的网络数据=%@\n\n", [[NSString alloc] initWithData:self.recieveData encoding:NSUTF8StringEncoding]];
        [dc appendFormat:@"是否压缩数据=%@\n\n", self.gzip ? @"是" : @"否"];
        [dc appendFormat:@"是否加载完毕=%@\n\n", self.completed ? @"是" : @"否"];
        [dc appendFormat:@"错误信息=%@\n\n", [self.httpError description]];
        [dc appendFormat:@"网络请求错误解释=%@\n\n", [SBHttpHelper httpStatusErrorStr:self.statusCode]];
        [dc appendFormat:@"超时时间=%f\n\n", self.timeout];
        
        [dc appendFormat:@"\r\n\r\n--------------------------------\r\n\r\n"];
        [dc appendFormat:@"\r\n\r\n--------------------------------\r\n\r\n"];
        
        return dc;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
@end
