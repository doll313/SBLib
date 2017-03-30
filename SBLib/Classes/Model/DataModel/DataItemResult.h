/*
#####################################################################
# File    : DataItemResult.h
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

#import "DataItemDetail.h"

/**
 *   1. 列表数据容器
 *   2. 支持序列化和反序列化
 *   3. 警告：请勿轻易改动序列化和反序列化的机制，否则会引发数据不兼容的后果。
 */
@interface DataItemResult : NSObject <NSCoding> {
}

@property (assign, nonatomic) NSUInteger maxCount; //列表中数据元素的个数 （可能是还没有获取到的，一般来自网络）
@property (assign, nonatomic) NSInteger statusCode;   //返回的状态码（网络中会返回这个数据）
@property (assign, nonatomic) BOOL hasError;        //出错标志位（网络给的数据出错了）
@property (assign, nonatomic) BOOL localError;     //提示信息（本地给的）貌似一直页不怎么用
@property (nonatomic, copy) NSString *message;     //提示信息（网络给的）
@property (strong, nonatomic) DataItemDetail *resultInfo;        //数据解释信息 （一般也只有网络数据才有）
@property (strong, nonatomic) NSMutableArray *dataList;         //列表信息
@property (nonatomic, copy) NSString *itemUniqueKeyName;  //数据的唯一标识
@property (retain, nonatomic) NSData *rawData;              //对应的网络原始数据 （如果有）

/** 获取一份和另一个result一模一样的拷贝 */
+ (DataItemResult *)resultFromAnother:(DataItemResult *)result;

/** 获取当前节点数 */
- (NSUInteger)count;

/** 添加一个节点 */
- (void)addItem:(DataItemDetail *)item;

/** 添加一个节点 在某个位置*/
- (void)insertItem:(DataItemDetail *)item atIndex:(NSInteger)index;

/** 替换一个节点 在某个位置*/
- (BOOL)replaceItem:(DataItemDetail *)item atIndex:(NSInteger)index;

/** 往当前列表容器的后端追加另一个列表容器所有的数据 */
- (void)appendItems:(DataItemResult *)items;

/** 设定当前主键 */
- (void)setItemUniqueKeyName:(NSString *)key;

/** 是否是一个有效的列表数据 */
- (BOOL)isValidListData;

/** 把所有元素的指定键名的值都置成指定字符串值 */
- (BOOL)setAllItemsKey:(NSString *)key withString:(NSString *)value;

/** 把所有元素的指定键名的值都置成布尔值 */
- (BOOL)setAllItemsKey:(NSString *)key withBool:(BOOL)value;

/** 把所有元素的指定键名的值都置成浮点数值 */
- (BOOL)setAllItemsKey:(NSString *)key withFloat:(CGFloat)value;

/** 把所有元素的指定键名的值都置成整数型值 */
- (BOOL)setAllItemsKey:(NSString *)key withInt:(NSInteger)value;

/** 获取指定键名对应的元素队列 */
- (NSArray *)arrayForKey:(NSString *)key;

/** 清除所有元素，不包括数据适配器容器中的数据 */
- (void)clear;

/** 删除所有对象 */
- (void)removeItems;

/** 删除一个对象 */
- (void)removeItem:(DataItemDetail *)item;

/** 获得指定位置 (index) 的 DataItemDetail 对象 */
- (DataItemDetail *)getItem:(NSUInteger)index;

/** 获得最后个item */
- (DataItemDetail *)getLastItem;

/** 调试接口，在console中打印出当前对象包含的元素 */
- (void)dump;

/** 调试接口 */
- (NSString *)whatInThis;

/** 当前对象序列化到NSData数据流中 */
- (NSData *)toData;

/** 从NSData数据流中反序列化出一个 DataItemResult 对象 */
+ (DataItemResult *)FromData:(NSData*)data;

@end
