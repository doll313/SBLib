/*
 #####################################################################
 # File    : DataParser.m
 # Project : SBLib
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

#if !__has_feature(objc_arc)

#error "This file should be compiled with ARC!"

#endif

#import "SBHttpDataParser.h"
#import "DataItemResult.h"      //

@implementation SBHttpDataParser

//解析网络数据
+ (DataItemResult *)parseData:(NSData *)data task:(SBHttpTask *)task {
    DataItemResult *result = [[DataItemResult alloc]init];
    
    //原始数据无论都带着
    result.rawData = data;
    
    return result;
}
@end
