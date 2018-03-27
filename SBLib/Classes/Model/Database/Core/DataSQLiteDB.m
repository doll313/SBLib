/*
 #####################################################################
 # File    : DataSQLiteDB.h
 # Project : 
 # Created : 2013-03-30
 # DevTeam :
 # Author  : roronoa
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

#import "DataSQLiteDB.h"
#import "SBFileManager.h"

@interface DataSQLiteDB() {
}


@end

@implementation DataSQLiteDB

#pragma mark -
#pragma mark 生命周期

//初始化数据库
- (id)init:(NSString *)dbname {
    self = [super init];
    
    self.dbpath = [SBFileManager getDbFullPath:dbname];
    self.db = [FMDatabase databaseWithPath:_dbpath];
    [self.db openWithFlags:SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE|SQLITE_OPEN_FULLMUTEX];
    
    self.queue = [FMDatabaseQueue databaseQueueWithPath:_dbpath];
    
    return self;
}

//释放资源
- (void)dealloc {
    [self closeDB];
}

#pragma mark -
#pragma mark 基本操作
//关闭数据库
- (void)closeDB {
    [self.db close];
}
//获取指定表中符合条件的数据条数
- (sqlite3_int64)tableRows:(NSString *)tableName whereParam:(NSString *)whereParam {
    if (SBStringIsEmpty(tableName)) {
        return 0;
    }
    
    NSMutableString *countStr = [NSMutableString stringWithCapacity:0];
    
    [countStr appendFormat:@"select count(*) from `%@`", tableName];
    
    if (nil != whereParam || [whereParam length] > 0) {
        [countStr appendFormat:@" where %@", whereParam];
    }
    
    FMResultSet *s = [self.db executeQuery:countStr];
    if ([s next]) {
        return [s intForColumnIndex:0];
    }
    
    return 0;
}

// 判断是否存在表
- (BOOL)hasTable:(NSString *)tableName {
    FMResultSet *rs = [self.db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next]) {
        NSInteger count = [rs intForColumn:@"count"];
        return 0 != count;
    }
    
    return NO;
}

/** 清空一张表 */
- (void)truncateTable:(NSString *)tableName {
    if(SBStringIsEmpty(tableName)){
        return;
    }
    
    [self.db executeUpdate:[NSString stringWithFormat:@"DELETE FROM '%@'", tableName]];
//    [self.db executeUpdate:[NSString stringWithFormat:@"UPDATE sqlite_sequence SET seq=0 WHERE name='%@'", tableName]];
}

/** 清理并压缩数据库 */
- (void)compressDB {
    [self.db executeUpdate:@"VACUUM"];
}

#pragma mark -
#pragma mark 查询操作
//获取列表数据，返回一个数据键值对的数组
- (NSArray *)getAllDBData:(NSString *)sqlStr {
    NSMutableArray *dataArray  = [[NSMutableArray alloc] init];
    
    FMResultSet *rs = [self.db executeQuery:sqlStr];
    NSDictionary *columnNameToIndexMap = rs.columnNameToIndexMap;
    NSArray *columnNames = columnNameToIndexMap.allKeys;
    
    while ([rs next]) {
        NSMutableDictionary *columnDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
        
        for (NSString *columnName in columnNames) {
            //通过列名取单元格（
            columnDictionary[columnName] = [rs objectForColumnName:columnName];
        }
        
        //每行数据都以字典形式加入到数组中
        [dataArray addObject:columnDictionary];
    }

    return dataArray;
}

//获取单条数据，返回一个对应的键值对
- (NSDictionary *)getColumnItem:(NSString *)sqlStr {
    FMResultSet *rs = [self.db executeQuery:sqlStr];
    NSDictionary *columnNameToIndexMap = rs.columnNameToIndexMap;
    NSArray *columnNames = columnNameToIndexMap.allKeys;
    
    //一条数据
    NSMutableDictionary *columnItem = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    while ([rs next]) {
        for (NSString *columnName in columnNames) {
            //通过列名取单元格（
            columnItem[columnName] = [rs objectForColumnName:columnName];
        }
        
        return columnItem;
    }
    return columnItem;
}

//获取一个数据cell中的数据
- (id)getColumnValue:(NSString *)sqlStr {
    FMResultSet *rs = [self.db executeQuery:sqlStr];
    while ([rs next]) {
        return [rs objectForColumnIndex:0];
    }

    return @"";
}

@end
