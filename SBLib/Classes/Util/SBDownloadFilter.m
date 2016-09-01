/*
 #####################################################################
 # File    : DownloadQueue.m
 # Project : 
 # Created : 2012-08-21
 # DevTeam : 
 # Author  : solomon (xmwen@126.com)
 # Notes   : 加载数据的队列
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

#import "SBDownloadFilter.h"

#define ID2KEY(x) [NSNumber numberWithLong:(long)x]

@interface SBDownloadFilter () <SBHttpTaskDelegate> {
}

@end

@implementation SBDownloadFilter

- (id)init {
    self = [super init];
    
    _url2conn = [[NSMutableDictionary alloc] initWithCapacity:0];
    _conn2delegate = [[NSMutableDictionary alloc] initWithCapacity:0];
    _conn2url = [[NSMutableDictionary alloc] initWithCapacity:0];

    return self;
}

- (void)dealloc {
    for (SBHttpTask *task in _url2conn) {
        [task stopLoading];
    }

    [_url2conn release];
    [_conn2url release];
    [_conn2delegate release];

    [super dealloc];
}

/** 实现单例模式 */
SB_NOARC_SINGLETON_IMPLEMENT(SBDownloadFilter);

- (SBHttpTask *)addRequestURL:(NSString *)URL postData:(NSData *)postData delegate:(id<SBHttpTaskDelegate>)delegate {
    @synchronized(self){
        SBHttpTask *task = _url2conn[URL];
        
        if (nil == task) {
            task = [[SBHttpTask alloc] initWithURLString:URL httpMethod:@"GET" delegate:self];
            
            _url2conn[URL] = task;
            _conn2url[ID2KEY(task)] = URL;
            [task release];
        }
        
        NSMutableArray *delegateList = _conn2delegate[ID2KEY(task)];
        if (nil == delegateList) {
            delegateList = [NSMutableArray arrayWithCapacity:0];
            _conn2delegate[ID2KEY(task)] = delegateList;
        }
        
        [delegateList addObject:ID2KEY(delegate)];
        
        return task;
    }
}

- (void)removeRequestURL:(NSString *)URL delegate:(id<SBHttpTaskDelegate>)delegate {
    @synchronized(self){
        SBHttpTask *task = _url2conn[URL];
        
        if (nil == task) {
            return;
        }
        
        NSMutableArray *delegateList = _conn2delegate[ID2KEY(task)];
        
        if (nil != delegateList) {
            for (int i=0; i < [delegateList count]; i++) {
                NSNumber *tmp_num = delegateList[i];
                
                if ([tmp_num isEqualToNumber:ID2KEY(delegate)]) {
                    [delegateList removeObjectAtIndex:i];
                    break;
                }
            }
        }
        
        if ([delegateList count] == 0) {
            [task stopLoading];
            [self removetask:task];
        }
    }
}

- (void)stopAllConnection {
    NSArray *urls = self.url2conn.allKeys;
    for (NSString *url in urls) {
        [self stopConnectionByURL:url];
    }
}

- (void)stopConnectionByURL:(NSString *)URL {
    @synchronized(self){
        SBHttpTask *task = _url2conn[URL];
        if (nil == task) {
            return;
        }
        [task stopLoading];
        [self removetask:task];
    }
}

- (void)removetask:(SBHttpTask *)task {
    NSString *URL = _conn2url[ID2KEY(task)];

    if (nil != URL) {
        [_url2conn removeObjectForKey:URL];
    }

    [_conn2delegate removeObjectForKey:ID2KEY(task)];
    [_conn2url removeObjectForKey:ID2KEY(task)];
    
}

/** onError 方法，在 SBHttpTask 请求出错时回调的方法 */
- (void)task:(SBHttpTask *)task onError:(NSError *)error {
    @synchronized(self){
        NSMutableArray *delegateList = _conn2delegate[ID2KEY(task)];
        
        if (nil != delegateList) {
            for (NSNumber *delegate_num in delegateList) {
                id<SBHttpTaskDelegate> delegate = (id<SBHttpTaskDelegate>) [delegate_num longValue];
                
                if ([delegate respondsToSelector:@selector(task:onError:)]) {
                    [delegate task:task onError:error];
                }
            }
        }
        
        [self removetask:task];
    }
}

/** onReceived 方法，在 SBHttpTask 数据加载完成后回调的方法 */
- (void)task:(SBHttpTask *)task onReceived:(NSData *)data {
    @synchronized(self){
        NSMutableArray *delegateList = _conn2delegate[ID2KEY(task)];
        
        if (delegateList.count > 0) {
            for (NSNumber *delegate_num in delegateList) {
                id<SBHttpTaskDelegate> delegate = (id<SBHttpTaskDelegate>)[delegate_num longValue];
                if (delegate && [delegate respondsToSelector:@selector(task:onReceived:)]) {
                    [delegate task:task onReceived:data];
                }
            }
        }
        
        [self removetask:task];
    }
}

+ (SBHttpTask *)addRequestURL:(NSString *)URL delegate:(id<SBHttpTaskDelegate>)delegate {
    return [[SBDownloadFilter sharedSBDownloadFilter] addRequestURL:URL postData:nil delegate:delegate];
}

+ (SBHttpTask *)addRequestURL:(NSString *)URL postData:(NSData *)postData delegate:(id<SBHttpTaskDelegate>)delegate {
    return [[SBDownloadFilter sharedSBDownloadFilter] addRequestURL:URL postData:postData delegate:delegate];
}

+ (void)removeRequestURL:(NSString *)URL delegate:(id<SBHttpTaskDelegate>)delegate {
    [[SBDownloadFilter sharedSBDownloadFilter] removeRequestURL:URL delegate:delegate];
}

+ (void)stopRequestURL:(NSString *)URL {
    [[SBDownloadFilter sharedSBDownloadFilter] stopConnectionByURL:URL];
}

+ (void)stopAllRequest {
    [[SBDownloadFilter sharedSBDownloadFilter] stopAllConnection];
}

@end
