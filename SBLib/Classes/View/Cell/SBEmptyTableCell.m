/*
#####################################################################
# File    : EmptyTableCell.m
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

#import "SBEmptyTableCell.h"
#import "UIView+SBMODULE.h"
#import "SBTableData.h"
#import "SBCollectionData.h"

@implementation SBEmptyTableCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.errorMessage = @"数据为空！";
    return self;
}

//加载错误数据
-(void)loadErrorMessage {
    NSString *errorStr = self.tableData.tableDataResult.message;
    self.displayLabel.text = SBStringIsEmpty(errorStr) ? @"数据为空！" : errorStr;
}

@end

@implementation SBEmptyNotClickCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.canUserClicked = NO;
    return self;
}
@end

@implementation SBFullEmptyCell
@end


@interface SBFullEmptyNotClickCell ()
@property (nonatomic, strong) UIButton *customButton;
@end

//全屏不能点击单元格
@implementation SBFullEmptyNotClickCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.canUserClicked = NO;
    return self;
}

@end


@implementation SBEmptyCollectionCell

//加载错误数据
-(void)loadErrorMessage {
    NSString *errorStr = self.collectionData.tableDataResult.message;
    self.displayLabel.text = SBStringIsEmpty(errorStr) ? @"数据为空！" : errorStr;
}

@end

@implementation SBFullEmptyCollectionCell

//加载错误数据
-(void)loadErrorMessage {
    NSString *errorStr = self.collectionData.tableDataResult.message;
    self.displayLabel.text = SBStringIsEmpty(errorStr) ? @"数据为空！" : errorStr;
}

@end
