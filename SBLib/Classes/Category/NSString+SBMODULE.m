/*
#####################################################################
# File    : NSStringCagegory.m
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

#import "NSString+SBMODULE.h"
#import "NSData+SBMODULE.h"

@implementation NSString (sbmodule)

/**
 * 计算字符串的md5值
 *
 * @return NSString
 **/
- (NSString *)sb_md5 {
	if(self == nil || [self length] == 0){
		return nil;
	}
    
	const char *src = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(src, (unsigned int)strlen(src), result);
    
	return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

/**
 * 去掉字符串两端的空白字符
 *
 * @return NSString
 **/
- (NSString *) trim {
	if(nil == self){
		return nil;
	}
    
	NSMutableString *re = [NSMutableString stringWithString:self];
	CFStringTrimWhitespace((CFMutableStringRef)re);
	return (NSString *)re;
}

/**
 * 对字符串URLencode编码
 *
 * @return NSString
 **/
- (NSString *)sb_urlEncoding {
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *s = [NSString stringWithString:self];
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)s,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

/**
 * 对字符串URLdecode解码
 *
 * @return NSString
 **/
- (NSString *)sb_urlDecoding {
    NSString *s = [NSString stringWithString:self];
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                            (__bridge CFStringRef)s,
                                                            CFSTR(""),
                                                            CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}


/**
 * 判断一个字符串是否全由字母组成
 *
 * @return NSString
 **/
- (BOOL)isAllletters {
	NSString *regPattern = @"[a-zA-Z]+";
	NSPredicate *testResult = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regPattern];
	return [testResult evaluateWithObject:self];
}

///**
// * 创建一个唯一的UDID
// *
// * @return NSString
// **/
//+ (NSString *)createUDID {
//	CFUUIDRef udid = CFUUIDCreate(nil);
//	NSString *strUDID = (NSString *)CFUUIDCreateString(nil, udid);
//	CFRelease(udid);
//	return [strUDID autorelease];
//}

/**
 * 从UIColor对象生成一个字符串
 *
 * @return NSString
 **/
+ (NSString *)fromColor:(UIColor *)color {
	if (nil == color) {
		return nil;
	}
    
	CGColorRef c = color.CGColor;
	const CGFloat *components = CGColorGetComponents(c);
	size_t numberOfComponents = CGColorGetNumberOfComponents(c);
	NSMutableString *str = [NSMutableString stringWithCapacity:0];
    unsigned int hexC = 0;
    
	[str appendString:@"#"];
    
    if (numberOfComponents != 2 && numberOfComponents != 4) {
        return nil;
    }
    
    for (size_t i = 0; i < numberOfComponents - 1; ++i) {
        hexC = (unsigned int)floor(255.0f * components[i]);
        [str appendString:[NSString stringWithFormat:@"%02x", hexC & 255]];
    }
    
    if (numberOfComponents == 2) {
        size_t padNum = 4 - numberOfComponents;
        
        for (size_t i = 0; i < padNum; ++i) {
            [str appendString:[NSString stringWithFormat:@"%02x", hexC & 255]];
        }
    }
    
    hexC = (unsigned int)floor(255.0f * components[numberOfComponents - 1]);
    hexC = (255 - hexC) & 255;
    
    if (hexC != 0) {
        [str appendString:[NSString stringWithFormat:@"%02x", hexC]];
    }
    
	return str;
}

/**
 * 从字符串生成一个UIColor对象
 *
 * @return UIColor
 **/
- (UIColor *)toColor {
	return [self toColorWithDefaultColor:nil];
}

/**
 * 从字符串生成一个UIColor对象，并指定一个默认颜色
 *
 * @return UIColor
 **/
