//
//  SBURLProtocol.h
//  SBLib
//
//  Created by roronoa on 2017/3/3.
//  Copyright © 2017年 roronoa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBObjectSingleton.h"

/** 响应URL 协议 **/
@interface SBURLProtocol : NSURLProtocol

SB_ARC_SINGLETON_DEFINE(SBURLProtocol)

@end
