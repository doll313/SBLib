/*
#####################################################################
# File    : NSStringCagegory.h
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

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

/** 对一个字符串进行安全URLEncode */
#define safeURLEncode(str)  (nil == str ? @"" : [str sb_urlEncoding])

/** 判断字符串是否为空---- */
#define sb_empty(str)          (![str isKindOfClass:[NSString class]] || nil == str || [str length] < 1 ||[str isEqualToString:@"(null)"])

//为SDK自带的 NSString 类添加一些实用方法
@interface NSString (sbmodule)

/** 计算字符串的md5值 */
- (NSString *)sb_md5;

/** 去掉字符串两端的空白字符 */
- (NSString *)trim;

/** 对字符串URLencode编码 */
- (NSString *)sb_urlEncoding;

/** 对字符串URLdecode解码 */
- (NSString *)sb_urlDecoding;

/** 判断一个字符串是否全由字母组成 */
- (BOOL)isAllletters;

/** 从UIColor对象生成一个字符串 */
+ (NSString *)fromColor:(UIColor *)color;

/** 从字符串生成一个UIColor对象 */
- (UIColor *)toColor;

/** 从字符串生成一个UIColor对象，并指定一个默认颜色 */
- (UIColor *)toColorWithDefaultColor:(UIColor *)defaultColor;

/** 忽略大小写比较两个字符串 */
- (BOOL)equalsIgnoreCase:(NSString *)str;

/** 是否包含特定字符串 */
- (BOOL)contains:(NSString *)str;

/** 删除所有html tag */
- (NSString *)stringWithoutHTMLTags;

/** 把HTML转换为TEXT文本 */
- (NSString *)html2text;

/** 移除一些HTML标签 */
- (NSString *)striptags;

/** 字符串是不是一个纯整数型 */
- (BOOL)isPureInt;

/**判断是否为浮点形*/
- (BOOL)isFloat;

/**判断是否为数字*/
- (BOOL)isNumber;

//判断第一个字是不是字母
- (BOOL)isFirstLetter;

//格式化字符数按前缀  eg:@"+0.08"---->@"0.08"
- (NSString *)formatterStrPrefix;

//192.168.0.33---->192.168.0.*
- (NSString *)formatterIP;

//尾部加“吧”
- (NSString *)addSuffixBar;

//尾部去掉“吧”
- (NSString *)removeSuffixBar;

//截取到第几位的长度
- (NSString *)sbSubStringToIndex:(NSInteger)index;

/** 文本的实际尺寸 */
- (CGSize)sb_sizeWithFont:(UIFont *)font;
- (CGSize)sb_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGSize)sb_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGFloat)sb_widthWithFontSize:(CGFloat)fontsize;
- (CGFloat)sb_heightWithContentWidth:(CGFloat)width font:(UIFont *)font;
- (CGFloat)sb_widthWithContentHeight:(CGFloat)height font:(UIFont *)font;

/** 随机汉字 **/
+ (NSString *)sb_randomHanzi:(NSInteger)count;

//中文的拼音首字母
- (NSString *)sb_cnFirstLetter;

@end

//这些是从带链接Label那拷贝过来的代码
@interface NSString (Base64)

+ (NSString *)emsb_stringWithBase64EncodedString:(NSString *)string;
- (NSString *)emsb_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)emsb_base64EncodedString;
- (NSString *)emsb_base64DecodedString;
- (NSData *)emsb_base64DecodedData;

@end

@interface NSString (AES)

/**
 将本string用AES加密之后，返回用base64编码的字符串
 */
- (NSString *)sb_encryptAES:(NSString *) key;

/**
 将一个base64编码的字符串还原并用AES解密
 */
- (NSString *)sb_decryptAES:(NSString *) key;

@end

@interface NSString (EMSB_JSON)

/**
 从json string得到一个dictionary或array
 
 @return dictionary or array
 */
- (id)sb_objectFromJSONString;

@end

@interface NSString(JSONHealing)

/**
 fuck the server end
 后台传过来的“JSON”可能有错误导致无法解析，这里对可能出现的问题进行修正。
 但是由于后台的问题千奇百怪，无法保证所有问题都可以修正
 
 @return 可能没问题的JSON
 */
- (NSString *)stringByHealJSONString;

@end




