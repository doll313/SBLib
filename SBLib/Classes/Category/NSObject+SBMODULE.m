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

@implementation NSObject (sbmodule)

- (BOOL)sb_notNull {
    return ((NSNull *)self != [NSNull null]);
}

@end

@implementation NSObject(SBTricks)

- (NSValue *)sb_asKey {
    return [NSValue valueWithNonretainedObject:self];
}

@end
