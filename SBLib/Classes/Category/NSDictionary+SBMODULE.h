/*
 #####################################################################
 # File    : NSDictionaryCategory.h
 # Project : StockBar
 # Created : 13-6-21
 # DevTeam : Thomas
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

/**
 这个扩展参照了GTM中的GTMNSDictionary+URLArguments
 */
@interface NSDictionary(AppExt)

/**
 返回一个用于url参数的string
 如key1=value1&key2=value2
 返回的字符串经过sb_urlEncoding
 */
- (NSString *)sb_URLArgumentsString;

/**
 通过URL(GET形式)的参数得到一个dictionary
 
 例子：
 
    NSString *str = @"x=1&y=2&z=3";
    NSDictionary *dict = [NSDictionary sb_dictionaryWithURL:str];
 
 @param argString 键值对组成的string比如code=CODE&openid=OPENID&openkey=OPENKEY
 @return NSDictionary包含上述键值对
 */
+ (NSDictionary *)sb_dictionaryWithURL:(NSString *)argString;

@end


@interface NSMutableDictionary (AppExt)

/** 重写 setObject 方法，确保 Object 和 Key 为空时不 Crash */
- (void)sb_setObject:(id)anObject forKey:(id <NSCopying>)aKey;

@end
