//
//  SBDataBaseEvent+Queue.h
//  SBModule
//
//  Created by MengWang on 16/8/19.
//  Copyright © 2016年 thomas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBDataBaseEvent.h"

@interface SBDataBaseEvent (sb_queue)

//获取 TABLE_BIN_VALUE 表中指定数据的总大小
+ (void)getBinSizeWithBlock:(nullable void(^)(FMDatabase *__nonnull, long binSize))completeBlock;

// 执行数据库缓存清理操作
+ (void)cleanAllDBCacheWithBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock;

@end
