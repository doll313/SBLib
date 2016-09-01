/*
 #####################################################################
 # File    : NSDictionaryCategory.m
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

#import "NSDictionary+SBMODULE.h"
#import "NSString+SBMODULE.h"

@implementation NSDictionary (AppExt)

- (NSString *)sb_URLArgumentsString {
    __block NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj == [NSNull null]) {
            return;
        }
        NSString *encodedKey   = [key sb_urlEncoding];
        NSString *value        = [self objectForKey:key];
        NSString *encodedValue = [[value description] sb_urlEncoding];
        NSString *kvPair       = [NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue];
        [arguments addObject:kvPair];
    }];
    return [arguments componentsJoinedByString:@"&"];
}

+ (NSDictionary *)sb_dictionaryWithURL:(NSString *)argString {
    NSMutableDictionary *ret = [NSMutableDictionary dictionary];
    NSArray *components = [argString componentsSeparatedByString:@"&"];
    [components enumerateObjectsUsingBlock:^(NSString *component, NSUInteger idx, BOOL *stop) {
        if (component.length == 0) {
            return;
        }
        NSRange pos = [component rangeOfString:@"="];
        NSString *key = nil;
        NSString *val = nil;
        if (pos.location == NSNotFound) {
            //            key = [component sb_urlDecoding];
            //            val = @"";
        } else {
            key = [[component substringToIndex:pos.location] sb_urlDecoding];
            val = [[component substringFromIndex:pos.location + pos.length] sb_urlDecoding];
            if (!key) key = @"";
            if (!val) val = @"";
            [ret setObject:val forKey:key];
        }
    }];
    return ret;
}

@end


@implementation NSMutableDictionary (AppExt)

/** 重写 setObject 方法，确保 Object 和 Key 为空时不 Crash */
- (void)sb_setObject:(id)anObject forKey:(id <NSCopying>)aKey {
    if (nil == anObject || nil == aKey) {
        return;
    }
    
    self[aKey] = anObject;
}

@end
