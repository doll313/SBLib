/*
#####################################################################
# File    : DataAppDB.m
# Project : 
# Created : 2013-03-30
# DevTeam : Thomas Develop
# Author  : 
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

#import "DataAppDB.h"
#import "DataItemDetail.h"
#import "DataItemResult.h"

@implementation DataAppDB

@synthesize dbIntValueTable = _dbIntValueTable;
@synthesize dbStrValueTable = _dbStrValueTable;
@synthesize dbBinValueTable = _dbBinValueTable;

#pragma mark -
#pragma mark 生命周期
//确保每个派生类创建的数据库里都会包含三张表
- (void)createTables {
    _dbIntValueTable = @"DATA_INT_VALUE";
    _dbStrValueTable = @"DATA_STR_VALUE";
    _dbBinValueTable = @"DATA_BIN_VALUE";

    //创建数据表格   类型+关键字+值+日期
    NSString *_ddlIntTable = @"CREATE TABLE IF NOT EXISTS [DATA_INT_VALUE]([ID] INTEGER PRIMARY KEY, [DATA_TYPE] CHAR(100) NOT NULL,"
    @" [DATA_KEY] CHAR(200) NOT NULL, [DATA_VALUE] INTEGER,"
    @" [DATA_ADDTIME] TIMESTAMP NOT NULL DEFAULT (datetime(CURRENT_TIMESTAMP, 'localtime')));"
    @" CREATE UNIQUE INDEX [DATA_INT_VALUE_unique_key] ON [DATA_INT_VALUE] ([DATA_TYPE], [DATA_KEY]);";

    NSString *_ddlStrTable = @"CREATE TABLE IF NOT EXISTS [DATA_STR_VALUE]([ID] INTEGER PRIMARY KEY, [DATA_TYPE] CHAR(100) NOT NULL,"
    @" [DATA_KEY] CHAR(200) NOT NULL, [DATA_VALUE] TEXT,"
    @" [DATA_ADDTIME] TIMESTAMP NOT NULL DEFAULT (datetime(CURRENT_TIMESTAMP, 'localtime')));"
    @" CREATE UNIQUE INDEX [DATA_STR_VALUE_unique_key] ON [DATA_STR_VALUE] ([DATA_TYPE], [DATA_KEY]);";

    NSString *_ddlBinTable = @"CREATE TABLE IF NOT EXISTS [DATA_BIN_VALUE]([ID] INTEGER PRIMARY KEY, [DATA_TYPE] CHAR(100) NOT NULL,"
    @" [DATA_KEY] CHAR(200) NOT NULL, [DATA_VALUE] BLOB,"
    @" [DATA_ADDTIME] TIMESTAMP NOT NULL DEFAULT (datetime(CURRENT_TIMESTAMP, 'localtime')));"
    @" CREATE UNIQUE INDEX [DATA_BIN_VALUE_unique_key] ON [DATA_BIN_VALUE] ([DATA_TYPE], [DATA_KEY]);";
    
    [self.db executeUpdate:_ddlIntTable];
    [self.db executeUpdate:_ddlStrTable];
    [self.db executeUpdate:_ddlBinTable];
}

//初始化数据库
- (id)init:(NSString *)dbname {
    self = [super init:dbname];

    [self createTables];

    return self;
}

//更新一条数据库记录
- (int)updateData:(NSString *)tableName data:(NSDictionary *)data whereParam:(NSString *)whereParam {
    if (nil ==  tableName || SBStringIsEmpty(tableName) || nil == data || [data count] < 1) {
        return 0;
    }
    
    NSMutableString *_fieldsSql = [NSMutableString stringWithCapacity:0];
    
    for (NSString *key in [data allKeys]) {
        if ([key length] < 1) {
            continue;
        }
        
        if ([_fieldsSql length] > 0) {
            [_fieldsSql appendString:@","];
        }
        
        [_fieldsSql appendFormat:@"`%@`=?", key];
    }
    
    if ([_fieldsSql length] < 1) {
        return 0;
    }
    
    NSMutableString *updateSql = [NSMutableString stringWithCapacity:0];
    
    [updateSql appendFormat:@"update `%@` set %@", tableName, _fieldsSql];
    
    if (nil != whereParam || [whereParam length] > 0) {
        [updateSql appendFormat:@" where %@", whereParam];
    }
    
    return [self.db executeUpdate:updateSql];
}

#pragma mark -
#pragma mark 判断操作
//数据库中是否存在某个键值对
- (BOOL)hasTypeItem:(NSString *)tableName dataType:(NSString *)dataType dataKey:(NSString *)dataKey {
	if(SBStringIsEmpty(dataType)){
		return NO;
	}
    
    NSString *whereParam;
    if (SBStringIsEmpty(dataKey)) {
        whereParam = [NSString stringWithFormat:@"`DATA_TYPE`='%@'", dataType];
    } else {
        whereParam = [NSString stringWithFormat:@"`DATA_TYPE`='%@' and `DATA_KEY`='%@'", dataType, dataKey];
    }
    if (SBStringIsEmpty(tableName)) {
        return 0;
    }
    
    return [self tableRows:tableName whereParam:whereParam];
}

//数据库的 [DATA_INT_VALUE] 表中是否存在某个键值对
- (BOOL)hasIntItem:(NSString *)dataType dataKey:(NSString *)dataKey {
    return [self hasTypeItem:_dbIntValueTable dataType:dataType dataKey:dataKey];
}

//数据库的 [DATA_STR_VALUE] 表中是否存在某个键值对
- (BOOL)hasStrItem:(NSString *)dataType dataKey:(NSString *)dataKey {
    return [self hasTypeItem:_dbStrValueTable dataType:dataType dataKey:dataKey];
}

//数据库的 [DATA_BIN_VALUE] 表中是否存在某个键值对
- (BOOL)hasBinItem:(NSString *)dataType dataKey:(NSString *)dataKey {
    return [self hasTypeItem:_dbBinValueTable dataType:dataType dataKey:dataKey];
}

#pragma mark -
#pragma mark 删除操作
/** 清理表中的无效数据 */
- (BOOL)deleteTypeItem:(NSString *)tableName dataType:(NSString *)dataType dataKey:(NSString *)dataKey inSeconds:(NSInteger)seconds {
	if(SBStringIsEmpty(dataType) || SBStringIsEmpty(dataKey)){
		return NO;
	}
    
	NSMutableString *whereParam = [NSMutableString stringWithCapacity:0];
    
	[whereParam appendFormat:@"`DATA_TYPE`='%@'", dataType];
    
	if(dataKey.length > 0){
        [whereParam appendFormat:@" and `DATA_KEY`='%@'", dataKey];
        
	}
    
	if(seconds > 0){
		[whereParam appendString:@" and (`DATA_ADDTIME` > datetime('now','localtime')"];
		[whereParam appendFormat:@" or `DATA_ADDTIME` < datetime('now','localtime','-%@ seconds'))", @(seconds)];
	}
    
	NSString *SQL = [NSString stringWithFormat:@"delete from `%@` where %@", tableName, whereParam];
    
	return [self.db executeUpdate:SQL];
}

