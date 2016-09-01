//
//  SBHttpHelper.h
//  GubaModule
//
//  Created by Thomas on 15/1/8.
//  Copyright (c) 2015年 eastmoney. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (sbhttphelper)

/** 获取url 请求 */
- (NSString *)sb_httpGetMethodDomain;

/** 获取url的参数键值对 (字符串)*/
- (NSString *)sb_httpGetMethodParamsString;

/** 获取url的参数键值对 (字典)*/
- (NSDictionary *)sb_httpGetMethodParams;

@end

@interface SBHttpHelper : NSObject

/** 在状态栏上显示网络连接状态的转子 */
+ (void)showNetworkIndicator;

/** 在状态栏上隐藏网络连接状态的转子 */
+ (void)hiddenNetworkIndicator;

/** HTTP 请求头报错时的错误信息 */
+ (NSString *)httpStatusErrorStr:(NSInteger)statusCode;

/** 从一个 NSError 对象中解析错误信息 */
- (NSString *)descriptionFromError:(NSError *)error;

@end
