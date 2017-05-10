
/*
 #####################################################################
 # File    : SBHttpTask.h
 # Project :
 # Created : 2013-03-30
 # DevTeam : Thomas Develop
 # Author  :
 # Notes   :
 #####################################################################
 ### Change Logs   ###################################################
 #####################################################################
 ---------------------------------------------------------------------
 # Date  : 2016-1-8
 # Author: thomas
 # Notes : 改成nsurlsession   ios7
 #
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

#import <Foundation/Foundation.h>
#import <Foundation/NSObject.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SBHttpTaskState) {
    SBHttpTaskStateReady = 1,               //开始
    SBHttpTaskStateExecuting = 2,           //执行中
    SBHttpTaskStateFinished = 3             //结束
};

// 网络连接用到的常量
#define APPCONFIG_CONN_ADD_PREFIX           @"/"                    // WAP 接口前缀 东方财富网没有专门为客户端的接口前缀
#define APPCONFIG_CONN_USER_AGENT           @"app-iphone-client"      // 连接WAP接口的客户端声明
#define APPCONFIG_CONN_TIMEOUT              30                          // 连接超时时间
#define APPCONFIG_CONN_URL_CACHE              (60*60*24*7)                          // 缓存失效时间

@class SBHttpTask;

//该协议用于约束响应 SBHttpTask 事件的类，确保其拥有 onError 和 onReceived 两个方法。
@protocol SBHttpTaskDelegate <NSObject>

@required

/** onError 方法，在 SBHttpTask 请求出错时回调的方法 */
- (void)task:(SBHttpTask *)task onError:(NSError *)error;

/** onReceived 方法，在 SBHttpTask 数据加载完成后回调的方法 */
- (void)task:(SBHttpTask *)task onReceived:(NSData *)data;

@end

/**
 *   1.该类用于响应网络请求。
 *   2.该类会封装超时时间，用户代理和处理请求异常。
 */
@interface SBHttpTask : NSOperation <NSCoding>


////// 以下参数可以设置

/** url为最基本的参数，需指定 */
@property (nonatomic, strong) NSString *aURLString;

/** http header 参数 */
@property (nonatomic, strong) NSDictionary *aHTTPHeaderField;

/** json方式传参  */
@property (nonatomic, strong) NSMutableDictionary *jsonDict;

/** request  */
@property (nonatomic, strong) NSURLRequest *aURLrequest;

/** 上传的文件数据 */
@property (nonatomic, strong, nullable) NSData *fileData;

/** 下载的文件地址 */
@property (nonatomic, strong, nullable) NSURL *filePath;

/** 标签，用以区分同一个delegate的不同task */
@property (nonatomic, assign) NSInteger tag;

/** 附带的用户信息 */
@property (nonatomic, strong, nullable) id userInfo;

/** 代理 */
@property (nonatomic, assign, nullable) id<SBHttpTaskDelegate> delegate;

/** 数据压缩  */
@property (nonatomic, assign) BOOL gzip;

////// 以下参数读取 不要设置

/** 网络*/
@property (nonatomic, strong) NSURLSessionTask *sessionDataTask;

/** 接收到的网络数据 */
@property (nonatomic, strong) NSMutableData *recieveData;

/** 网络请求状态码 */
@property (nonatomic, assign) NSInteger statusCode;

/** 错误信息 */
@property (strong, nonatomic) NSError *httpError;

/** post请求的post数据 */
@property (nonatomic, strong) NSData *postData;

/** 超时时间，默认为xx秒 */
@property (nonatomic, assign) NSTimeInterval timeout;

/** 开始时间 */
@property (nonatomic, strong) NSDate *startDate;

/** 结束时间 */
@property (nonatomic, strong) NSDate *endDate;

/** 执行时间 */
@property (nonatomic, assign) NSTimeInterval durationTime;

/** 网络操作状态 */
@property (nonatomic, assign) SBHttpTaskState sbHttpTaskState;

////// block 回调 /////

/** 回调 结果 */
@property (nonatomic, copy) void (^onReceived)(SBHttpTask *task, NSData *data, NSError *error);

/** 回调 请求即将开始 */
@property (nonatomic, copy) void (^willStart)(SBHttpTask *task);

/** 回调 已经上传字节 */
@property (nonatomic, copy) void (^onUpload)(SBHttpTask *task, NSProgress *uploadProgress);

/** 回调 已经下载字节 */
@property (nonatomic, copy) void (^onDownload)(SBHttpTask *task, NSProgress *downloadProgress);

/** 下载的返回地址 如果是下载请求  必须实现该回调 */
@property (nonatomic, copy) NSURL *(^destination)(NSURL *targetPath, NSURLResponse *response);


////// 调用方法 /////

/** 初始化一个HTTP请求 通过参数去拼 */
- (id)initWithURLString:(nonnull NSString *)aURLString
             httpMethod:(nonnull NSString *)method
               delegate:(nullable id<SBHttpTaskDelegate>)delegate;

/** 初始化一个HTTP请求 直接用 request  */
- (id)initWithRequest:(nonnull NSMutableURLRequest *)request
               delegate:(nullable id<SBHttpTaskDelegate>)delegate;

/** 终止数据加载 */
- (void)stopLoading;

/** 网络请求使用到的 session， 是个静态地址  **/
+ (AFHTTPSessionManager *)sessionManager;

NS_ASSUME_NONNULL_END

@end
