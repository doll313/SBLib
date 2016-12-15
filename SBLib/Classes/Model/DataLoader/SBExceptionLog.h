/*
 #####################################################################
 # File    : SBExceptionLog.h
 # Project : GubaModule
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

/** 记录接口错误日志 */
+ (void)logSBHttpException:(SBHttpTask *)httpTask;

/** 记录崩溃日志 */
+ (void)logSBCrashException:(NSException *)exception;

/** * 获取接口错误日志 */
+ (NSString *)getSBHttpException;

/** * 获取崩溃日志 */
+ (NSString *)getSBCrashException;

/** 记录 */
+ (void)record:(NSString *)log key:(NSString *)key;

/** 获取记录 */
+ (NSArray *)getRecordList:(NSString *)key;

/** 获取记录 */
+ (NSString *)getRecord:(NSString *)key;

@end
