//
//  DataAppDB+Queue.m
//  IosSqlTest
//
//  Created by MengWang on 16/8/15.
//  Copyright © 2016年 YukiWang. All rights reserved.
//

#import "DataAppDB+Queue.h"
#import "DataItemDetail.h"
#import "DataItemResult.h"

@implementation DataAppDB (sb_queue)

#pragma mark -
#pragma mark 删除操作

/** 清理表中的无效数据 */
- (void)deleteTypeItem:(NSString *)tableName dataType:(NSString *)dataType dataKey:(NSString *)dataKey inSeconds:(NSInteger)seconds withBlock:(nullable void(^)(FMDatabase *db, BOOL success))completeBlock {
    if(SBStringIsEmpty(dataType) || SBStringIsEmpty(dataKey)){
        completeBlock(self.db, NO);
    } else {

        NSMutableString *whereParam = [NSMutableString stringWithCapacity:0];
        
        [whereParam appendFormat:@"`DATA_TYPE`='%@'", dataType];
        
        if(dataKey.length > 0){
            [whereParam appendFormat:@" and `DATA_KEY`='%@'", dataKey];
        }
        
        if(seconds > 0){
            [whereParam appendString:@" and (`DATA_ADDTIME` > datetime('now','localtime')"];
            [whereParam appendFormat:@" or `DATA_ADDTIME` < datetime('now','localtime','-%lu seconds'))", (unsigned long)seconds];
        }
        
        NSString *SQL = [NSString stringWithFormat:@"delete from `%@` where %@", tableName, whereParam];
        
        [self.queue inDatabase:^(FMDatabase *db) {
            BOOL isSuccess = [self.db executeUpdate:SQL];
            completeBlock(db, isSuccess);
        }];
    }
}

//删除指定表中符合条件的数据
- (void)deleteData:(NSString *)tableName whereParam:(NSString *)whereParam withBlock:(nullable void(^)(FMDatabase *db, BOOL success))completeBlock {
    if (SBStringIsEmpty(tableName)) {
        completeBlock(self.db, NO);
    } else {
    
        NSMutableString *deleteSql = [NSMutableString stringWithCapacity:0];
        [deleteSql appendFormat:@"delete from `%@`", tableName];
        
        if (nil != whereParam || [whereParam length] > 0) {
            [deleteSql appendFormat:@" where %@", whereParam];
        }
        
        [self.queue inDatabase:^(FMDatabase *db) {
            BOOL isSuccess = [self.db executeUpdate:deleteSql];
            completeBlock(db, isSuccess);
        }];
    }
}

//删除数据库中存在某个键值对
- (void)deleteTypeItem:(NSString *)tableName dataType:(NSString *)dataType dataKey:(NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *db, BOOL success))completeBlock {
    if(SBStringIsEmpty(dataType)){
        completeBlock(self.db, NO);
    } else {
    
        NSString *whereParam;
    
        if (SBStringIsEmpty(dataKey)) {
            whereParam = [NSString stringWithFormat:@"`DATA_TYPE`='%@'", dataType];
        } else {
            whereParam = [NSString stringWithFormat:@"`DATA_TYPE`='%@' and `DATA_KEY`='%@'", dataType, dataKey];
        }
        
        [self deleteData:tableName whereParam:whereParam withBlock:completeBlock];
    }
}

//清除 [TABLE_INT_VALUE] 表中的某类数据
- (void)deleteIntDataWithQueue:(nullable NSString *)dataType withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock {    [self deleteTypeItem:_dbIntValueTable dataType:dataType dataKey:nil withBlock:completeBlock];
}

//清除 [TABLE_STR_VALUE] 表中的某类数据
- (void)deleteStrDataWithQueue:(nullable NSString *)dataType withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock {    [self deleteTypeItem:_dbStrValueTable dataType:dataType dataKey:nil withBlock:completeBlock];
}

//清除 [TABLE_BIN_VALUE] 表中的某类数据
- (void)deleteBinDataWithQueue:(nullable NSString *)dataType withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock {    [self deleteTypeItem:_dbBinValueTable dataType:dataType dataKey:nil withBlock:completeBlock];
}

