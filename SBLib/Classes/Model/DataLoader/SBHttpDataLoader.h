/*
#####################################################################
# File    : SBHttpDataLoader.h
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

#import "DataItemResult.h"
#import "SBHttpTask.h"
#import "SBHttpDataParser.h"

NS_ASSUME_NONNULL_BEGIN

//表示列表数据的状态
typedef NS_ENUM(NSInteger, SBTableDataStatus) {
    SBTableDataStatusNotStart,
    SBTableDataStatusLoading,
    SBTableDataStatusFinished
} ;

@class SBHttpDataLoader;

/**
 *  该协议用于约束响应 SBHttpDataLoader 事件的类，确保其拥有 onReceived 方法。
 */
@protocol SBHttpDataLoaderDelegate <NSObject>
@required

/** onReceived方法：在数据装载器装载数据结束后调用的方法 */
- (void)dataLoader:(SBHttpDataLoader * _Nonnull)dataLoader onReceived:(DataItemResult * _Nonnull)result;

@end

/**
 *   1.该类用于请求接口内容并解析。
 *   2.该类会对内容进行预处理，处理的结果会放到一个 DataItemResult 结构中。
 *   3.初始化成功后，会自动retain一次；
 *   4.当加载数据完成、加载出错或调用stopLoading函数后，会自动autorelease一次。
 */
@interface SBHttpDataLoader : NSOperation <SBHttpTaskDelegate, NSCoding> {
@private
    BOOL hasFinishedLoad;              //确保自动释放一次的标志位
}


@property (nonatomic, strong, nullable) SBHttpTask *httpTask;         //网络加载
@property (nonatomic, strong) DataItemResult *dataItemResult; //解析的数据放入数据容器中
@property (nonatomic, assign) id<SBHttpDataLoaderDelegate> delegate;   //解析回调

/** 用来识别这个SBHttpDataLoader */
@property (nonatomic, copy) NSString *identifier;

/** 初始化GET方式请求的网络数据 */
- (id)initWithURL:(NSString *)URL delegate:(nullable id<SBHttpDataLoaderDelegate>)target;

/** 初始化网络数据 GET POST UPLOAD*/
- (id)initWithURL:(NSString *)URL httpMethod:(NSString *)httpMethod delegate:(nullable id<SBHttpDataLoaderDelegate>)target;

/** 初始化Request方式请求的网络数据 */
- (id)initWithURLRequest:(NSMutableURLRequest *)request delegate:(nullable id<SBHttpDataLoaderDelegate>)target;

//初始化网络数据,带额外设置
- (id)initWithURL:(NSString *)URL httpMethod:(NSString *)httpMethod delegate:(id<SBHttpDataLoaderDelegate>)target settingBlock:(void(^)(SBHttpTask *sbHttpTask))settingBlock;


/** 获取本地解析好的数据 */
- (DataItemResult *)getDataItemResult;

/** 停止加载和解析数据，停止事件响应 */
- (void)stopLoading;

//数据装载事件完成后调用的函数，自动释放一次
- (void)onFinished;


////// block 回调 /////

/** 回调 结果 */
@property (nonatomic, copy) void (^onReceived)(SBHttpDataLoader *loader, DataItemResult *result);

/** 回调 请求即将开始 */
@property (nonatomic, copy) void (^willStart)(SBHttpDataLoader *loader);

/** 回调 已经上传字节 */
@property (nonatomic, copy) void (^onUpload)(SBHttpDataLoader *loader, NSProgress *uploadProgress);

/** 回调 已经下载字节 */
@property (nonatomic, copy) void (^onDownload)(SBHttpDataLoader *loader, NSProgress *downloadProgress);

/** 下载的返回地址 如果是下载请求  必须实现该回调 */
@property (nonatomic, copy) NSURL *(^destination)(NSURL *targetPath, NSURLResponse *response);


NS_ASSUME_NONNULL_END

@end