//删除指定表中符合条件的数据
- (int)deleteData:(NSString *)tableName whereParam:(NSString *)whereParam {
    if (SBStringIsEmpty(tableName)) {
        return 0;
    }
    
    NSMutableString *deleteSql = [NSMutableString stringWithCapacity:0];
    [deleteSql appendFormat:@"delete from `%@`", tableName];
    
    if (nil != whereParam || [whereParam length] > 0) {
        [deleteSql appendFormat:@" where %@", whereParam];
    }
    
    return [self.db executeUpdate:deleteSql];
}

//删除数据库中存在某个键值对
- (int)deleteTypeItem:(NSString *)tableName dataType:(NSString *)dataType dataKey:(NSString *)dataKey {
	if(SBStringIsEmpty(dataType)){
		return 0;
	}
    
    NSString *whereParam;
    
    if (SBStringIsEmpty(dataKey)) {
        whereParam = [NSString stringWithFormat:@"`DATA_TYPE`='%@'", dataType];
    } else {
        whereParam = [NSString stringWithFormat:@"`DATA_TYPE`='%@' and `DATA_KEY`='%@'", dataType, dataKey];
    }

	return [self deleteData:tableName whereParam:whereParam];
}

//清除 [TABLE_INT_VALUE] 表中的某类数据
- (int)deleteIntData:(NSString *)dataType {
	return [self deleteTypeItem:_dbIntValueTable dataType:dataType dataKey:nil];
}

