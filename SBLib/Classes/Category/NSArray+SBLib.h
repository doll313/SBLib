//
//  NSArray+SBLib.h
//  Pods
//
//  Created by roronoa on 2017/8/4.
//
//

//为SDK自带的 NSArray 类添加一些实用方法
@interface NSArray (sbmodule)

/* 转换dictionary数组 -> datatitemdetail数组 */
- (NSArray *)sb_convertToDetail;

@end

