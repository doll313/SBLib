//
//  SBSmallWindow.h
//  SBLib
//
//  Created by thomas on 2017/5/22.
//  Copyright © 2017年 roronoa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBBasicController.h"

typedef NS_ENUM (NSInteger, SBSmallWindowPresentStyle) {
    SBSmallWindowPresentStyle_Normal = 0,//一般弹窗，默认中间
    SBSmallWindowPresentStyle_FromBottom,//从下方弹出
//    SBSmallWindowPresentStyle_FromRight,//从右边弹出
};

/*
 通用小弹窗
 自定义弹窗Controller继承SBSmallWindow，两种方式控制位置大小：
 a.设置windowY、windowW、windowH的值。
 b.由子视图的约束控制（推荐）。
 注：两种方式windowY都可不设置，则上下居中
 
 最后：[self presentViewController:self.yourController completion:nil];
 */

@interface SBSmallWindow : SBBasicController

@property (nonatomic, assign) SBSmallWindowPresentStyle presentStyle;//子类init的时候设置

@property (nonatomic, assign) CGFloat windowY;//窗口的y位置，不设置则上下居中(如果有键盘，会自动去掉键盘大小后，再上下居中)
@property (nonatomic, assign) CGFloat windowW;//窗口的宽度（不设置则需要由控制器子视图的约束来确定窗口大小）
@property (nonatomic, assign) CGFloat windowH;//窗口的高度(不设置则需要由控制器子视图的约束来确定窗口大小）
@property (nonatomic, assign) BOOL isFullWidth;//是否宽度全屏（针对横屏也要宽度全屏）
@property (nonatomic, assign) BOOL isFullHeight;//是否高度全屏
@property (nonatomic, assign) BOOL hideMask;//半透明背景遮罩层，
@property (nonatomic, assign) BOOL needTapGesture;//是否需要点击空白处消失,默认yes点空白自动消失

@end
