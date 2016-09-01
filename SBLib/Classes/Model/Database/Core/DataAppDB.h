/*
#####################################################################
# File    : DataAppDB.h
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

// 数据库用到的常量
#define APPCONFIG_DB_CACHE_NAME             @"CacheData.db"       // 缓存数据库名
#define APPCONFIG_DB_CORE_NAME              @"CoreData.db"        // 核心数据库名
#define APPCONFIG_DB_DICT_NAME              @"DictData.db"        // 字典数据库名

@class DataItemDetail;
@class DataItemResult;

/**
 *   1.该类操作数据库，应用于数据永久化存储。
 *   2.该类定义了数据库的基本表结构，并实现对应数据类型存、取、删、改的方法。
 */
@interface DataAppDB : DataSQLiteDB {
@protected
	NSString *_dbIntValueTable;          //存储数字型的数据表
	NSString *_dbStrValueTable;          //存储字符串型的数据表
	NSString *_dbBinValueTable;          //存储数据型的数据表
}

@property (readonly) NSString *dbIntValueTable;
@property (readonly) NSString *dbStrValueTable;
@property (readonly) NSString *dbBinValueTable;

//初始化数据库
- (id)init:(NSString *)dbname;

//确保每个派生类创建的数据库里都会包含三张表
- (void)createTables;

//数据库的 [DATA_INT_VALUE] 表中是否存在某个键值对
- (BOOL)hasIntItem:(NSString *)dataType dataKey:(NSString *)dataKey;

//数据库的 [DATA_STR_VALUE] 表中是否存在某个键值对
- (BOOL)hasStrItem:(NSString *)dataType dataKey:(NSString *)dataKey;

//数据库的 [DATA_BIN_VALUE] 表中是否存在某个键值对
- (BOOL)hasBinItem:(NSString *)dataType dataKey:(NSString *)dataKey;

//清除 [TABLE_INT_VALUE] 表中的某类数据
- (int)deleteIntData:(NSString *)dataType;

//清除 [TABLE_STR_VALUE] 表中的某类数据
- (int)deleteStrData:(NSString *)dataType;

//清除 [TABLE_BIN_VALUE] 表中的某类数据
- (int)deleteBinData:(NSString *)dataType;

//删除一条整型数据
- (int)deleteIntValue:(NSString *)dataType dataKey:(NSString *)dataKey;

//删除一条整型数据
- (int)deleteIntValue:(NSString *)dataType dataKey:(NSString *)dataKey inSeconds:(NSInteger)seconds;

//删除一条字符串数据
- (int)deleteStrValue:(NSString *)dataType dataKey:(NSString *)dataKey;

//删除一条字符串数据 时间段
- (int)deleteStrValue:(NSString *)dataType dataKey:(NSString *)dataKey inSeconds:(NSInteger)seconds;

//删除一条二进制数据
- (int)deleteBinValue:(NSString *)dataType dataKey:(NSString *)dataKey;

//删除一条二进制数据 时间段
- (int)deleteBinValue:(NSString *)dataType dataKey:(NSString *)dataKey inSeconds:(NSInteger)seconds;

/** 清空某类型数据在INT/BIN/STR三个表中的数据 */
- (void)deleteAllDataWithDataType:(NSString *)dataType;

//刷新某条数据的添加时间
- (BOOL)refreshTypeTime:(NSString *)tableName dataType:(NSString *)dataType dataKey:(NSString *)dataKey;

//设置某条整型数据
- (sqlite3_int64)setIntValue:(NSString *)dataType dataKey:(NSString *)dataKey dataValue:(int)dataValue;

//设置某条字符串数据
- (sqlite3_int64)setStrValue:(NSString *)dataType dataKey:(NSString *)dataKey dataValue:(NSString *)dataValue;

//设置某条二进制数据
- (sqlite3_int64)setBinValue:(NSString *)dataType dataKey:(NSString *)dataKey dataValue:(NSData *)dataValue;

//获取一条整型数据
- (int)getIntValue:(NSString *)dataType dataKey:(NSString *)dataKey;

//获取一条字符串数据
- (NSString *)getStrValue:(NSString *)dataType dataKey:(NSString *)dataKey;

//获取一条二进制数据
- (NSData *)getBinValue:(NSString *)dataType dataKey:(NSString *)dataKey;

// 从数据库缓存中读取 DataItemDetail 数据结构，如果不存在则返回 nil
- (DataItemDetail *)getDetailValue:(NSString *)dataType dataKey:(NSString *)dataKey;

// 保存 DataItemDetail 结构的数据到数据库缓存中
- (BOOL)setDetailValue:(NSString *)dataType dataKey:(NSString *)dataKey data:(DataItemDetail *)data;

/** 清除DataItemDetail缓存 */
- (int)deleteDetailValue:(NSString *)dataType dataKey:(NSString *)dataKey;

/** 清除DataItemDetail缓存 */
- (int)deleteDetailValue:(NSString *)dataType dataKey:(NSString *)dataKey inSeconds:(NSInteger)seconds;

// 从数据库缓存中读取 DataItemResult 数据结构，如果不存在则返回 nil
- (DataItemResult *)getResultValue:(NSString *)dataType dataKey:(NSString *)dataKey;

// 保存 DataItemResult 结构的数据到数据库缓存中
- (BOOL)setResultValue:(NSString *)dataType dataKey:(NSString *)dataKey data:(DataItemResult *)data;

/** 清除DataItemResult缓存 */
- (int)deleteResultValue:(NSString *)dataType dataKey:(NSString *)dataKey;

//清除DataItemResult缓存
- (int)deleteResultValue:(NSString *)dataType dataKey:(NSString *)dataKey inSeconds:(NSInteger)seconds;

@end