//删除一条整型数据
- (void)deleteIntValueWithQueue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock {
    [self deleteTypeItem:_dbIntValueTable dataType:dataType dataKey:dataKey withBlock:completeBlock];
}

//删除一条字符串数据
- (void)deleteStrValueWithQueue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock {
    [self deleteTypeItem:_dbStrValueTable dataType:dataType dataKey:dataKey withBlock:completeBlock];
}

//删除一条二进制数据
- (void)deleteBinValueWithQueue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock {
    [self deleteTypeItem:_dbBinValueTable dataType:dataType dataKey:dataKey withBlock:completeBlock];
}

//清除DataItemDetail缓存
- (void)deleteDetailValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock {
    [self deleteBinValueWithQueue:dataType dataKey:[NSString stringWithFormat:@"item.%@", dataKey] withBlock:completeBlock];
}
//清除DataItemResult缓存
- (void)deleteResultValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock {
    [self deleteBinValueWithQueue:dataType dataKey:[NSString stringWithFormat:@"items.%@", dataKey] withBlock:completeBlock];
}

//删除一条整型数据 时间段
- (void)deleteIntValueWithQueue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey inSeconds:(NSInteger)seconds withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock {
    [self deleteTypeItem:_dbIntValueTable dataType:dataType dataKey:dataKey inSeconds:seconds withBlock:completeBlock];
}

//删除一条字符串数据 时间段
- (void)deleteStrValueWithQueue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey inSeconds:(NSInteger)seconds withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock {
    [self deleteTypeItem:_dbStrValueTable dataType:dataType dataKey:dataKey inSeconds:seconds withBlock:completeBlock];
}

//删除一条二进制数据 时间段
- (void)deleteBinValueWithQueue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey inSeconds:(NSInteger)seconds withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock {
    [self deleteTypeItem:_dbBinValueTable dataType:dataType dataKey:dataKey inSeconds:seconds withBlock:completeBlock];
}

//清除DataItemDetail缓存 时间段
- (void)deleteDetailValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey inSeconds:(NSInteger)seconds withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock {
    [self deleteBinValueWithQueue:dataType dataKey:[NSString stringWithFormat:@"item.%@", dataKey] inSeconds:seconds withBlock:completeBlock];
}

//清除DataItemResult缓存 时间段
- (void)deleteResultValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey inSeconds:(NSInteger)seconds withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock {
    [self deleteBinValueWithQueue:dataType dataKey:[NSString stringWithFormat:@"items.%@", dataKey] inSeconds:seconds withBlock:completeBlock];
}

// 清空某类型数据在INT/BIN/STR三个表中的数据
- (void)deleteAllDataWithDataTypeWithQueue:(nullable NSString *)dataType withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock {
    [self deleteBinDataWithQueue:dataType withBlock:completeBlock];
    [self deleteIntDataWithQueue:dataType withBlock:completeBlock];
    [self deleteStrDataWithQueue:dataType withBlock:completeBlock];
}


#pragma mark -
#pragma mark 插入操作

//设置条数据的值
- (void)setItemValue:(nullable NSString *)tableName dataType:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey dataValue:(id)dataValue withBlock:(nullable void(^)(FMDatabase *__nonnull, sqlite3_int64 retVal))completeBlock {
    if(SBStringIsEmpty(dataType) || SBStringIsEmpty(dataKey) || SBStringIsEmpty(tableName)) {
        completeBlock(self.db, 0);
    } else {
        [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *whereParam = [NSString stringWithFormat:@"`DATA_TYPE`='%@' and `DATA_KEY`='%@'", dataType, dataKey];
            
            // 如果sql有记录，则删除原来数据
            NSString *deleteSql = [NSString stringWithFormat:@"delete from `%@` where %@", tableName, whereParam];
            [db executeUpdate:deleteSql];
        
            //sql 插入的语句
            NSString *insertSql = [NSString stringWithFormat:@"insert into `%@` (`DATA_TYPE`,`DATA_KEY`,`DATA_VALUE`) values (?,?,?)", tableName];
            [db executeUpdate:insertSql, dataType, dataKey, dataValue];
            completeBlock(db, db.lastInsertRowId);
        }];
    }
}

