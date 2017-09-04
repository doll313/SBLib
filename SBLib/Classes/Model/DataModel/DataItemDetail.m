/*
 #####################################################################
 # File    : DataItemDetail.m
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

static int _data_item_detail_count = 0;
static BOOL _data_item_detail_malloc = 0;

@implementation DataItemDetail

#pragma mark -
#pragma mark 生命周期
//初始化
- (id)init {
    self = [super init];
    
    if (nil != self) {
        self.dictData = [[NSMutableDictionary alloc] init];
        self.attributeData = [[NSMutableDictionary alloc] init];
    }
    
    //调试数据内存
    _data_item_detail_malloc = [[NSUserDefaults standardUserDefaults] boolForKey:DEBUG_MALLOC_FOR_DATA_ITEM];
    if (_data_item_detail_malloc) {
        NSLog(@"data-item-detail-count[init]: %d", ++_data_item_detail_count);
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    DataItemDetail *itemCopy = [[DataItemDetail allocWithZone:zone]init];
    itemCopy.dictData = [self.dictData mutableCopy];
    itemCopy.attributeData = [self.attributeData mutableCopy];
    return itemCopy;
}

+ (DataItemDetail *)detailFromDictionary:(NSDictionary *)dict {
    DataItemDetail *detail = [[DataItemDetail alloc] init];
    if (SBDictionaryIsEmpty(dict)) {
        return detail;
    }

    //
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            DataItemDetail *subDetail = [DataItemDetail detailFromDictionary:obj];
            [detail setObject:subDetail forKey:key];
        }else if((NSNull *)obj != [NSNull null]){
            // 如果是NSNull，则不加入，以防崩溃
            [detail setObject:obj forKey:key];
        }
    }];
    return detail;
}

// 销毁时释放资源
- (void)dealloc {
    if (_data_item_detail_malloc) {
        NSLog(@"data-item-detail-count[dealloc]: %d", --_data_item_detail_count);
    }
    
#if !__has_feature(objc_arc)
    [self.attributeData release];
    [self.dictData release];
    [super dealloc];
#endif
}

//快速创建一个数据容器，推荐使用这个来初始化
+ (DataItemDetail *)detail {
    return [[DataItemDetail alloc] init];
}

/** 往当前数据容器的后端追加另一个数据容器所有的数据 */
- (void)appendItems:(DataItemDetail *)detail {
    [self appendItems:detail igoreKeys:nil];
}


/** 追加数据 并忽略部分key */
- (void)appendItems:(DataItemDetail *)detail igoreKeys:(NSArray<NSString *> *)igoreKeys {

    //数据不合法
    if (detail == nil) {
        return;
    }

    for (NSString *key in detail.dictData.allKeys) {
        if (![igoreKeys containsObject:key]) {
            NSObject *object = [detail getObject:key];
            [self setObject:object forKey:key];
        }
    }

    for (NSString *key in detail.attributeData.allKeys) {
        if (![igoreKeys containsObject:key]) {
            NSAttributedString *object = [detail getATTString:key];
            [self setATTString:object forKey:key];
        }
    }
}

#pragma mark -
#pragma mark 读取设置方法
//设置数组
- (BOOL)setArray:(NSArray *)array forKey:(NSString *)key {
    return [self setObject:array forKey:key];
}

/** 设定字符串值 */
- (BOOL)setString:(NSString *)value forKey:(NSString *)key {
    return [self setObject:value forKey:key];
}

/** 设定int值 */
- (BOOL)setInt:(NSInteger)value forKey:(NSString *)key {
    NSNumber *number = [NSNumber numberWithInteger:value];
    return [self setObject:number forKey:key];
}

/** 设定long值 */
- (BOOL)setLongLong:(long long)value forKey:(NSString *)key {
    NSNumber *number = [NSNumber numberWithLongLong:value];
    return [self setObject:number forKey:key];
}


/** 设定float值 */
- (BOOL)setFloat:(float)value forKey:(NSString *)key {
    NSNumber *number = [NSNumber numberWithFloat:value];
    return [self setObject:number forKey:key];
}

/** 设定布尔值 */
- (BOOL)setBool:(BOOL)value forKey:(NSString *)key {
    NSNumber *number = [NSNumber numberWithBool:value];
    return [self setObject:number forKey:key];
}

/** 设定流数据 */
- (BOOL)setBin:(NSData *)value forKey:(NSString *)key {
    return [self setObject:value forKey:key];
}

/** 设置一个数据模型 */
- (BOOL)setDetail:(DataItemDetail *)detail forKey:(NSString *)key {
    return [self setObject:detail forKey:key];
}

