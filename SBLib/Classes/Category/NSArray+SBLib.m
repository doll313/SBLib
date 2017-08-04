//
//  NSArray+SBLib.m
//  Pods
//
//  Created by roronoa on 2017/8/4.
//
//

#import "NSArray+SBLib.h"
#import "DataItemDetail.h"

@implementation NSArray(sbmodule)
/* 转换dictionary数组 -> datatitemdetail数组 */
- (NSArray *)sb_convertToDetail {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSObject *obj in self) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            DataItemDetail *detail = [DataItemDetail detailFromDictionary:(NSDictionary *)obj];
            [tempArray addObject:detail];
        } else if ([obj isKindOfClass:[DataItemDetail class]]) {
            [tempArray addObject:obj];
        }
    }

    return tempArray;
}

@end
