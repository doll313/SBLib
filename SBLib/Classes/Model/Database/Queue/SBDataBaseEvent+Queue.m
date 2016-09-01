//
//  SBDataBaseEvent+Queue.m
//  SBModule
//
//  Created by MengWang on 16/8/19.
//  Copyright © 2016年 thomas. All rights reserved.
//

#import "SBDataBaseEvent+Queue.h"
#import "SBAppCoreInfo.h"
#import "DataAppCacheDB.h"
#import "DataAppDB+Queue.h"

@implementation SBDataBaseEvent (sb_queue)

//获取 TABLE_BIN_VALUE 表中指定数据的总大小
+ (void)getBinSizeWithBlock:(nullable void(^)(FMDatabase *__nonnull, long binSize))completeBlock {
    
    DataAppCacheDB *cacheDB = [SBAppCoreInfo getCacheDB];
    
    [cacheDB.queue inDatabase:^(FMDatabase *db) {
        NSMutableString *SQL = [NSMutableString stringWithCapacity:0];
        [SQL appendFormat:@"select length(`DATA_VALUE`) from `%@`", cacheDB.dbBinValueTable];
        
        long result = 0;
        FMResultSet *s = [db executeQuery:SQL];
        // 每条记录的检索值
        while ([s next]) {
            result += [s intForColumnIndex:0];
        }
        
        completeBlock(db, result);
        [s close];
    }];
 }

// 执行数据库缓存清理操作
+ (void)cleanAllDBCacheWithBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock {
    DataAppCacheDB *cacheDB = [SBAppCoreInfo getCacheDB];
    [cacheDB truncateTableWithQueue:cacheDB.dbBinValueTable];
    [cacheDB truncateTableWithQueue:cacheDB.dbStrValueTable];
    [cacheDB truncateTableWithQueue:cacheDB.dbIntValueTable];
    [cacheDB compressDBWithQueue];
    completeBlock([SBAppCoreInfo getCacheDB].db, YES);
}

@end
