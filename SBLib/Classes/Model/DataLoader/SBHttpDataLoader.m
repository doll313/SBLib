/*
#####################################################################
# File    : SBHttpDataLoader.m
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

#import "SBHttpDataLoader.h"

@implementation SBHttpDataLoader

#pragma mark -
#pragma mark 生命周期

//初始化GET方式请求的网络数据
- (id)initWithURL:(NSString *)URL delegate:(nullable id<SBHttpDataLoaderDelegate>)target {
	return [self initWithURL:URL httpMethod:@"GET" delegate:target];
}

//初始化网络数据
- (id)initWithURL:(NSString *)URL httpMethod:(NSString *)httpMethod delegate:(nullable id<SBHttpDataLoaderDelegate>)target{
	self = [super init];

    self.dataItemResult = [[DataItemResult alloc] init];
    self.delegate = target;
    self.httpTask = [[SBHttpTask alloc] initWithURLString:URL httpMethod:httpMethod delegate:self];

    [self taskBlock];

	return self;
}

/** 初始化Request方式请求的网络数据 */
- (id)initWithURLRequest:(NSMutableURLRequest *)request delegate:(nullable id<SBHttpDataLoaderDelegate>)target {

    self = [super init];

    if(nil != self){
        self.dataItemResult = [[DataItemResult alloc] init];
        self.delegate = target;
        self.httpTask = [[SBHttpTask alloc] initWithRequest:request delegate:self];

        [self taskBlock];
    }

    return self;
}

- (void)taskBlock {
    SBWS(__self);

    //接收数据
    self.httpTask.onReceived = ^(SBHttpTask * _Nonnull task, NSData * _Nonnull data, NSError * _Nonnull error) {
        if (error) {
            __self.dataItemResult.hasError = YES;
            __self.dataItemResult.message = @"网络貌似不给力，请重新加载";
        }
        else {
            __self.dataItemResult = [SBHttpDataParser parseData:data task:task];
        }
        [__self onFinished];
    };

    //网络请求开始
    self.httpTask.willStart = ^(SBHttpTask * _Nonnull task) {
        if (__self.willStart) {
            __self.willStart(__self);
        }
    };

    //上传进度
    self.httpTask.onUpload = ^(SBHttpTask * _Nonnull task, NSProgress * _Nonnull uploadProgress) {
        if (__self.onUpload) {
            __self.onUpload(__self, uploadProgress);
        }
    };

    //下载进度
    self.httpTask.onDownload = ^(SBHttpTask * _Nonnull task, NSProgress * _Nonnull downloadProgress) {
        if (__self.onDownload) {
            __self.onDownload(__self, downloadProgress);
        }
    };

    //下载到 地址
    self.httpTask.destination = ^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        if (__self.destination) {
            return __self.destination(targetPath, response);
        }
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *destinationUrl = [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        return destinationUrl;
    };
}

//停止加载和解析数据，停止事件响应
- (void)stopLoading {
    if (hasFinishedLoad) {
        return;
    }

    hasFinishedLoad = YES;

    if (self.httpTask) {
        [self.httpTask cancel];
    }
    self.httpTask = nil;
}

//释放资源
- (void)dealloc {
    [self stopLoading];
}

#pragma mark -
#pragma mark 获取数据
//获取本地解析好的数据
- (DataItemResult *)getDataItemResult {
    if (!hasFinishedLoad) {
        return nil;
    }
    
    return self.dataItemResult;
}

//数据装载事件完成后调用的函数，自动释放一次
- (void)onFinished {
    @synchronized(self){
        if (hasFinishedLoad) {
            return;
        }
        
        hasFinishedLoad = YES;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoader:onReceived:)]) {
            [self.delegate dataLoader:self onReceived:self.dataItemResult];
        }
        else {
            if (self.onReceived) {
                self.onReceived(self, self.dataItemResult);
            }
        }

        self.httpTask = nil;
    }
}

#pragma mark -
#pragma mark 网络回调
//网络数据加载完成后调用该方法，并开始解析数据
- (void)task:(SBHttpTask *)task onReceived:(NSData *)data {
    
    //解析正确的网络数据
    self.dataItemResult = [SBHttpDataParser parseData:data task:task];
    
    //结束一次请求
    [self onFinished];
}

//网络连接出错时调用该方法
- (void)task:(SBHttpTask *)task onError:(NSError *)error {
    self.dataItemResult.hasError = YES;
    self.dataItemResult.message = @"网络貌似不给力，请重新加载";
    
    [self onFinished];
}

#pragma mark -
#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        //什么都不做
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    //什么都不做
}
@end
