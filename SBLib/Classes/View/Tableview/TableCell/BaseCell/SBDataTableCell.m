/*
#####################################################################
# File    : SBDataTableCell.m
# Project : 
# Created : 2013-03-30
# DevTeam : Thomas Develop
# Author  : 
# Notes   :
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

#import "SBDataTableCell.h"
#import "SBAppCoreInfo.h"

@implementation DataItemDetail (SBDataTableCell)

/** 设定单元格数据为空 */
- (void)setEmptyTableCell {
    [self setEmptyTableCell:YES];
}

/** 设定单元格数据为空/不为空 */
- (void)setEmptyTableCell:(BOOL)isEmpty {
    [self setBool:isEmpty forKey:__KEY_CELL_EMPTY];
}

/** 单元格数据是否为空 */
- (BOOL)tableCellIsEmpty {
    return [self getBool:__KEY_CELL_EMPTY];
}

/** 设定单元格选中/未选中状态 */
- (void)setSelectedTableCell:(BOOL)isSelected {
    [self setBool:isSelected forKey:__KEY_CELL_SELECTED];
}

/** 单元格是否被选中状态 */
- (BOOL)tableCellIsSelected {
    return [self getBool:__KEY_CELL_SELECTED];
}

/** 设定单元格标记 */
- (void)setTableCellTag:(NSInteger)tag {
    [self setInt:tag forKey:__KEY_CELL_TAG];
}

/** 获取单元格标记 */
- (NSInteger)tableCellTag {
    return [self getInt:__KEY_CELL_TAG];
}

@end


static int _cell_alloc_count = 0;
static BOOL _cell_alloc_debug;

@implementation SBDataTableCell

#pragma mark -
#pragma mark 生命周期
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        //标签
        self.displayLabel = [UILabel new];
        [self.displayLabel sb_cellLabel];
        [self.contentView addSubview:self.displayLabel];
 
        //单元格外不显示
        self.clipsToBounds = YES;
        
        //调试单元格内存
        _cell_alloc_debug = [[NSUserDefaults standardUserDefaults] boolForKey:DEBUG_MALLOC_FOR_TABLE_CELL];
        if (_cell_alloc_debug) {
            NSLog(@"%@[init]: %d", self, ++_cell_alloc_count);
        }
    }
        
    return self;
}

- (void)dealloc {
    //调试单元格内存
    if (_cell_alloc_debug) {
        NSLog(@"%@[dealloc]: %d", self, --_cell_alloc_count);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.displayLabel.frame = self.contentView.bounds;
}

- (void)bindCellData {
}

+ (id)createCell:(NSString *)reuseIdentifier {
    return [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

/** 获取单元格的ID */
+ (NSString *)cellID:(SBTableView *)table {
    return [NSString stringWithFormat:@"%@-%x",[self class],  (unsigned int)table];
}

//绘制单元格
- (void)drawRect:(CGRect)rect context:(CGContextRef)context bounds:(CGRect)bounds {
    //具体在子类实现
    
}

+ (CGFloat)cellHeight:(DataItemDetail *)detail{
    return 44.0f;
}

@end
