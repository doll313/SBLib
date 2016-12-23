//
//  SBNetworkFlow.m
//  SBNetworkFlow
//
//  Created by MengWang on 16/12/22.
//  Copyright © 2016年 YukiWang. All rights reserved.
//

#import "SBNetworkFlow.h"       //流量信息
#include <ifaddrs.h>
#include <net/if.h>

@interface SBNetworkFlow()

@property (nonatomic, copy) void (^secondBlock)(u_int32_t sendFlow, u_int32_t receivedFlow);  //每秒获取

@property (assign,nonatomic) uint32_t historySent;
@property (assign,nonatomic) uint32_t historyRecived;
@property (assign,nonatomic) BOOL     isFirst;
@property (nonatomic, strong)NSTimer *timer;

@end

@implementation SBNetworkFlow

- (instancetype)init {
    if ([super init]) {
        [self getNetflow];
    }
    
    return self;
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;

    self.secondBlock = nil;
}

- (void)startblock:(void (^)(u_int32_t sendFlow, u_int32_t receivedFlow))block {
    self.secondBlock = block;
    self.isFirst = YES;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getNetflow) userInfo:nil repeats:YES];
}

- (void)stop {
    [_timer invalidate];
    _timer = nil;
}

/** 流量消耗状态 **/
- (void)getNetflow {
    BOOL   success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;

    self.kWiFiSent = 0;
    self.kWiFiReceived = 0;
    self.kWWANSent = 0;
    self.kWWANReceived = 0;

    NSString *name = @"";

    success = getifaddrs(&addrs) == 0;
    if (success)
    {
        cursor = addrs;
        while (cursor != NULL)
        {
            name=[NSString stringWithFormat:@"%s",cursor->ifa_name];

            // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
                if ([name hasPrefix:@"en"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    self.kWiFiSent+=networkStatisc->ifi_obytes;
                    self.kWiFiReceived+=networkStatisc->ifi_ibytes;
                }
                if ([name hasPrefix:@"pdp_ip"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    self.kWWANSent+=networkStatisc->ifi_obytes;
                    self.kWWANReceived+=networkStatisc->ifi_ibytes;
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }

    //第一次不统计
    if (self.isFirst) {
        self.isFirst = NO;
    }
    else {
        uint32_t nowSent = (self.kWiFiSent + self.kWWANSent - self.historySent);
        uint32_t nowRecived = (self.kWiFiReceived + self.kWWANReceived - self.historyRecived);

        if (self.secondBlock) {
            self.secondBlock(nowSent, nowRecived);
        }
    }

    self.historySent = self.kWiFiSent + self.kWWANSent;
    self.historyRecived = self.kWiFiReceived + self.kWWANReceived;
}

@end