//设置某条整型数据
- (void)setIntValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey dataValue:(int)dataValue withBlock:(nullable void(^)(FMDatabase *__nonnull, sqlite3_int64 retVal))completeBlock {
    [self setItemValue:_dbIntValueTable dataType:dataType dataKey:dataKey dataValue:@(dataValue) withBlock:completeBlock];
}

//设置某条字符串数据
- (void)setStrValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey dataValue:(nullable NSString *)dataValue withBlock:(nullable void(^)(FMDatabase *__nonnull, sqlite3_int64 retVal))completeBlock {
    if(nil == dataValue){
        completeBlock(self.db, 0);
    } else {
        [self setItemValue:_dbStrValueTable dataType:dataType dataKey:dataKey dataValue:dataValue withBlock:completeBlock];
    }
}

//设置某条二进制数据
- (void)setBinValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey dataValue:(nullable NSData *)dataValue withBlock:(nullable void(^)(FMDatabase *__nonnull, sqlite3_int64 retVal))completeBlock {
    if(nil == dataValue){
        completeBlock(self.db, 0);
    } else {
        [self setItemValue:_dbBinValueTable dataType:dataType dataKey:dataKey dataValue:dataValue withBlock:completeBlock];
    }
}

//保存 DataItemDetail 结构的数据到数据库缓存中
- (void)setDetailValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey data:(nullable DataItemDetail *)data withBlock:(nullable void(^)(FMDatabase *__nonnull, sqlite3_int64 retVal))completeBlock {
    if(SBStringIsEmpty(dataKey) || nil == data){
        completeBlock(self.db, 0);
    } else {
        [self setBinValue:dataType dataKey:[NSString stringWithFormat:@"item.%@", dataKey] dataValue:[data toData] withBlock:completeBlock];
    }
    
}

//保存 DataItemResult 结构的数据到数据库缓存中
- (void)setResultValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey data:(nullable DataItemResult *)data withBlock:(nullable void(^)(FMDatabase *__nonnull, sqlite3_int64 retVal))completeBlock {
    if(SBStringIsEmpty(dataKey) || nil == data){
        completeBlock(self.db, 0);
    } else {
        [self setBinValue:dataType dataKey:[NSString stringWithFormat:@"items.%@", dataKey] dataValue:[data toData] withBlock:completeBlock];
    }
}

#pragma mark -
#pragma mark 查询操作

//获取一条整型数据
- (void)getIntValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, NSInteger intValue))completeBlock {
    if(SBStringIsEmpty(dataType) || SBStringIsEmpty(dataKey)){
        completeBlock(self.db, 0);
    } else {
        NSString *whereParam = [NSString stringWithFormat:@"`DATA_TYPE`='%@' and `DATA_KEY`='%@'", dataType, dataKey];
        NSString *SQL = [NSString stringWithFormat:@"select `DATA_VALUE` from `%@` where %@", _dbIntValueTable, whereParam];
        
        [self.queue inDatabase:^(FMDatabase *db) {
            FMResultSet *s = [db executeQuery:SQL];
            if ([s next]) {
                completeBlock(db, [s intForColumnIndex:0]);
            } else {
                completeBlock(db, 0);
            }
            [s close];
        }];
    }
}

//获取一条字符串数据
- (void)getStrValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, NSString * __nullable))completeBlock {
    if(SBStringIsEmpty(dataType) || SBStringIsEmpty(dataKey)){
        completeBlock(self.db, @"");
    } else {
        NSString *whereParam = [NSString stringWithFormat:@"`DATA_TYPE`='%@' and `DATA_KEY`='%@'", dataType, dataKey];
        NSString *SQL = [NSString stringWithFormat:@"select `DATA_VALUE` from `%@` where %@", _dbStrValueTable, whereParam];
        
        [self.queue inDatabase:^(FMDatabase *db) {
            // 使用FMResultSet，需要自己去关闭
            FMResultSet *s = [db executeQuery:SQL];
            if ([s next]) {
                completeBlock(db, [s stringForColumnIndex:0]);
            } else {
                completeBlock(db, @"");
            }
            
            [s close];
        }];
    }
}

