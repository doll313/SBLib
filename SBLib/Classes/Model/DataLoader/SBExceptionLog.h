/*
 #####################################################################
 # File    : SBExceptionLog.h
 # Project : SBLib
 # Created : 14/12/29
 # DevTeam : eastmoney
 # Author  : Thomas
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
#import <Foundation/Foundation.h>
#import "SBObjectSingleton.h"

#define SBKEY_RECORD_CTRL           @"SBKEY_RECORD_CTRL"        //记录跳转路径
#define SBKEY_RECORD_HTTP           @"SBKEY_RECORD_HTTP"        //记录http请求
#define SBKEY_RECORD_OPERATION           @"SBKEY_RECORD_OPERATION"        //记录用户操作

@class SBHttpTask;

//记录错误日子
@interface SBExceptionLog : NSObject {
    NSMutableDictionary *recordStack;
    NSDate *AppCreateTime;
}

SB_ARC_SINGLETON_DEFINE(SBExceptionLog);

/** * 获取接口错误日志 */
+ (NSString *_Nullable)getSBHttpException;

/** * 获取崩溃日志 */
+ (NSString *_Nullable)getSBCrashException;

/** 记录 */
+ (void)record:(NSString *_Nonnull)log key:(NSString *_Nonnull)key;

/** 获取记录 */
+ (NSArray *_Nullable)getRecordList:(NSString *_Nonnull)key;

/** 获取记录 */
+ (NSString *_Nullable)getRecord:(NSString *_Nonnull)key;

@end
