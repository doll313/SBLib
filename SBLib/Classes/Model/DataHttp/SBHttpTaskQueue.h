//
//  SBHttpTaskQueue.h
//  Pods
//
//  Created by roronoa on 2017/3/16.
//
//

#import <Foundation/Foundation.h>

/** 网络请求队列 **/
@interface SBHttpTaskQueue : NSOperationQueue

SB_ARC_SINGLETON_DEFINE(SBHttpTaskQueue);

@end
