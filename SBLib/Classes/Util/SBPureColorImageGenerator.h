/*
 #####################################################################
 # File    : SBPureColorImageGenerator.h
 # Project : StockBarIndependent
 # Created : 14-5-26
 # DevTeam : eastmoney
 # Author  : 缪和光
 # Notes   : 纯色图片
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

#import <Foundation/Foundation.h>

@interface SBPureColorImageGenerator : NSObject

/**
 *  返回纯色图片
 */
+ (UIImage *)generateOnePixelsb_imageWithColor:(UIColor *)color;

/**
 *  返回纯色图片 带size
 */
+ (UIImage *)generateRectsb_imageWithColor:(UIColor *)color rect:(CGRect)rect;

/** 渐变色图片 **/
+ (UIImage *)generateGradientImageWithColors:(NSArray *)colors rect:(CGRect)rect;

@end
