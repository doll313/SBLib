//
//  SBNetworkFlow.h
//  SBNetworkFlow
//
//  Created by MengWang on 16/12/22.
//  Copyright © 2016年 YukiWang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SBNetworkFlowNotification             @"SBNetworkFlowNotification" //流量变化监听

//流量
@interface SBNetworkFlow : NSObject

/** 流量属性 **/
@property (nonatomic, assign) u_int32_t kWiFiSent;
@property (nonatomic, assign) u_int32_t kWiFiReceived;
@property (nonatomic, assign) u_int32_t kWWANSent;
@property (nonatomic, assign) u_int32_t kWWANReceived;

/** 开始监听**/
- (void)startblock:(void (^)(u_int32_t sendFlow, u_int32_t receivedFlow))block;
- (void)stop;
@end