//清除 [TABLE_STR_VALUE] 表中的某类数据
- (int)deleteStrData:(NSString *)dataType {
	return [self deleteTypeItem:_dbStrValueTable dataType:dataType dataKey:nil];
}

//清除 [TABLE_BIN_VALUE] 表中的某类数据
- (int)deleteBinData:(NSString *)dataType {
	return [self deleteTypeItem:_dbBinValueTable dataType:dataType dataKey:nil];
}

//删除一条整型数据
- (int)deleteIntValue:(NSString *)dataType dataKey:(NSString *)dataKey {
	return [self deleteTypeItem:_dbIntValueTable dataType:dataType dataKey:dataKey];
}
//删除一条整型数据
- (int)deleteIntValue:(NSString *)dataType dataKey:(NSString *)dataKey inSeconds:(NSInteger)seconds {
	return [self deleteTypeItem:_dbIntValueTable dataType:dataType dataKey:dataKey inSeconds:seconds];
}

//删除一条字符串数据
- (int)deleteStrValue:(NSString *)dataType dataKey:(NSString *)dataKey {
	return [self deleteTypeItem:_dbStrValueTable dataType:dataType dataKey:dataKey];
}

//删除一条字符串数据 时间段
- (int)deleteStrValue:(NSString *)dataType dataKey:(NSString *)dataKey inSeconds:(NSInteger)seconds {
    return [self deleteTypeItem:_dbStrValueTable dataType:dataType dataKey:dataKey inSeconds:seconds];
}

//删除一条二进制数据
- (int)deleteBinValue:(NSString *)dataType dataKey:(NSString *)dataKey {
	return [self deleteTypeItem:_dbBinValueTable dataType:dataType dataKey:dataKey];
}

//删除一条二进制数据 时间段
- (int)deleteBinValue:(NSString *)dataType dataKey:(NSString *)dataKey inSeconds:(NSInteger)seconds {
	return [self deleteTypeItem:_dbBinValueTable dataType:dataType dataKey:dataKey inSeconds:seconds];
}

/** 清空某类型数据在INT/BIN/STR三个表中的数据 */
- (void)deleteAllDataWithDataType:(NSString *)dataType {
    [self deleteBinData:dataType];
    [self deleteIntData:dataType];
    [self deleteStrData:dataType];
}

#pragma mark -
#pragma mark 修改操作
//刷新某条数据的添加时间
- (BOOL)refreshTypeTime:(NSString *)tableName dataType:(NSString *)dataType dataKey:(NSString *)dataKey {
	if(SBStringIsEmpty(tableName) || SBStringIsEmpty(dataType) || SBStringIsEmpty(dataKey)){
		return 0;
	}
    
    NSMutableString *SQL = [NSMutableString stringWithCapacity:0];
    
    [SQL appendFormat:@"update `%@` set `DATA_ADDTIME`=datetime(CURRENT_TIMESTAMP, 'localtime')", tableName];
    [SQL appendFormat:@" where `DATA_TYPE`='%@' and `DATA_KEY`='%@'", dataType, dataKey];
    
	return [self.db executeUpdate:SQL];
}

