/*
 #####################################################################
 # File    : DownloadQueue.h
 # Project : 
 # Created : 2012-08-21
 # DevTeam :
 # Author  : solomon (xmwen@126.com)
 # Notes   : 加载数据的筛选器 排重
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

@interface SBDownloadFilter : NSObject

@property (nonatomic, strong) NSMutableDictionary *url2conn;
@property (nonatomic, strong) NSMutableDictionary *conn2url;
@property (nonatomic, strong) NSMutableDictionary *conn2delegate;

/** 定义单例模式 */
SB_NOARC_SINGLETON_DEFINE(SBDownloadFilter);

+ (SBHttpTask *)addRequestURL:(NSString *)URL delegate:(id<SBHttpTaskDelegate>)delegate;

+ (SBHttpTask *)addRequestURL:(NSString *)URL postData:(NSData *)postData delegate:(id<SBHttpTaskDelegate>)delegate;

+ (void)removeRequestURL:(NSString *)URL delegate:(id<SBHttpTaskDelegate>)delegate;

+ (void)stopRequestURL:(NSString *)URL;

+ (void)stopAllRequest;

@end
