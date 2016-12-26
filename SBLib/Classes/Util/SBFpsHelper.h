//
//  SBFpsHelper.h
//  Pods
//
//  Created by roronoa on 2016/12/26.
//
//

#import <Foundation/Foundation.h>

/** fps **/
@interface SBFpsHelper : NSObject

/** 开始监听 **/
- (void)startblock:(void (^)(CGFloat fps))block;
- (void)stop;

@end
