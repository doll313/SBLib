
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
#import "SBNetworkReachability.h"
#import "SBAppCoreInfo.h"
#import "SBExceptionLog.h"      //异常记录

static BOOL _url_print_debug;             //调试url输出
static BOOL _recieve_data_ram_debug;             //调试接收数据大小
static NSString *_protocolName;             //调试url输出

@interface SBHttpTask ()

@property (nonatomic, copy) NSString *HTTPMethod;

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
}

- (void)start {
    if (self.isCancelled) {
        self.sbHttpTaskState = SBHttpTaskStateFinished;
        return;
    }
    //开启网络
    [self doStartRequest];
    
    self.sbHttpTaskState = SBHttpTaskStateExecuting;
}

- (void)doStartRequest {

    [SBHttpHelper showNetworkIndicator];


    void (^startBlock)() = ^void(){
        //开始请求
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(taskWillStart:)]) {
            [self.delegate taskWillStart:self];
        }

        self.startDate = [NSDate date];

        //request
        NSURL *aURL = nil;
        if ([self.HTTPMethod isEqualToString:@"POST"]) {
            [self doPost];
        } else {
            [self doGet];
        }

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

/** agent **/
- (NSString *)userAgent {
    /** 设定用户代理名 */
    NSString *deviceType = [SBAppCoreInfo sharedSBAppCoreInfo].clientMachine;
    NSString *uuid = [SBAppCoreInfo sharedSBAppCoreInfo].idfv;
    NSString *userAgent = [NSString stringWithFormat:@"%@-%@-%@", APPCONFIG_CONN_USER_AGENT, deviceType, uuid];

    return userAgent;
}

- (NSURLSession *)session {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    if (_protocolName.length > 0) {
        NSArray *protocolArray = @[NSClassFromString(_protocolName)];
        config.protocolClasses = protocolArray;
    }
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    return session;
}

- (void)doPost {
    NSString *domainURL = [self.aURLString sb_httpGetMethodDomain];
    NSURL *aURL = [NSURL URLWithString:domainURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aURL
                                              cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                          timeoutInterval:self.timeout];

    /** 如果post数据为空，则用GET方式提交数据 */
    [request setHTTPMethod:@"POST"];

    //json
    if (self.jsonDict) {
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];  //设置请求头
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];        //设置请求头

        NSError *error;
        self.postData = [NSJSONSerialization dataWithJSONObject:self.jsonDict options:0 error:&error];

    } else {
        NSString *paramURL = [self.aURLString sb_httpGetMethodParamsString];
        self.postData = [paramURL dataUsingEncoding:NSUTF8StringEncoding];
        self.jsonDict = [[self.aURLString sb_httpGetMethodParams] mutableCopy];
    }

    [request setHTTPBody:self.postData];

    /** 不支持cookies */
    [request setHTTPShouldHandleCookies:NO];

    [request setValue:[self userAgent] forHTTPHeaderField:@"User-Agent"];

    //header参数
    for (NSString *filedkey in self.aHTTPHeaderField) {
        [request addValue:self.aHTTPHeaderField[filedkey] forHTTPHeaderField:filedkey];
    }

    //gzip
    if (self.gzip) {
        [request addValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    }

    NSURLSession *session = [self session];
    self.sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self doResponse:data error:error];
    }];

    [self.sessionDataTask resume];


//    // 请求的manager
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; // AFN不会解析,数据是data，需要自己解析
//
//    //网络请求返回
//    self.sessionDataTask =[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        [self doResponse:responseObject error:error];
//    }];
//
//    [self.sessionDataTask resume];

}

- (void)doGet {
    NSURL *aURL = [NSURL URLWithString:self.aURLString];
    //使用get方法传入code有xxx|xxx这种带“|”的会使url初始化失败。
    if (aURL == nil) {
        NSString *newUrlString = [self.aURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        aURL = [NSURL URLWithString:newUrlString];
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aURL
                                              cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                          timeoutInterval:self.timeout];

    /** 如果post数据为空，则用GET方式提交数据 */
    [request setHTTPMethod:@"GET"];

    NSString *paramURL = [self.aURLString sb_httpGetMethodParamsString];
    self.jsonDict = [[paramURL sb_httpGetMethodParams] mutableCopy];

    /** 不支持cookies */
    [request setHTTPShouldHandleCookies:NO];

    [request setValue:[self userAgent] forHTTPHeaderField:@"User-Agent"];

    //header参数
    for (NSString *filedkey in self.aHTTPHeaderField) {
        [request addValue:self.aHTTPHeaderField[filedkey] forHTTPHeaderField:filedkey];
    }

    //gzip
    if (self.gzip) {
        [request addValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    }

    NSURLSession *session = [self session];
    self.sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self doResponse:data error:error];
    }];

    [self.sessionDataTask resume];
}

//接收到数据
- (void)doResponse:(id  _Nullable)responseObject error:(NSError * _Nonnull)error {
    //状态码
    self.statusCode = ((NSHTTPURLResponse *)self.sessionDataTask.response).statusCode;
    //赋值数据
    [self.recieveData appendData:responseObject];
    //完成
    [self onFinished:error];
}

- (void)cancel {
    if (self.isFinished) {
        return;
    }

    self.endDate = [NSDate date];
    self.durationTime = [self.endDate timeIntervalSinceDate:self.startDate];

    self.delegate = nil;
    [self.sessionDataTask cancel];

    [super cancel];
}

#pragma mark -
#pragma mark 网络方法
//终止数据加载
- (void)stopLoading {
    //停转子
    [SBHttpHelper hiddenNetworkIndicator];

    //停止网络请求
    [self.sessionDataTask cancel];

    //这步很重要 调试了n久
    if(self.sbHttpTaskState == SBHttpTaskStateExecuting) {
        self.sbHttpTaskState = SBHttpTaskStateFinished;
    }

    [self cancel];
}


//请求结束时调用的事件，只调用一次
- (void)onFinished:(NSError *)error {
    
    [SBHttpHelper hiddenNetworkIndicator];

    void (^finishBlock)() = ^void(){
        self.endDate = [NSDate date];
        self.durationTime = [self.endDate timeIntervalSinceDate:self.startDate];
        
        //错误
        self.httpError = error;
        
        if(nil != self.delegate){
            if (nil != error) {
                //出错的回调
                [self.delegate task:self onError:error];
            } else {
                //正确接收数据的回调
                [self.delegate task:self onReceived:self.recieveData];
            }
        }
        
        //打印接收字节
        _recieve_data_ram_debug = [[NSUserDefaults standardUserDefaults] boolForKey:DEBUG_HTTP_RECIEVE_RAM];
        if (_recieve_data_ram_debug) {
            NSLog(@"接收到的数据大小:%fk", self.recieveData.length / 1024.0f);
        }

        //状态修改
        self.sbHttpTaskState = SBHttpTaskStateFinished;
    };
    
    if ([NSThread currentThread] != [NSThread mainThread]) {
        dispatch_sync(dispatch_get_main_queue(), finishBlock);
    }else{
        finishBlock();
    }
}

/** URL协议 */
+ (void)protocolName:(NSString *)name {
    _protocolName = name;
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


@end
