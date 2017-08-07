/*
#####################################################################
# File    : NSObjectCagegory.m
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

#import "NSObject+SBMODULE.h"
#import <objc/runtime.h>

@implementation NSObject (sbmodule)

+ (void)sb_swizzleClassMethod:(Class)className originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector
{
    Method otherMehtod = class_getClassMethod(className, otherSelector);
    Method originMehtod = class_getClassMethod(className, originSelector);

    BOOL didAddMethod =
    class_addMethod(className,
                    originSelector,
                    method_getImplementation(otherMehtod),
                    method_getTypeEncoding(otherMehtod));
    if (didAddMethod) {
        class_replaceMethod(className,
                            otherSelector,
                            method_getImplementation(originMehtod),
                            method_getTypeEncoding(originMehtod));
    }
    else {
        method_exchangeImplementations(otherMehtod, originMehtod);
    }
}

+ (void)sb_swizzleInstanceMethod:(Class)className originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector
{
    Method otherMehtod = class_getInstanceMethod(className, otherSelector);
    Method originMehtod = class_getInstanceMethod(className, originSelector);

    BOOL didAddMethod =
    class_addMethod(className,
                    originSelector,
                    method_getImplementation(otherMehtod),
                    method_getTypeEncoding(otherMehtod));
    if (didAddMethod) {
        class_replaceMethod(className,
                            otherSelector,
                            method_getImplementation(originMehtod),
                            method_getTypeEncoding(originMehtod));
    }
    else {
        method_exchangeImplementations(otherMehtod, originMehtod);
    }
}

- (BOOL)sb_notNull {
    return ((NSNull *)self != [NSNull null]);
}

- (NSValue *)sb_asKey {
    return [NSValue valueWithNonretainedObject:self];
}

- (NSString *)sb_jsonString {
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    return @"";
}

@end
