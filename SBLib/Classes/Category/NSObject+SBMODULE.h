/*
#####################################################################
# File    : NSObjectCagegory.h
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

//为SDK自带的 NSObject 类添加一些实用方法
@interface NSObject (sbmodule)

/** 不为空 */
- (BOOL)sb_notNull;

@end

@interface NSObject (SBTricks)

/**
 将本object作为NSDictionary的key
 
 例如
 [dict setObject:someObj forKey:anotherObj.sb_asKey];
 [dict objectForKey:anotherObj.sb_asKey];
 
 @return NSValue类型的返回值（包装了id）,可以用来做key
 */
- (NSValue *)sb_asKey;

@end