//获取一条二进制数据
- (void)getBinValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, NSData * __nullable))completeBlock {
    if(SBStringIsEmpty(dataType) || SBStringIsEmpty(dataKey)){
        completeBlock(self.db, nil);
    } else {
        NSString *whereParam = [NSString stringWithFormat:@"`DATA_TYPE`='%@' and `DATA_KEY`='%@'", dataType, dataKey];
        NSString *SQL = [NSString stringWithFormat:@"select `DATA_VALUE` from `%@` where %@", _dbBinValueTable, whereParam];
        
        [self.queue inDatabase:^(FMDatabase *db) {
            FMResultSet *s = [db executeQuery:SQL];
            if ([s next]) {
                completeBlock(db, [s dataForColumnIndex:0]);
            } else {
                completeBlock(db, nil);
            }
            
            [s close];
        }];
    }
}

//获取 TABLE_BIN_VALUE 表中指定数据的总大小
- (void)getBinSize:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, long dataSize))completeBlock {
    NSMutableString *SQL = [NSMutableString stringWithCapacity:0];
    
    [SQL appendFormat:@"select length(`DATA_VALUE`),length(`DATA_TYPE`),length(`DATA_VALUE`),length(`DATA_KEY`) from `%@`", _dbBinValueTable];
    if (dataType.length != 0) {
        [SQL appendFormat:@" where `DATA_TYPE`='%@'", dataType];
    }
    if (nil != dataKey && [dataKey length] > 0) {
        [SQL appendFormat:@" and `DATA_KEY`='%@'", dataKey];
    }
    
    [self.queue inDatabase:^(FMDatabase *db) {
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

//从数据库缓存中读取 DataItemDetail 数据结构，如果不存在则返回 nil
- (void)getDetailValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, DataItemDetail * __nullable))completeBlock {
    if(SBStringIsEmpty(dataKey)){
        completeBlock(self.db, nil);
    } else {
        NSData *data = [self getBinValue:dataType dataKey:[NSString stringWithFormat:@"item.%@", dataKey]];
        
        if(nil == data){
            completeBlock(self.db, nil);
        } else {
            completeBlock(self.db, [DataItemDetail FromData:data]);
        }
    }
}

//从数据库缓存中读取 DataItemResult 数据结构，如果不存在则返回 nil
- (void)getResultValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, DataItemResult * __nullable))completeBlock {
    if(SBStringIsEmpty(dataKey)){
        completeBlock(self.db, nil);
    } else {
        NSData *data = [self getBinValue:dataType dataKey:[NSString stringWithFormat:@"items.%@", dataKey]];
        
        if(nil == data){
            completeBlock(self.db, nil);
        } else {
            completeBlock(self.db, [DataItemResult FromData:data]);
        }
    }
}

#pragma mark -
#pragma mark 判断操作

