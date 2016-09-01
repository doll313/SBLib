/*
 #####################################################################
 # File    : DataBaseCacheClean.h.m
 # Project : 
 # Created : 2013-03-30
 # DevTeam : thomas only one
 # Author  : thomas
 # Notes   : 
 #####################################################################
 ### Change Logs   ###################################################
 #####################################################################
 ---------------------------------------------------------------------
 # Date  :
 # Author:
 # Notes :
 #
 #####################################################################
 */

#import "SBDataBaseEvent.h"
#import "SBAppCoreInfo.h"
#import "DataAppCacheDB.h"

@implementation SBDataBaseEvent

//获取 TABLE_BIN_VALUE 表中指定数据的总大小
+ (long)getBinSize {
    DataAppCacheDB *cacheDB = [SBAppCoreInfo getCacheDB];
    
    NSMutableString *SQL = [NSMutableString stringWithCapacity:0];
    [SQL appendFormat:@"select length(`DATA_VALUE`) from `%@`", cacheDB.dbBinValueTable];
    
    long result = 0;
    FMResultSet *s = [cacheDB.db executeQuery:SQL];
    // 每条记录的检索值
    while ([s next]) {
        result += [s intForColumnIndex:0];
    }
    
    return result;
}

// 执行数据库缓存清理操作
+ (void)cleanAllDBCache {
    DataAppCacheDB *cacheDB = [SBAppCoreInfo getCacheDB];
    [cacheDB truncateTable:cacheDB.dbBinValueTable];
    [cacheDB truncateTable:cacheDB.dbStrValueTable];
    [cacheDB truncateTable:cacheDB.dbIntValueTable];
    [cacheDB compressDB];
}

@end
