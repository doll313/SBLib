//
//  SBHttpHelper.m
//  SBLib
//
//  Created by Thomas on 15/1/8.
//  Copyright (c) 2015年 eastmoney. All rights reserved.
//

#import "SBHttpHelper.h"
#import "NSDictionary+SBMODULE.h"
#import "SBHttpTaskQueue.h"         //网络请求队列

@implementation NSString(sbhttphelper)
/** 获取url 请求 */
- (NSString *)sb_httpGetMethodDomain {
    //以第一个 ？分隔,
    NSRange itemsRange = [self rangeOfString:@"?"];
    if (itemsRange.location == NSNotFound) {
        return [NSString stringWithFormat:@"%@", self];
    }
    NSString *urlStrDomain = [self substringToIndex:itemsRange.location];
    
    return urlStrDomain;
}

/** 获取url的参数键值对 (字符串)*/
- (NSString *)sb_httpGetMethodParamsString {
    //以第一个 ？分隔,
    NSRange itemsRange = [self rangeOfString:@"?"];
    if (itemsRange.location == NSNotFound) {
        return @"";
    }
    NSString *urlStrFooter = [self substringFromIndex:itemsRange.location +1];
    
    
#ifdef DEGUG
    NSString *urlStrDomain = [self substringToIndex:itemsRange.location];
    NSAssert((urlStrDomain.length > 0) || (urlStrFooter.length > 0), @"传入的不是一个url");
#endif
    return urlStrFooter;
    
}

/** 获取url的参数键值对 */
- (NSDictionary *)sb_httpGetMethodParams {
    NSString *urlStrFooter = [self sb_httpGetMethodParamsString];
    if (SBStringIsEmpty(urlStrFooter)) {
        return @{};
    }
    //通过URL(GET形式)的参数得到一个dictionary
    return [NSDictionary sb_dictionaryWithURL:urlStrFooter];
}
@end

@implementation SBHttpHelper
// HTTP 请求头报错时的错误信息
+ (NSString *)httpStatusErrorStr:(NSInteger)statusCode {
    NSString *statusErrorStr = @"";
    // 对常见错误汉化
    switch (statusCode) {
        case 400:
            statusErrorStr = @"请求中有语法问题，或不能满足请求";
            break;
        case 401:
            statusErrorStr = @"未授权客户机访问数据";
            break;
        case 402:
            statusErrorStr = @"表示计费系统已有效";
            break;
        case 403:
            statusErrorStr = @"即使有授权也不需要访问";
            break;
        case 404:
            statusErrorStr = @"服务器找不到给定的资源";
            break;
        case 415:
            statusErrorStr = @"服务器拒绝服务请求，因为不支持请求实体的格式";
            break;
        case 500:
            statusErrorStr = @"因为意外情况，服务器不能完成请求";
            break;
        case 501:
            statusErrorStr = @"服务器不支持请求的工具";
            break;
        case 502:
            statusErrorStr = @"服务器接收到来自上游服务器的无效响应";
            break;
        case 503:
            statusErrorStr = @"由于临时过载或维护，服务器无法处理请求";
            break;
        default:
            statusErrorStr = [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
            break;
    }
    
    return statusErrorStr;
}

/** 从一个 NSError 对象中解析错误信息 */
- (NSString *)descriptionFromError:(NSError *)error {
    if (nil == error) {
        return nil;
    }
    
    NSString *errDomain = [error domain];
    
    if ([errDomain isEqualToString:APPCONFIG_CONN_ERROR_MSG_DOMAIN]) {
        NSDictionary *userInfo = [error userInfo];
        
        if (nil != userInfo) {
            NSString *errorInfo = userInfo[APPCONFIG_CONN_ERROR_MSG_DOMAIN];
            if (errorInfo != nil) {
                return errorInfo;
            }
        }
        
        return @"网络未链接!";
    }
    
    else if ([errDomain isEqualToString:NSURLErrorDomain]){
        switch (error.code) {
            case NSURLErrorNotConnectedToInternet:
                return @"似乎没有网络连接";
                break;
            case NSURLErrorBadURL:
                return @"URL错误";
                break;
            case NSURLErrorTimedOut:
                return @"连接超时";
                break;
            case NSURLErrorNetworkConnectionLost:
                return @"连接被重置";
                break;
            default:
                return @"网络连接错误";
                break;
        }
    }
    
    NSString *localizedDescription = [error localizedDescription];
    
    if (nil != localizedDescription && [localizedDescription length] > 0) {
        return @"网络貌似不给力，请稍后再来!";
    }
    
    return @"未知错误!";
}

@end
