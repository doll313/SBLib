/*
#####################################################################
# File    : DataItemDetail.h
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

#import <UIKit/UIKit.h>
#import "NSString+SBMODULE.h"

/*
 *   1. 单条数据容器
 *   2. 支持序列化和反序列化
 *   3. 警告：请勿轻易改动序列化和反序列化的机制，否则会引发数据不兼容的后果。
 */
@interface DataItemDetail : NSObject <NSCoding,NSCopying> {
@private
}

@property (nonatomic, strong) NSMutableDictionary *dictData;     //数据
@property (nonatomic, strong) NSMutableDictionary *attributeData;     //富文本数据 （不能反序列化）

/**
 快速创建一个数据容器，推荐使用这个来初始化 
 (过时)，请使用[DataItemDetail new]来初始化
 */
+ (DataItemDetail *)detail;

/**
 从NSDictionary初始化
 如果dictionary里面有子dict，则子dict会变成DataItemDetail
 其他类型都以原本的形式加入detail
 
 @param dict dict
 
 @return detail
 */
+ (DataItemDetail *)detailFromDictionary:(NSDictionary *)dict;

/** 往当前数据容器的后端追加另一个数据容器所有的数据 */
- (void)appendItems:(DataItemDetail *)detail;

/** 追加数据 并忽略部分key */
- (void)appendItems:(DataItemDetail *)detail igoreKeys:(NSArray<NSString *> *)igoreKeys;

/** 设定数组 */
- (BOOL)setArray:(NSArray *)array forKey:(NSString *)aKey;

/** 获取数组 */
- (NSArray *)getArray:(NSString *)key;

/** 设定字符串值 */
- (BOOL)setString:(NSString *)value forKey:(NSString *)key;

/** 获取字符串值 */
- (NSString *)getString:(NSString *)key;

/** 设定int值 */
- (BOOL)setInt:(NSInteger)value forKey:(NSString *)key;

/** 获取int值 */
- (NSInteger)getInt:(NSString *)key;

/** 设定long值 */
- (BOOL)setLongLong:(long long)value forKey:(NSString *)key;

/** 获取long值 */
- (long long)getLongLong:(NSString *)key;

/** 设定float值 */
- (BOOL)setFloat:(float)value forKey:(NSString *)key;

/** 获取float值 */
- (float)getFloat:(NSString *)key;

/** 设定布尔值 */
- (BOOL)setBool:(BOOL)value forKey:(NSString *)key;

/** 获取布尔值 */
- (BOOL)getBool:(NSString *)key;

/** 设定流数据 */
- (BOOL)setBin:(NSData *)value forKey:(NSString *)key;

/** 获取流数据 */
- (NSData *)getBin:(NSString *)key;

/** 设置一个数据模型 */
- (BOOL)setDetail:(DataItemDetail *)detail forKey:(NSString *)key;

/** 获取数据模型变量 */
- (DataItemDetail *)getDetail:(NSString *)key;

/** 通用设定一个数据，一般为自定义类变量 */
- (BOOL)setObject:(NSObject *)object forKey:(NSString *)key;

/** 获取流自定义类变量 */
- (NSObject *)getObject:(NSString *)key;

/** 设定属性字符串值 */
- (BOOL)setATTString:(NSAttributedString *)value forKey:(NSString *)key;

/** 获取属性字符串值 */
- (NSAttributedString *)getATTString:(NSString *)key;

/** 设定属性色值 */
- (BOOL)setColor:(UIColor *)color forKey:(NSString *)key;

/** 属性色值 */
- (UIColor *)getColor:(NSString *)key;

/** 设定数字值 */
- (BOOL)setNumber:(NSNumber *)number forKey:(NSString *)key;

/** 数字值 */
- (NSNumber *)getNumber:(NSString *)key;

/** 删除一项 **/
- (BOOL)removeObject:(NSString *)key;

/** 键值对总数 */
- (NSUInteger)count;

/** 是否存在键值对 */
- (BOOL)hasKey:(NSString *)key;

/** 是否存在匹配的键值对 */
- (BOOL)hasKey:(NSString *)key withValue:(NSString *)value;

/** 把key1的数据映射到 key2 */
- (BOOL)mapValue:(NSString *)key1 withKey2:(NSString *)key2;

/** 数据映射到 另一个key */
- (BOOL)mapValues:(NSDictionary<NSString *, NSString *> *)mapKeys;

/** 清除所有元素 */
- (void)clear;

/** 调试接口，在console中打印出当前对象包含的元素 */
- (void)dump;

/** 调试接口，返回内部元素的数据 */
- (NSString *)whatInThis;

/** 当前对象序列化到NSData数据流中 */
- (NSData *)toData;

/** 从NSData数据流中反序列化出一个 DataItemDetail 对象 */
+ (id)FromData:(NSData*)data;

@end