/** 设定属性色值 */
- (BOOL)setColor:(UIColor *)color forKey:(NSString *)key {
    NSString *colorString = [NSString fromColor:color];
    [self setString:colorString forKey:key];
    
    return YES;
}

/** 设定数字值 */
- (BOOL)setNumber:(NSNumber *)number forKey:(NSString *)key {
    return [self setObject:number forKey:key];
}

- (BOOL)setObject:(NSObject *)object forKey:(NSString *)key {
    if (object == nil || key == nil) {
        return NO;
    }
    if ([object isKindOfClass:[NSNull class]]) {
        return NO;
    }
    
    self.dictData[key.lowercaseString] = object;
    return YES;
}

/**************** 设置与获取分割线   ******************/

- (NSArray *)getArray:(NSString *)key {
    NSArray *value = (NSArray *)[self getObject:key];
    if (value && [value isKindOfClass:[NSArray class]]) {
        return value;
    }
    
    return [NSArray array];
}

//获取字符串
- (NSString *)getString:(NSString *)key {
    NSString *value = (NSString *)[self getObject:key];
    
    if (!value) {
        return @"";
    }
    
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@", value];
    }
    
    return @"";
}

/** 获取int值 */
- (NSInteger)getInt:(NSString *)key {
    NSNumber *value = (NSNumber *)[self getObject:key];
    if (value && ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])) {
        return [value intValue];
    }
    
    return 0;
}

/** 获取long值 */
- (long long)getLongLong:(NSString *)key {
    NSNumber *value = (NSNumber *)[self getObject:key];
    if (value && ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])) {
        return [value longLongValue];
    }

    return 0;
}

/** 获取float值 */
- (float)getFloat:(NSString *)key {
    NSNumber *value = (NSNumber *)[self getObject:key];
    if (value && ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])) {
        return [value floatValue];
    }
    return 0;
}

/** 获取布尔值 */
- (BOOL)getBool:(NSString *)key {
    NSNumber *value = (NSNumber *)[self getObject:key];
    if (nil == value) {
        return NO;
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    }
    
    if ([value isKindOfClass:[NSString class]]) {
        
        NSString *stringValue = (NSString *)value;
        stringValue = [stringValue lowercaseString];
        
        if ([stringValue isEqualToString:@"y"] ||
            [stringValue isEqualToString:@"on"] ||
            [stringValue isEqualToString:@"yes"] ||
            [stringValue isEqualToString:@"true"]) {
            return YES;
        }
        
        int intValue = [value intValue];
        if (intValue != 0) {
            return YES;
        }
    }
    
    return [value boolValue];
}

/** 获取流数据 */
- (NSData *)getBin:(NSString *)key {
    NSData *value = (NSData *)[self getObject:key];
    if (value && [value isKindOfClass:[NSData class]]) {
        return value;
    }
    
    return [NSData data];
}

/** 获取数据模型变量 */
- (DataItemDetail *)getDetail:(NSString *)key {
    DataItemDetail *value = (DataItemDetail *)[self getObject:key];
    if (value && [value isKindOfClass:[DataItemDetail class]]) {
        return value;
    }
    return [DataItemDetail detail];
}

/** 属性色值 */
- (UIColor *)getColor:(NSString *)key {
    NSString *colorString = [self getString:key];
    if (colorString.length > 0) {
        return [colorString toColor];
    }else {
        return [UIColor clearColor];
    }
}

/** 数字值 */
- (NSNumber *)getNumber:(NSString *)key {
    NSNumber *value = (NSNumber *)[self getObject:key];
    if (value && [value isKindOfClass:[NSNumber class]]) {
        return value;
    }
    else if (value && [value isKindOfClass:[NSString class]]) {
        return @([value integerValue]);
    }
    return @(0);
}

- (NSObject *)getObject:(NSString *)key {
    if (SBStringIsEmpty(key)) {
        return nil;
    }
    return [self objectForCaseInsensitiveKey:key.lowercaseString];
}

//无视大小写
- (id)objectForCaseInsensitiveKey:(NSString *)key {
    NSArray *allKeys = [self.dictData allKeys];
    for (NSString *str in allKeys) {
        if ([key caseInsensitiveCompare:str] == NSOrderedSame) {
            return [self.dictData objectForKey:str];
        }
    }
    return nil;
}

/** 设定属性字符串值 */
- (BOOL)setATTString:(NSAttributedString *)value forKey:(NSString *)key {
    if (value) {
        [self.attributeData setObject:value forKey:key.lowercaseString];
        return YES;
    }
    return NO;
}

