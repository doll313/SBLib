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

/** 替换类方法 **/
+ (void)sb_swizzleClassMethod:(Class)className originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector;

/** 替换实例方法 **/
+ (void)sb_swizzleInstanceMethod:(Class)className originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector;

/** 不为空 */
- (BOOL)sb_notNull;
/**
 将本object作为NSDictionary的key
 @return NSValue类型的返回值（包装了id）,可以用来做key
 */
- (NSValue *)sb_asKey;

/**转换成json字符串
 *适用于字典、数组 */
- (NSString *)el_jsonString;

@end
