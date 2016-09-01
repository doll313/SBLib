//
//  NVNetworkType.m
//  Core
//
//  Created by Yimin Tu on 12-7-1.
//  Copyright (c) 2012年 dianping.com. All rights reserved.
//

#import "SBNetworkReachability.h"
#import "CoreTelephony/CTTelephonyNetworkInfo.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>

static SCNetworkReachabilityRef __reachability = nil;

SBNetworkReachability SBGetNetworkReachability() {
    if(!__reachability) {
        struct sockaddr_in zeroAddress;
        bzero(&zeroAddress, sizeof(zeroAddress));
        zeroAddress.sin_len = sizeof(zeroAddress);
        zeroAddress.sin_family = AF_INET;
        __reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    }
    
    SCNetworkReachabilityFlags flags;
	if (__reachability && SCNetworkReachabilityGetFlags(__reachability, &flags)) {
        if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
        {
            // if target host is not reachable
            return SBNetworkReachabilityNone;
        }
        
        SBNetworkReachability retVal = SBNetworkReachabilityNone;
        
        if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
        {
            // if target host is reachable and no connection is required
            //  then we'll assume (for now) that your on Wi-Fi
            retVal = SBNetworkReachabilityWifi;
        }
        
        
        if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
             (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
        {
			// ... and the connection is on-demand (or on-traffic) if the
			//     calling application is using the CFSocketStream or higher APIs
            
			if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
			{
				// ... and no [user] intervention is needed
				retVal = SBNetworkReachabilityWifi;
			}
		}
        
        if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
        {
            // ... but WWAN connections are OK if the calling application
            //     is using the CFNetwork (CFSocketStream?) APIs.
            retVal = SBNetworkReachabilityMobile;
        }
        return retVal;
    }
    return SBNetworkReachabilityNone;
}

//只会返回 wifi 移动 和 没有网络
NSString* SBGetNetworkReachabilityDescribe() {
    SBNetworkReachability reachability = SBGetNetworkReachability();
    
    if (reachability == SBNetworkReachabilityMobile) {
        return @"mobile";
    } else if (reachability == SBNetworkReachabilityWifi) {
        return @"wifi";
    } else {
        return @"无网络";
    }
}

static CTTelephonyNetworkInfo * __telephonyNetworkInfo;
SBNetworkReachability SBGetAccurateNetworkReachability()
{
    SBNetworkReachability reachability = SBGetNetworkReachability();
    if (reachability == SBNetworkReachabilityMobile) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
            if (!__telephonyNetworkInfo) {
                __telephonyNetworkInfo = [CTTelephonyNetworkInfo new];
            }
            NSString * radioAccessTechnology = __telephonyNetworkInfo.currentRadioAccessTechnology;
            if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS] ||
                [radioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] ||
                [radioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMA1x])
                reachability = SBNetworkReachabilityMobile2G;
            else if ([radioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE])
                reachability = SBNetworkReachabilityMobile4G;
            else
                reachability = SBNetworkReachabilityMobile3G;
        } else {
            SCNetworkReachabilityFlags flags;
            SCNetworkReachabilityGetFlags(__reachability, &flags);
            return ((flags & kSCNetworkReachabilityFlagsTransientConnection) == kSCNetworkReachabilityFlagsTransientConnection) ? SBNetworkReachabilityMobile2G : SBNetworkReachabilityMobile3G;
        }
    }
    return reachability;
}