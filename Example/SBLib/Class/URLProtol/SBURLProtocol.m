//
//  SBURLProtocol.m
//  EMLive
//
//  Created by roronoa on 2017/3/3.
//  Copyright © 2017年 roronoa. All rights reserved.
//

#import "SBURLProtocol.h"/** 响应URL 协议 **/

#define SBURLProtocolKey @"SBURLProtocolKey"

/** 响应URL 协议 **/
@interface SBURLProtocol()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession * session;

@end

@implementation SBURLProtocol

SB_ARC_SINGLETON_IMPLEMENT(SBURLProtocol)

/**
 *  是否拦截处理指定的请求
 */
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {

    /*
     防止无限循环，因为一个请求在被拦截处理过程中，也会发起一个请求，这样又会走到这里，如果不进行处理，就会造成无限循环
     */
    if ([NSURLProtocol propertyForKey:SBURLProtocolKey inRequest:request]) {
        return NO;
    }

    NSString * url = request.URL.absoluteString;

    // 如果url已http或https开头，则进行拦截处理，否则不处理
    if ([url hasPrefix:@"http"] || [url hasPrefix:@"https"]) {
        return YES;
    }
    return NO;
}

/**
 *  如果需要对请求进行重定向，添加指定头部等操作，可以在该方法中进行
 */
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    // 修改了请求的头部信息
    NSMutableURLRequest * mutableReq = [request mutableCopy];
    return [mutableReq copy];
}

/**
 *  开始加载，在该方法中，加载一个请求
 */
- (void)startLoading {
    NSMutableURLRequest * request = [self.request mutableCopy];

    // 表示该请求已经被处理，防止无限循环
    [NSURLProtocol setProperty:@(YES) forKey:SBURLProtocolKey inRequest:request];
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask * task = [self.session dataTaskWithRequest:request];
    [task resume];
}

/**
 *  取消请求
 */
- (void)stopLoading {
    [self.session invalidateAndCancel];
    self.session = nil;
}

#pragma mark - NSURLSessionDataDelegate

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
//    DDLogInfo(@"##API## %@", task.taskDescription);

    if (error) {
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler
{
    completionHandler(proposedResponse);
}

@end