#pragma mark -
#pragma mark 插入操作
//设置条数据的值 
- (sqlite3_int64)setItemValue:(NSString *)tableName dataType:(NSString *)dataType dataKey:(NSString *)dataKey dataValue:(id)dataValue {
	if(SBStringIsEmpty(dataType) || SBStringIsEmpty(dataKey) || nil == dataValue){
		return 0;
	}
    
    sqlite3_int64 retVal = 0;
    NSString *whereParam = [NSString stringWithFormat:@"`DATA_TYPE`='%@' and `DATA_KEY`='%@'", dataType, dataKey];
    
    //如果对应类型和键名存在，则改动该值； 否则会插入新值。
	if([self tableRows:tableName whereParam:whereParam] > 0){
        NSString *updateSql = [NSString stringWithFormat:@"update `%@` set `DATA_VALUE`= ? where %@", tableName, whereParam];
        
        BOOL success = [self.db executeUpdate:updateSql, dataValue];
        if (success) {
            retVal = self.db.changes;
        }
		[self refreshTypeTime:tableName dataType:dataType dataKey:dataKey];
	}
    else {
        //sql 插入的语句
        NSString *insertSql = [NSString stringWithFormat:@"insert into `%@` (`DATA_TYPE`,`DATA_KEY`,`DATA_VALUE`) values (?,?,?)", tableName];
        BOOL success = [self.db executeUpdate:insertSql, dataType, dataKey, dataValue];
        if (success) {
            retVal = self.db.lastInsertRowId;
        }
	}
    
	return retVal;
}

//设置某条整型数据
- (sqlite3_int64)setIntValue:(NSString *)dataType dataKey:(NSString *)dataKey dataValue:(int)dataValue {
    return [self setItemValue:_dbIntValueTable dataType:dataType dataKey:dataKey dataValue:@(dataValue)];
}

//设置某条字符串数据
- (sqlite3_int64)setStrValue:(NSString *)dataType dataKey:(NSString *)dataKey dataValue:(NSString *)dataValue {
	if(nil == dataValue){
		return 0;
	}

    return [self setItemValue:_dbStrValueTable dataType:dataType dataKey:dataKey dataValue:dataValue];
}

//设置某条二进制数据
- (sqlite3_int64)setBinValue:(NSString *)dataType dataKey:(NSString *)dataKey dataValue:(NSData *)dataValue {
	if(nil == dataValue){
		return 0;
	}
    return [self setItemValue:_dbBinValueTable dataType:dataType dataKey:dataKey dataValue:dataValue];
}

#pragma mark -
#pragma mark 查询操作
//获取一条整型数据
- (int)getIntValue:(NSString *)dataType dataKey:(NSString *)dataKey {
    if(SBStringIsEmpty(dataType) || SBStringIsEmpty(dataKey)){
        return 0;
    }
    
    NSString *whereParam = [NSString stringWithFormat:@"`DATA_TYPE`='%@' and `DATA_KEY`='%@'", dataType, dataKey];
    NSString *SQL = [NSString stringWithFormat:@"select `DATA_VALUE` from `%@` where %@", _dbIntValueTable, whereParam];
    
    FMResultSet *s = [self.db executeQuery:SQL];
    if ([s next]) {
        return [s intForColumnIndex:0];
    }
    return 0;
}

//获取一条字符串数据
- (NSString *)getStrValue:(NSString *)dataType dataKey:(NSString *)dataKey {
    if(SBStringIsEmpty(dataType) || SBStringIsEmpty(dataKey)){
        return @"";
    }
    
    NSString *whereParam = [NSString stringWithFormat:@"`DATA_TYPE`='%@' and `DATA_KEY`='%@'", dataType, dataKey];
    NSString *SQL = [NSString stringWithFormat:@"select `DATA_VALUE` from `%@` where %@", _dbStrValueTable, whereParam];
    
    FMResultSet *s = [self.db executeQuery:SQL];
    if ([s next]) {
        return [s stringForColumnIndex:0];
    }
    return @"";
}

//获取一条二进制数据
- (NSData *)getBinValue:(NSString *)dataType dataKey:(NSString *)dataKey {
	if(SBStringIsEmpty(dataType) || SBStringIsEmpty(dataKey)){
		return nil;
	}

    NSString *whereParam = [NSString stringWithFormat:@"`DATA_TYPE`='%@' and `DATA_KEY`='%@'", dataType, dataKey];
    NSString *SQL = [NSString stringWithFormat:@"select `DATA_VALUE` from `%@` where %@", _dbBinValueTable, whereParam];
    
    FMResultSet *s = [self.db executeQuery:SQL];
    if ([s next]) {
        return [s dataForColumnIndex:0];
    }
    return nil;
}

