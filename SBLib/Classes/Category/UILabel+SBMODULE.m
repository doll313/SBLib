//
//  UILabel+SBMODULE.m
//  SBModule
//
//  Created by roronoa on 16/5/3.
//  Copyright © 2016年 thomas. All rights reserved.
//

#import "UILabel+SBMODULE.h"            //标签扩展

@implementation UILabel(sbmodule)

/** 常用单元格上的标签样式 */
- (void)sb_cellLabel {
    self.font = [UIFont systemFontOfSize:14.0f];
    self.textAlignment = NSTextAlignmentCenter;
//    self.backgroundColor = [UIColor clearColor];
    self.textColor = RGB(0x88, 0x88, 0x88);
//    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

@end
