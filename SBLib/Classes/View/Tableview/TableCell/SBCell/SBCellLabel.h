//
//  SBCellLabel.h
//  StockBar
//
//  Created by 缪和光 on 14-7-8.
//  Copyright (c) 2014年 Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 用于Cell的Label，防止Cell点击时，Label的背景色被去掉的问题
 这个Label的setBackgroundColor会失效，请使用setPermanentBackgroundColor
 */
@interface SBCellLabel : UILabel

@property (nonatomic, strong) UIColor *permanentBackgroundColor;

@end
