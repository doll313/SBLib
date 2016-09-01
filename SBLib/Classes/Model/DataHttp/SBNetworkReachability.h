/*
 #####################################################################
 # File    : SBHttpTask.h
 # Project :
 # Created : 2015-01-07
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

#import <Foundation/Foundation.h>

/*
 未公开函数，请勿直接调用
 */
typedef enum {
    SBNetworkReachabilityNone = 0,
    SBNetworkReachabilityWifi = 1,
    SBNetworkReachabilityMobile = 2,
    SBNetworkReachabilityMobile2G = 3,
    SBNetworkReachabilityMobile3G = 4,
    SBNetworkReachabilityMobile4G = 5,
} SBNetworkReachability;

//只会返回 wifi 移动 和 没有网络
NSString* SBGetNetworkReachabilityDescribe();

//只会返回 wifi 移动 和 没有网络
SBNetworkReachability SBGetNetworkReachability();

//ios7以上，返回具体的网络 否则同上一个方法
SBNetworkReachability SBGetAccurateNetworkReachability();