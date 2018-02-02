//
//  SBOperation.m
//  SBLib
//
//  Created by roronoa on 2017/12/6.
//  Copyright © 2017年 roronoa. All rights reserved.
//

#import "SBOperation.h"        //操作基类 切不要直接使用

@interface SBOperation()

@property (nonatomic, strong) NSRecursiveLock *lock;

@end

@implementation SBOperation


- (instancetype)init {
    self = [super init];
    if (self) {
        [self setState:SBOperationStateReady];
        _lock = [[NSRecursiveLock alloc]init];
    }
    return self;
}

- (void)dealloc {
}

- (void)start {
    [super start];

    if (self.isCancelled) {
        self.state = SBOperationStateFinished;
        return;
    }

    void (^startBlock)(void) = ^void(){
        self.state = SBOperationStateExecuting;
        [self excuteInMainThread];
    };

    //确保在主线程
    if ([NSThread currentThread] != [NSThread mainThread]) {
        dispatch_sync(dispatch_get_main_queue(), startBlock);
    } else{
        startBlock();
    }
}

/** 开始 **/
- (void)excuteInMainThread {
    self.state = SBOperationStateExecuting;
}

- (void)setState:(SBOperationState)newState {
    [self.lock lock];
    if (newState == _state) {
        [self.lock unlock];
        return;
    }

    switch (newState) {
        case SBOperationStateReady:
            [self willChangeValueForKey:@"isReady"];
            break;
        case SBOperationStateExecuting:
            [self willChangeValueForKey:@"isReady"];
            [self willChangeValueForKey:@"isExecuting"];
            break;
        case SBOperationStateFinished:
            [self willChangeValueForKey:@"isExecuting"];
            [self willChangeValueForKey:@"isFinished"];
            break;
    }

    _state = newState;

    switch (newState) {
        case SBOperationStateReady:
            [self didChangeValueForKey:@"isReady"];
            break;
        case SBOperationStateExecuting:
            [self didChangeValueForKey:@"isReady"];
            [self didChangeValueForKey:@"isExecuting"];
            break;
        case SBOperationStateFinished:
            [self didChangeValueForKey:@"isExecuting"];
            [self didChangeValueForKey:@"isFinished"];
            break;
    }
    [self.lock unlock];
}

- (void)cancel{
    if (self.isFinished) {
        return;
    }
    if (self.state == SBOperationStateExecuting) {
        self.state = SBOperationStateFinished;
    }

    [super cancel];
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isReady
{

    return ([self state] == SBOperationStateReady && [super isReady]);
}

- (BOOL)isFinished
{
    return ([self state] == SBOperationStateFinished);
}

- (BOOL)isExecuting {

    return ([self state] == SBOperationStateExecuting);
}
@end