/** 获取属性字符串值 */
- (NSAttributedString *)getATTString:(NSString *)key {
    NSObject *value = [self.attributeData objectForKey:key.lowercaseString];
    if (value && [value isKindOfClass:[NSAttributedString class]]) {
        return (NSAttributedString *)value;
    }

    return [[NSAttributedString alloc] initWithString:@""];
}

/** 删除一项 **/
- (BOOL)removeObject:(NSString *)key {
    if (SBStringIsEmpty(key)) {
        return NO;
    }
    [self.dictData removeObjectForKey:key.lowercaseString];
    return YES;
}

#pragma mark -
#pragma mark 其他方法
/** 键值对总数 */
- (NSUInteger)count {
    if (nil == self.dictData) {
        return 0;
    }
    
    return [self.dictData count] + [self.attributeData count];
}

/** 是否存在键值对 */
- (BOOL)hasKey:(NSString *)key {
    if (nil == self.dictData || nil == key) {
        return NO;
    }
    
    if (self.dictData[key.lowercaseString]) {
        return YES;
    }

    if (self.attributeData[key.lowercaseString]) {
        return YES;
    }
    
    return NO;
}

/** 是否存在匹配的键值对 */
- (BOOL)hasKey:(NSString *)key withValue:(NSString *)value {
    if (nil == self.dictData || nil == key || nil == value) {
        return NO;
    }
    
    NSString *tmpValue = self.dictData[key.lowercaseString];
    
    if (nil == tmpValue) {
        return NO;
    }
    
    if (![tmpValue isEqualToString:value]) {
        return NO;
    }
    
    return YES;
}

/** 把key1的数据映射到 key2 */
- (BOOL)mapValue:(NSString *)key1 withKey2:(NSString *)key2 {
    NSObject *obj = [self getObject:key1];
    if (obj != nil) {
        return [self setObject:obj forKey:key2];
    }
    return NO;
}


/** 数据映射到 另一个key */
- (BOOL)mapValues:(NSDictionary<NSString *, NSString *> *)mapKeys {
    BOOL success = NO;
    for (NSString *key in mapKeys.allKeys) {
        NSString *value = mapKeys[key];
        BOOL flag = [self mapValue:key withKey2:value];
        success = flag && success;
    }
    return success;
}

/** 清除所有元素 */
- (void)clear {
    [self.dictData removeAllObjects];
    [self.attributeData removeAllObjects];
}

/** 调试接口，在console中打印出当前对象包含的元素 */
- (void)dump {
    if (nil == self.dictData) {
        return;
    }
    
    NSArray *keys = [self.dictData allKeys];
    
    for (NSString *key in keys) {
        NSLog(@"Dump:  [%@] => %@", key, self.dictData[key.lowercaseString]);
    }

    NSArray *keys2 = [self.attributeData allKeys];
    for (NSString *key in keys2) {
        NSLog(@"Dump:  [%@] => %@", key, self.attributeData[key.lowercaseString]);
    }
}

/** 调试接口 */
- (NSString *)whatInThis {
    NSArray *keys = [self.dictData allKeys];
    NSArray *keys2 = [self.attributeData allKeys];
    
    NSString *what = @"====begin====\r\n";
    
    for (NSString *key in keys) {
        NSString *line = @"";
        id ob = self.dictData[key.lowercaseString];
        //递归
        if ([ob isKindOfClass:[DataItemDetail class]]) {
            line = [ob whatInThis];
        } else {
            line = [NSString stringWithFormat:@"[%@] => %@\r\n", key, ob];
        }
        what = [what stringByAppendingString:line];
    }

    for (NSString *key in keys2) {
        id ob = self.dictData[key.lowercaseString];
        NSString *line = [NSString stringWithFormat:@"[%@] => %@\r\n", key, ob];
        what = [what stringByAppendingString:line];
    }
    
    what = [what stringByAppendingString:@"====end====\r\n"];
    return what;
}

#pragma mark -
#pragma mark 序列 反序列
/** 当前对象序列化到NSData数据流中 */
- (NSData *)toData {
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [self encodeWithCoder:archiver];
    [archiver finishEncoding];
    
    return data;
}

/** 从NSData数据流中反序列化出一个 DataItemDetail 对象 */
+ (id)FromData:(NSData *)data {
    if (nil == data) {
        return nil;
    }
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    DataItemDetail *item = [[DataItemDetail alloc] initWithCoder:unarchiver];
    
    [unarchiver finishDecoding];
    
    return item;
}

/** 反序列化函数 */
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (nil != self) {
        self.dictData = [aDecoder decodeObject];
        
        if (nil == self.dictData) {
            self.dictData = [[NSMutableDictionary alloc] initWithCapacity:0];
        }
    }
    
    return self;
}

/** 序列化函数 */
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.dictData];
}

@end
