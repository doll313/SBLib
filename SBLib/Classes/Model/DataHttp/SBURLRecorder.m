//
//  SBURLRecorder.m
//  SBLib
//
//  Created by roronoa on 2017/3/6.
//  Copyright © 2017年 roronoa. All rights reserved.
//

#import "SBURLRecorder.h"           //URL记录
#import "DataItemResult.h"

@implementation SBURLRecorder

SB_ARC_SINGLETON_IMPLEMENT(SBURLRecorder)

+ (void)load {
    [SBURLRecorder sharedSBURLRecorder];
}

- (id)init {
    self = [super init];
    //界面进入后台
    [SBNotificationCenter addObserver:self
                             selector:@selector(applicationDidEnterBackgroundNotification:)
                                 name:UIApplicationDidEnterBackgroundNotification
                               object:nil];
    return self;
}

//退到后台
- (void)applicationDidEnterBackgroundNotification:(NSNotification *)noti {
}

/** 记录 **/
+ (void)record:(DataItemDetail *)detail {
    [[SBURLRecorder sharedSBURLRecorder] record:detail];
}

/** 记录 **/
- (void)record:(DataItemDetail *)detail {
    if (detail.dictData.allKeys.count == 0) {
        return;
    }

    if (!self.apiResult) {
        self.apiResult = [DataItemResult new];
    }

    [self.apiResult insertItem:detail atIndex:0];

    if (self.apiResult.count > 200) {
        [self.apiResult.dataList removeLastObject];
    }
}

/** 记录 **/
+ (DataItemResult *)records {
    return [[SBURLRecorder sharedSBURLRecorder] records];
}

/** 记录 **/
- (DataItemResult *)records {
    if (!self.apiResult) {
        self.apiResult = [DataItemResult new];
    }

    return self.apiResult;
}

@end
