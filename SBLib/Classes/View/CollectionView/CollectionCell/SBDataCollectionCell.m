//
//  SBCollectionViewCell.m
//  SBModule
//
//  Created by roronoa on 16/5/2.
//  Copyright © 2016年 thomas. All rights reserved.
//

#import "SBDataCollectionCell.h"        //Collocation 默认单元格


static int _item_alloc_count = 0;
static BOOL _item_alloc_debug;

@implementation SBDataCollectionCell

#pragma mark -
#pragma mark 生命周期
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        //标签
        self.displayLabel = [UILabel new];
        [self.displayLabel sb_cellLabel];
        [self.contentView addSubview:self.displayLabel];
        
        //单元格外不显示
        self.clipsToBounds = YES;
        
        //调试单元格内存
        _item_alloc_debug = [[NSUserDefaults standardUserDefaults] boolForKey:DEBUG_MALLOC_FOR_COLLECTION_CELL];
        if (_item_alloc_debug) {
            NSLog(@"item-count[init]: %d", ++_item_alloc_count);
        }
    }
    
    return self;
}

- (void)dealloc {
    //调试单元格内存
    if (_item_alloc_debug) {
        NSLog(@"item-count[dealloc]: %d", --_item_alloc_count);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.displayLabel.frame = self.contentView.bounds;
}

- (void)bindItemData {
}


+ (id)createCell:(CGRect)rect {
    return [[self alloc] initWithFrame:rect];
}

/** 获取单元格的ID */
+ (NSString *)cellID:(SBCollectionView *)collectionView {
    return [NSString stringWithFormat:@"%@-%x",[self class],  (unsigned int)collectionView];
}

//绘制单元格
- (void)drawRect:(CGRect)rect context:(CGContextRef)context bounds:(CGRect)bounds {
    //具体在子类实现
    
}
@end
