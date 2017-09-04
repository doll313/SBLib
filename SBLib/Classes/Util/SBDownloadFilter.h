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
#import "SBObjectSingleton.h"

@interface SBDownloadFilter : NSObject

@property (nonatomic, strong) NSMutableDictionary * _Nullable url2conn;
@property (nonatomic, strong) NSMutableDictionary * _Nullable conn2url;
@property (nonatomic, strong) NSMutableDictionary * _Nullable conn2delegate;

/** 定义单例模式 */
SB_NOARC_SINGLETON_DEFINE(SBDownloadFilter);

+ (SBHttpTask *_Nonnull)addRequestURL:(NSString *_Nullable)URL delegate:(id <SBHttpTaskDelegate> _Nullable)delegate;

+ (SBHttpTask *_Nonnull)addRequestURL:(NSString *_Nullable)URL postData:(NSData *_Nullable)postData delegate:(id<SBHttpTaskDelegate>_Nullable)delegate;

+ (void)removeRequestURL:(NSString *_Nullable)URL delegate:(id<SBHttpTaskDelegate> _Nullable)delegate;

+ (void)stopRequestURL:(NSString *_Nullable)URL;

+ (void)stopAllRequest;

@end
