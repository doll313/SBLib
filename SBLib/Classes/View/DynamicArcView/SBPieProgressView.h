//
//  SBPieProgressView.h
//  SBLib
//
//  Created by roronoa on 2017/4/13.
//  Copyright © 2017年 roronoa. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 圆形转圈 显示进度用 **/
@interface SBPieProgressView : UIView

@property (nonatomic, assign) CGFloat progress;

- (void)setCenterProgressText:(NSString *)text withAttributes:(NSDictionary *)attributes;

- (void)dismiss;

+ (id)progressView;

@end
