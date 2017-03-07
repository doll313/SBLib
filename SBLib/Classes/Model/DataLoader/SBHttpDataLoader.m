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
#import "SBAppCoreInfo.h"

@implementation SBHttpDataLoader

#pragma mark -
#pragma mark 生命周期

//初始化GET方式请求的网络数据
- (id)initWithURL:(NSString *)URL delegate:(id<SBHttpDataLoaderDelegate>)target {
	return [self initWithURL:URL httpMethod:@"GET" delegate:target];
}

//初始化网络数据
- (id)initWithURL:(NSString *)URL httpMethod:(NSString *)httpMethod delegate:(id<SBHttpDataLoaderDelegate>)target{
	self = [super init];

	if(nil != self){
        self.dataItemResult = [[DataItemResult alloc] init];
        self.delegate = target;
        self.httpTask = [[SBHttpTask alloc] initWithURLString:URL httpMethod:httpMethod delegate:self];
	}

	return self;
}

//停止加载和解析数据，停止事件响应
- (void)stopLoading {
    if (hasFinishedLoad) {
        return;
    }

    hasFinishedLoad = YES;

    self.delegate = nil;
    
    if (self.httpTask) {
        [self.httpTask cancel];
    }
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
    }
}

#pragma mark -
#pragma mark 网络回调
//网络数据加载完成后调用该方法，并开始解析数据
- (void)task:(SBHttpTask *)task onReceived:(NSData *)data {
    
    //解析正确的网络数据
    self.dataItemResult = [SBHttpDataParser parseData:data withURLString:task.aURLString];
    
    //结束一次请求
    [self onFinished];
}

//网络连接出错时调用该方法
- (void)task:(SBHttpTask *)task onError:(NSError *)error {
    self.dataItemResult.hasError = YES;
    self.dataItemResult.message = @"网络貌似不给力，请重新加载";
    
    [self onFinished];
}

- (void)task:(SBHttpTask *)task didSendData:(NSInteger)sendedBytes totalData:(NSInteger)totalBytes {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoader:didSendData:totalData:)]) {
        [self.delegate dataLoader:self didSendData:sendedBytes totalData:totalBytes];
    }
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