- (UIColor *)toColorWithDefaultColor:(UIColor *)defaultColor {
	NSString *str = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    
    if ([str contains:@"grouptableviewbackgroundcolor"]) {
        return [UIColor groupTableViewBackgroundColor];
    } else if ([str contains:@"black"]) {
        return [UIColor blackColor];
    } else if ([str contains:@"darkgray"]) {
        return [UIColor darkGrayColor];
    } else if ([str contains:@"lightgray"]) {
        return [UIColor lightGrayColor];
    } else if ([str contains:@"white"]) {
        return [UIColor whiteColor];
    } else if ([str contains:@"gray"]) {
        return [UIColor grayColor];
    } else if ([str contains:@"red"]) {
        return [UIColor redColor];
    } else if ([str contains:@"green"]) {
        return [UIColor greenColor];
    } else if ([str contains:@"blue"]) {
        return [UIColor blueColor];
    } else if ([str contains:@"cyan"]) {
        return [UIColor cyanColor];
    } else if ([str contains:@"yellow"]) {
        return [UIColor yellowColor];
    } else if ([str contains:@"magenta"]) {
        return [UIColor magentaColor];
    } else if ([str contains:@"orange"]) {
        return [UIColor orangeColor];
    } else if ([str contains:@"purple"]) {
        return [UIColor purpleColor];
    } else if ([str contains:@"brown"]) {
        return [UIColor brownColor];
    } else if ([str contains:@"clear"]) {
        return [UIColor clearColor];
    }
    
	if ([str hasPrefix:@"0x"]){
		str = [str substringFromIndex:2];
	} else if ([str hasPrefix:@"#"]){
		str = [str substringFromIndex:1];
	}
    
	if ([str length] != 6 && [str length] != 3 && [str length] != 8 && [str length] != 4){
		return defaultColor;
	}
    
	NSRange range;
	unsigned int r, g, b, a;
    
	if ([str length] == 3 || [str length] == 4) {
		range.length = 1;
	} else {
		range.length = 2;
	}
    
	range.location = 0 * range.length;
	if(![[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&r]){
		return defaultColor;
	}
    
	range.location = 1 * range.length;
	if(![[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&g]){
		return defaultColor;
	}
    
	range.location = 2 * range.length;
	if(![[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&b]){
		return defaultColor;
	}
    
	if ([str length] == 4 || [str length] == 8) {
		range.location = 3 * range.length;
        
		if(![[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&a]){
			return defaultColor;
		}
	} else {
		a = 0;
	}
    
	if ([str length] == 3 || [str length] == 4) {
        r = (r<<4|r);
        g = (g<<4|r);
        b = (b<<4|r);
        a = (a<<4|r);
    }
    
	return RGB_A(r, g, b, (255.0f - a) / 255.0f);
}


/**
 * 忽略大小写比较两个字符串
 *
 * @return BOOL
 **/
- (BOOL)equalsIgnoreCase:(NSString *)str {
	if (nil == str) {
		return NO;
	}
    
	return [[str lowercaseString] isEqualToString:[self lowercaseString]];
}

/** 是否包含特定字符串 */
- (BOOL)contains:(NSString *)str {
	if (nil == str || [str length] < 1) {
		return NO;
	}
    
	return [self rangeOfString:str].location != NSNotFound;
}

- (NSString *)stringWithoutHTMLTags {
    NSRange r;
    NSString *s = [NSString stringWithString:self];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

/** 把HTML转换为TEXT文本 */
- (NSString *)html2text {
	NSString *str = [NSString stringWithString:self];
    
	str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
	str = [str stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
	str = [str stringByReplacingOccurrencesOfString:@"<BR>" withString:@"\n"];
	str = [str stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
	str = [str stringByReplacingOccurrencesOfString:@"<BR />" withString:@"\n"];
	str = [str stringByReplacingOccurrencesOfString:@"<b>" withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"<B>" withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"</b>" withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"</B>" withString:@" "];
    
	return str;
}

/** 移除一些HTML标签 */
- (NSString *)striptags {
	NSString *str = [NSString stringWithString:self];
    
	str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"<br>" withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"<BR>" withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"<br />" withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"<BR />" withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"  " withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"  " withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    
	return str;
}

//字符串是不是一个纯整数型
- (BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
- (BOOL)isFloat {
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

//判断是否为数字
- (BOOL)isNumber {
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return ([scan scanInt:&val] || [scan scanInt:&val]) && [scan isAtEnd];
}

- (NSInteger) indexOfSubStr:(NSString *)subStr {
    if (nil == subStr || [subStr length] <= 0) {
        return -1;
    }
    NSArray *results = nil;
    
    results = [self componentsSeparatedByString:@","];
    
    for (int index = 0 ; index < [results count];index++){
        NSString *_str = [results objectAtIndex:index];
        if ([_str isEqualToString:subStr]) {
            return index;
        }
    }
    return -1;
}

//格式化字符数按前缀
- (NSString *)formatterStrPrefix {
    if ([self hasPrefix:@"+"]) {
        return [self substringFromIndex:1];
    }
    return self;
}

- (NSString *)formatterIP {
    NSArray *array = [self componentsSeparatedByString:@"."];
    if (!array || [array count] != 4) {
        return self;
    }
    return [NSString stringWithFormat:@"%@.%@.%@.*",[array objectAtIndex:0],[array objectAtIndex:1],[array objectAtIndex:2]];
}


//尾部加“吧”
- (NSString *)addSuffixBar {
    NSString *_str = [NSString stringWithString:self];
    if (![_str hasSuffix:@"吧"]) {
        _str = [NSString stringWithFormat:@"%@吧", [_str trim]];
    }
    
    return _str;
}

//尾部去掉“吧”
- (NSString *)removeSuffixBar {
    NSString *_str = [NSString stringWithString:self];
    if ([_str hasSuffix:@"吧"]) {
        _str = [[self substringToIndex:self.length - 1] trim];
    }
    
    return _str;
}

//截取到第几位的长度
- (NSString *)sbSubStringToIndex:(NSInteger)index{
    NSString *_str = [NSString stringWithString:self];
    if(_str.length>index){
        return [_str substringToIndex:index];
    }
    return _str;
}

static inline CGSize ajustedSize(CGSize originalSize) {
    CGSize ajustedSize = originalSize;
    ajustedSize.width = ceilf(originalSize.width);
    ajustedSize.height = ceilf(originalSize.height);
    return ajustedSize;
}

- (CGSize)sb_sizeWithFont:(UIFont *)font {
    return ajustedSize([self sizeWithAttributes: @{NSFontAttributeName:font}]);
}

- (CGSize)sb_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    return ajustedSize([self boundingRectWithSize:size
                                          options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                       attributes:@{NSFontAttributeName:font}
                                          context:nil].size);
}

- (CGSize)sb_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode {
    return ajustedSize([self boundingRectWithSize:size
                                          options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                       attributes:@{NSFontAttributeName:font}
                                          context:nil].size);
}

- (CGFloat)sb_widthWithFontSize:(CGFloat)fontsize {
    return [self sb_sizeWithFont:[UIFont systemFontOfSize:fontsize]].width;
}

- (CGFloat)sb_heightWithContentWidth:(CGFloat)width font:(UIFont *)font {
    CGSize size = CGSizeMake(width, MAXFLOAT);
    return [self sb_sizeWithFont:font constrainedToSize:size].height;
}

- (CGFloat)sb_widthWithContentHeight:(CGFloat)height font:(UIFont *)font {
    CGSize size = CGSizeMake(MAXFLOAT, height);
    return [self sb_sizeWithFont:font constrainedToSize:size].width;
}

@end

@implementation NSString (Base64)

+ (NSString *)emsb_stringWithBase64EncodedString:(NSString *)string
{
    NSData *data = [NSData sb_dataWithBase64EncodedString:string];
    if (data)
    {
        NSString *result = [[self alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
#if !__has_feature(objc_arc)
        [result autorelease];
#endif
        
        return result;
    }
    return nil;
}

- (NSString *)emsb_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data sb_base64EncodedStringWithWrapWidth:wrapWidth];
}

- (NSString *)emsb_base64EncodedString
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data base64EncodedString];
}

- (NSString *)emsb_base64DecodedString
{
    return [NSString emsb_stringWithBase64EncodedString:self];
}

- (NSData *)emsb_base64DecodedData
{
    return [NSData sb_dataWithBase64EncodedString:self];
}

@end

@implementation NSString (EMSB_JSON)

- (id)sb_objectFromJSONString {
    
    id result = nil;
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0f) {
        result = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
//    }else{
//        result = [self objectFromJSONString];
//    }
    
    if (result == nil) {
        // 后台的JSON错了，尝试修正
        NSString *possibleJson = [self stringByHealJSONString];
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0f) {
            result = [NSJSONSerialization JSONObjectWithData:[possibleJson dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
//        }else{
//            result = [possibleJson objectFromJSONString];
//        }
    }
    return result;
}

@end

@implementation NSString (AES)

- (NSString *)sb_encryptAES:(NSString *) key {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [data sb_encryptAES:key];
    return [encryptedData base64EncodedString];
}

- (NSString *)sb_decryptAES:(NSString *) key {
    NSData *encryptedData = [NSData sb_dataWithBase64EncodedString:self];
    NSData *data = [encryptedData sb_decryptAES:key];
    NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return result;
}

@end

@implementation NSMutableString (sbmodule)

//追加字符串 nil不会crash 追加空值
- (void)appendStringEx:(NSString *)aString {
    if (aString == nil) { // 为 nil 时就不用管它了
        return;
    }

    [self appendString:aString];
}

@end


@implementation NSString(HasReminder)
//是否有预警
- (BOOL)hasReminder {
    if ([self hasPrefix:@"SH"] || [self hasPrefix:@"SZ"]) {
        return YES;
    }
    return NO;
}

@end

@implementation NSString(JSONHealing)

- (NSString *)stringByHealJSONString
{
    NSMutableString *mStr = [[NSMutableString alloc] initWithCapacity:self.length];
    // 处理所有需要escape的字符
    for(int i=0; i< self.length; i++){
        unichar c = [self characterAtIndex:i];
        NSString *s = [NSString stringWithCharacters:&c length:1];
        switch (c) {
            case '\b':
                [mStr appendString:@"\\b"];
                break;
            case '\f':
                [mStr appendString:@"\\f"];
                break;
            case '\n':
                [mStr appendString:@"\\n"];
                break;
            case '\r':
                [mStr appendString:@"\\r"];
                break;
            case '\t':
                [mStr appendString:@"\\t"];
                break;
            case '\v':
                [mStr appendString:@"\\v"];
                break;
            default:
                [mStr appendString:s];
                break;
        }
    }
    return mStr;
}

@end

