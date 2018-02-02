//
//  SBOperation.h
//  SBLib
//
//  Created by roronoa on 2017/12/6.
//  Copyright © 2017年 roronoa. All rights reserved.
//

#import <Foundation/Foundation.h>

//操作状态 用于重写SDK函数
typedef NS_ENUM(NSInteger, SBOperationState) {
    SBOperationStateReady,
    SBOperationStateExecuting,
    SBOperationStateFinished,
};

@interface SBOperation : NSOperation

@property (nonatomic, assign) SBOperationState state;         //仅仅是一个状态 外面不要调用
/** 开始 此函数已经确保在主线程运行  继承的子类请重写 **/
- (void)excuteInMainThread;

@end
