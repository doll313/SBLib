/*
#####################################################################
# File    : NSDataCagegory.h
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


//为SDK自带的 NSData 类添加一些实用方法
@interface NSData (sbmodule)


/** 把一个 NSData 转成十六进制字符串 */
- (NSString *)sb_toHexString;

/** 从一个十六进制字符串创建一个 NSData 对象 */
+ (NSData *)sb_dataWithHexString:(NSString *)string;

/** 去掉转义符号 */
- (NSString *)sb_removeEscapes;

@end

@interface NSData (Base64)

/**base64字符串 创建一个nsdata对象*/
+ (NSData *)sb_dataWithBase64EncodedString:(NSString *)string;

/**NSDATA base 64 转 nsstring*/
- (NSString *)sb_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;

/**NSDATA base 64 转 nsstring*/
- (NSString *)base64EncodedString;

@end

@interface NSData (AES)

/**
AES256加密

@param key 密钥

@return 加密结果
*/

- (NSData*)sb_encryptAES:(NSString *) key;

/**
AES256解密

@param key 密钥

@return 解密结果
 */
- (NSData *)sb_decryptAES:(NSString *) key;

@end

@interface NSData (EMSB_JSON)
/**
 从一个json的nsdata转换成dict或array，
 **使用UTF8编码**
 
 @return dict or array
 */
- (id)sb_objectFromJSONData;

/**
 从一个json的nsdata转换成dict或array, 指定编码
 
 @param encoding 编码
 
 @return dict or array
 */
- (id)sb_objectFromJSONDataUsingEncoding:(NSStringEncoding)encoding;

@end