//获取 TABLE_BIN_VALUE 表中指定数据的总大小
- (long)getBinSize:(NSString *)dataType dataKey:(NSString *)dataKey {
    NSMutableString *SQL = [NSMutableString stringWithCapacity:0];

    [SQL appendFormat:@"select length(`DATA_VALUE`),length(`DATA_TYPE`),length(`DATA_VALUE`),length(`DATA_KEY`) from `%@`", _dbBinValueTable];
    if (dataType.length != 0) {
        [SQL appendFormat:@" where `DATA_TYPE`='%@'", dataType];
    }
    if (nil != dataKey && [dataKey length] > 0) {
        [SQL appendFormat:@" and `DATA_KEY`='%@'", dataKey];
    }
    
    long result = 0;
    FMResultSet *s = [self.db executeQuery:SQL];
    // 每条记录的检索值
    while ([s next]) {
        result += [s intForColumnIndex:0];
    }

	return result;
}

#pragma mark -
#pragma mark 对于额外的，自定义数据的操作
//从数据库缓存中读取 DataItemDetail 数据结构，如果不存在则返回 nil
- (DataItemDetail *)getDetailValue:(NSString *)dataType dataKey:(NSString *)dataKey {
	if(SBStringIsEmpty(dataKey)){
		return nil;
	}
    
    NSData *data = [self getBinValue:dataType dataKey:[NSString stringWithFormat:@"item.%@", dataKey]];
    
	if(nil == data){
		return nil;
	}
    
	return [DataItemDetail FromData:data];
}

//保存 DataItemDetail 结构的数据到数据库缓存中
- (BOOL)setDetailValue:(NSString *)dataType dataKey:(NSString *)dataKey data:(DataItemDetail *)data {
	if(SBStringIsEmpty(dataKey) || nil == data){
		return NO;
	}
    
	return [self setBinValue:dataType dataKey:[NSString stringWithFormat:@"item.%@", dataKey] dataValue:[data toData]] > 0;
}

//清除DataItemDetail缓存
- (int)deleteDetailValue:(NSString *)dataType dataKey:(NSString *)dataKey {
	return [self deleteBinValue:dataType dataKey:[NSString stringWithFormat:@"item.%@", dataKey]];
}

//清除DataItemDetail缓存
- (int)deleteDetailValue:(NSString *)dataType dataKey:(NSString *)dataKey inSeconds:(NSInteger)seconds{
	return [self deleteBinValue:dataType dataKey:[NSString stringWithFormat:@"item.%@", dataKey] inSeconds:seconds];
}

//从数据库缓存中读取 DataItemResult 数据结构，如果不存在则返回 nil
- (DataItemResult *)getResultValue:(NSString *)dataType dataKey:(NSString *)dataKey {
	if(SBStringIsEmpty(dataKey)){
		return nil;
	}
    
    NSData *data = [self getBinValue:dataType dataKey:[NSString stringWithFormat:@"items.%@", dataKey]];
    
	if(nil == data){
		return nil;
	}
    
	return [DataItemResult FromData:data];
}

//保存 DataItemResult 结构的数据到数据库缓存中
- (BOOL)setResultValue:(NSString *)dataType dataKey:(NSString *)dataKey data:(DataItemResult *)data {
	if(SBStringIsEmpty(dataKey) || nil == data){
		return NO;
	}
    
	return [self setBinValue:dataType dataKey:[NSString stringWithFormat:@"items.%@", dataKey] dataValue:[data toData]] > 0;
}

//清除DataItemResult缓存
- (int)deleteResultValue:(NSString *)dataType dataKey:(NSString *)dataKey {
	return [self deleteBinValue:dataType dataKey:[NSString stringWithFormat:@"items.%@", dataKey]];
}

//清除DataItemResult缓存 
- (int)deleteResultValue:(NSString *)dataType dataKey:(NSString *)dataKey inSeconds:(NSInteger)seconds{
	return [self deleteBinValue:dataType dataKey:[NSString stringWithFormat:@"items.%@", dataKey] inSeconds:seconds];
}


@end
