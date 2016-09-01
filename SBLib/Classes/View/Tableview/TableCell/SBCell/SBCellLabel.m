//
//  SBCellLabel.m
//  StockBar
//
//  Created by 缪和光 on 14-7-8.
//  Copyright (c) 2014年 Thomas. All rights reserved.
//

#import "SBCellLabel.h"

@implementation SBCellLabel

@dynamic permanentBackgroundColor;

- (void)setPermanentBackgroundColor:(UIColor *)permanentBackgroundColor {
    [super setBackgroundColor:permanentBackgroundColor];
}

- (UIColor *)permanentBackgroundColor {
    return [super backgroundColor];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    // override
}

@end
