/*
 #####################################################################
 # File    : SBCrashManager.h
 # Project :
 # Created : 2015-01-19
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

#import <Foundation/Foundation.h>

@interface SBCrashManager : NSObject

+ (void)install;

/** 处理异常 */
- (void)handleException:(NSException *)exception;

@end
