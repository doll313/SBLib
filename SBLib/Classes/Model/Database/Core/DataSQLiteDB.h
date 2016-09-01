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

#import "FMDB.h"
#import <sqlite3.h>

/**
 *   1.该类用于操作SQLite数据库。
 *   2.该类已封装了一些基本的SQLite操作方法，包括执行SQL语句；使用绑定变量；查、增、删、改数据记录等。
 */
@interface DataSQLiteDB : NSObject

@property (nonatomic, strong) FMDatabase *db;         //fmdb
@property (nonatomic, copy) NSString *dbpath;           //数据库路径
@property (nonatomic, strong)FMDatabaseQueue *queue;



/** 初始化数据库，不存在则创建 */
- (id)init:(NSString *)dbname;

/** 获取指定表中符合条件的数据条数 */
- (sqlite3_int64)tableRows:(NSString *)tableName whereParam:(NSString *)whereParam;

/** 获取列表数据，返回一个数据键值对的数组 */
- (NSArray *)getAllDBData:(NSString *)SQL;

/** 获取单条数据，返回一个对应的键值对 */
- (NSDictionary *)getColumnItem:(NSString *)SQL;

//获取一个数据cell中的数据
- (id)getColumnValue:(NSString *)sqlStr;

/** 判断数据库中是否存在某张表 */
- (BOOL)hasTable:(NSString *)tableName;

/** 关闭数据库 */
- (void)closeDB;

/** 清空一张表 */
- (void)truncateTable:(NSString *)tableName;

/** 清理并压缩数据库 */
- (void)compressDB;

@end
