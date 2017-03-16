//
//  SBHttpTaskQueue.m
//  Pods
//
//  Created by roronoa on 2017/3/16.
//
//

#import "SBHttpTaskQueue.h"         //网络请求队列

/** 网络请求队列 **/
@interface SBHttpTaskQueue ()

@end

@implementation SBHttpTaskQueue

SB_ARC_SINGLETON_IMPLEMENT(SBHttpTaskQueue);

- (id)init {
    self = [super init];

    [self addObserver:self forKeyPath:@"operations" options:0 context:nil];
    
    return self;
}

- (void)addOperation:(NSOperation *)op {
    [super addOperation:op];

    //显示转子
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

//KVO,观察parseQueue是否执行完
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"operations"])
    {
        if (0 == self.operations.count) {
            //转子
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
@end
