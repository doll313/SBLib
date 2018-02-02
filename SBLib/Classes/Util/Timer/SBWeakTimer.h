//
//  SBWeakTimer.h
//  SBLib
//
//  Created by Thomas Wang on 2017/8/31.
//  Copyright © 2017年 roronoa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SBTimerHandler)(id userInfo);

//弱引用timer， 使用这个函数生成的定时器 不会与拥有者本身强相关
@interface SBWeakTimer : NSObject

//开启定时器 sel
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                     target:(id)aTarget
                                   selector:(SEL)aSelector
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats;

//开启定时器 block
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(SBTimerHandler)block
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats;

@end

@interface NSTimer (sbmodule)

//暂停
- (void)pauseTimer;

//继续
- (void)resumeTimer;

//过一段时间再继续
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