//数据库中是否存在某个键值对
- (void)hasTypeItem:(NSString *)tableName dataType:(NSString *)dataType dataKey:(NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock {
    if(SBStringIsEmpty(dataType)){
        completeBlock(self.db, NO);
    } else {
        NSString *whereParam;
        if (SBStringIsEmpty(dataKey)) {
            whereParam = [NSString stringWithFormat:@"`DATA_TYPE`='%@'", dataType];
        } else {
            whereParam = [NSString stringWithFormat:@"`DATA_TYPE`='%@' and `DATA_KEY`='%@'", dataType, dataKey];
        }
        if (SBStringIsEmpty(tableName)) {
            completeBlock(self.db, NO);
        } else {
            [self tableRows:tableName whereParam:whereParam withBlock:completeBlock];
        }
    }
}

//数据库的 [DATA_INT_VALUE] 表中是否存在某个键值对
- (void)hasIntItem:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock {
    [self hasTypeItem:_dbIntValueTable dataType:dataType dataKey:dataKey withBlock:completeBlock];
}

//数据库的 [DATA_STR_VALUE] 表中是否存在某个键值对
- (void)hasStrItem:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock {
    [self hasTypeItem:_dbStrValueTable dataType:dataType dataKey:dataKey withBlock:completeBlock];
}

//数据库的 [DATA_BIN_VALUE] 表中是否存在某个键值对
- (void)hasBinItem:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock {
    [self hasTypeItem:_dbBinValueTable dataType:dataType dataKey:dataKey withBlock:completeBlock];
}

#pragma mark -
#pragma mark 基本操作

//获取指定表中符合条件的数据条数
- (void)tableRows:(NSString *)tableName whereParam:(NSString *)whereParam withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock {
    if (SBStringIsEmpty(tableName)) {
        completeBlock(self.db, 0);
    } else {
        NSMutableString *countStr = [NSMutableString stringWithCapacity:0];
        
        [countStr appendFormat:@"select count(*) from `%@`", tableName];
        
        if (nil != whereParam || [whereParam length] > 0) {
            [countStr appendFormat:@" where %@", whereParam];
        }
        
        [self.queue inDatabase:^(FMDatabase *db) {
            FMResultSet *s = [db executeQuery:countStr];
            if ([s next]) {
                completeBlock(db, [s intForColumnIndex:0]);
            } else {
                completeBlock(db, 0);
            }
            
            [s close];
        }];
    }
}

// 判断是否存在表
- (void)hasTable:(nullable NSString *)tableName withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
        NSInteger count = 0;
        while ([rs next]) {
            count += [rs intForColumn:@"count"];
        }
        
        completeBlock(db, count);  // 取累加值
        [rs close];
    }];
}

#pragma mark -
#pragma mark 查询操作

//获取列表数据，返回一个数据键值对的数组
- (void)getAllDBData:(nullable NSString *)sqlStr withBlock:(nullable void(^)(FMDatabase *__nonnull, NSArray *__nullable))completeBlock {
    [self.queue inDatabase:^(FMDatabase *db) {
        NSMutableArray *dataArray  = [[NSMutableArray alloc] init];
        
        FMResultSet *rs = [db executeQuery:sqlStr];
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

        completeBlock(db, dataArray);
        [rs close];
    }];
}

//获取单条数据，返回一个对应的键值对
- (void)getColumnItem:(nullable NSString *)sqlStr withBlock:(nullable void(^)(FMDatabase *__nonnull, NSDictionary *__nullable))completeBlock {
    [self.queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:sqlStr];
        NSDictionary *columnNameToIndexMap = rs.columnNameToIndexMap;
        NSArray *columnNames = columnNameToIndexMap.allKeys;
        
        //一条数据
        NSMutableDictionary *columnItem = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        while ([rs next]) {
            for (NSString *columnName in columnNames) {
                //通过列名取单元格（
                columnItem[columnName] = [rs objectForColumnName:columnName];
            }
        }
        
        completeBlock(db, columnItem);
        [rs close];
    }];
}

//获取一个数据cell中的数据
- (void)getColumnValue:(nullable NSString *)sqlStr withBlock:(nullable void(^)(FMDatabase *__nonnull, id __nullable))completeBlock {
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sqlStr];
        
        id ret = @"";
        while ([rs next]) {
            ret = [rs objectForColumnIndex:0];
        }
        
        completeBlock(db, ret);
        [rs close];
    }];
}

/** 清空一张表 */
- (void)truncateTableWithQueue:(nullable NSString *)tableName {
    if(SBStringIsEmpty(tableName)){
        return;
    }
    
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM '%@'", tableName]];
        [db executeUpdate:[NSString stringWithFormat:@"UPDATE sqlite_sequence SET seq=0 WHERE name='%@'", tableName]];

    }];
}

/** 清理并压缩数据库 */
- (void)compressDBWithQueue {
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"VACUUM"];
    }];
}

@end
