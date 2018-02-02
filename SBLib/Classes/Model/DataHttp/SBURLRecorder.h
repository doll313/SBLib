//
//  SBURLRecorder.h
//  EMLive
//
//  Created by roronoa on 2017/3/6.
//  Copyright © 2017年 roronoa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBObjectSingleton.h"

@class DataItemResult;
@class DataItemDetail;

@interface SBURLRecorder : NSObject

SB_ARC_SINGLETON_DEFINE(SBURLRecorder)

@property (nonatomic, strong) DataItemResult * _Nonnull apiResult;//api 请求集合

/** 记录 **/
+ (void)record:(DataItemDetail *_Nonnull)detail;

/** 记录 **/
+ (DataItemResult *_Nonnull)records;

@end
