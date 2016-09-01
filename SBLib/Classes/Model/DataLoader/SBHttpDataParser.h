/*
 #####################################################################
 # File    : DataParser.h
 # Project : GubaModule
 # Created : 14-5-6
 # DevTeam : eastmoney
 # Author  : 缪 和光
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

@class DataItemResult;
@interface SBHttpDataParser : NSObject

//解析数据
+ (DataItemResult *)parseData:(NSData *)data withURLString:(NSString *)urlStr;


@end
