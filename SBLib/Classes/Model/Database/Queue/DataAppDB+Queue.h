//
//  DataAppDB+Queue.h
//  IosSqlTest
//
//  Created by MengWang on 16/8/15.
//  Copyright © 2016年 YukiWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataAppDB (sb_queue)

//清除 [TABLE_INT_VALUE] 表中的某类数据
- (void)deleteIntDataWithQueue:(nullable NSString *)dataType withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock;

//清除 [TABLE_STR_VALUE] 表中的某类数据
- (void)deleteStrDataWithQueue:(nullable NSString *)dataType withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock;

//清除 [TABLE_BIN_VALUE] 表中的某类数据
- (void)deleteBinDataWithQueue:(nullable NSString *)dataType withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock;

//删除一条整型数据
- (void)deleteIntValueWithQueue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock;

//删除一条字符串数据
- (void)deleteStrValueWithQueue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock;

//删除一条二进制数据
- (void)deleteBinValueWithQueue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock;

//清除DataItemDetail缓存
- (void)deleteDetailValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock;

//清除DataItemResult缓存
- (void)deleteResultValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock;

//删除一条整型数据 时间段
- (void)deleteIntValueWithQueue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey inSeconds:(NSInteger)seconds withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock;

//删除一条字符串数据 时间段
- (void)deleteStrValueWithQueue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey inSeconds:(NSInteger)seconds withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock;

//删除一条二进制数据 时间段
- (void)deleteBinValueWithQueue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey inSeconds:(NSInteger)seconds withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock;

//清除DataItemDetail缓存 时间段
- (void)deleteDetailValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey inSeconds:(NSInteger)seconds withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock;

//清除DataItemResult缓存 时间段
- (void)deleteResultValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey inSeconds:(NSInteger)seconds withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock;

// 清空某类型数据在INT/BIN/STR三个表中的数据
- (void)deleteAllDataWithDataTypeWithQueue:(nullable NSString *)dataType withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock;


//设置某条整型数据
- (void)setIntValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey dataValue:(NSInteger)dataValue withBlock:(nullable void(^)(FMDatabase *__nonnull, sqlite3_int64 retVal))completeBlock;

//设置某条字符串数据
- (void)setStrValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey dataValue:(nullable NSString *)dataValue withBlock:(nullable void(^)(FMDatabase *__nonnull, sqlite3_int64 retVal))completeBlock;

//设置某条二进制数据
- (void)setBinValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey dataValue:(nullable NSData *)dataValue withBlock:(nullable void(^)(FMDatabase *__nonnull, sqlite3_int64 retVal))completeBlock;

//保存 DataItemDetail 结构的数据到数据库缓存中
- (void)setDetailValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey data:(nullable DataItemDetail *)data withBlock:(nullable void(^)(FMDatabase *__nonnull, sqlite3_int64 retVal))completeBlock;

//保存 DataItemResult 结构的数据到数据库缓存中
- (void)setResultValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey data:(nullable DataItemResult *)data withBlock:(nullable void(^)(FMDatabase *__nonnull, sqlite3_int64 retVal))completeBlock;


//获取一条整型数据
- (void)getIntValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, NSInteger intValue))completeBlock;

//获取一条字符串数据
- (void)getStrValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, NSString * __nullable))completeBlock;

//获取一条二进制数据
- (void)getBinValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, NSData * __nullable))completeBlock;

//获取 TABLE_BIN_VALUE 表中指定数据的总大小
- (void)getBinSize:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, long dataSize))completeBlock;

//从数据库缓存中读取 DataItemDetail 数据结构，如果不存在则返回 nil
- (void)getDetailValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, DataItemDetail * __nullable))completeBlock;

//从数据库缓存中读取 DataItemResult 数据结构，如果不存在则返回 nil
- (void)getResultValue:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, DataItemResult * __nullable))completeBlock;


//数据库的 [DATA_INT_VALUE] 表中是否存在某个键值对
- (void)hasIntItem:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock;

//数据库的 [DATA_STR_VALUE] 表中是否存在某个键值对
- (void)hasStrItem:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock;

//数据库的 [DATA_BIN_VALUE] 表中是否存在某个键值对
- (void)hasBinItem:(nullable NSString *)dataType dataKey:(nullable NSString *)dataKey withBlock:(nullable void(^)(FMDatabase *__nonnull, BOOL success))completeBlock;


//获取列表数据，返回一个数据键值对的数组
- (void)getAllDBData:(nullable NSString *)sqlStr withBlock:(nullable void(^)(FMDatabase *__nonnull, NSArray *__nullable))completeBlock;

//获取单条数据，返回一个对应的键值对
- (void)getColumnItem:(nullable NSString *)sqlStr withBlock:(nullable void(^)(FMDatabase *__nonnull, NSDictionary *__nullable))completeBlock;

//获取一个数据cell中的数据
- (void)getColumnValue:(nullable NSString *)sqlStr withBlock:(nullable void(^)(FMDatabase *__nonnull, id __nullable))completeBlock;


/** 清空一张表 */
- (void)truncateTableWithQueue:(nullable NSString *)tableName;

/** 清理并压缩数据库 */
- (void)compressDBWithQueue;

@end
