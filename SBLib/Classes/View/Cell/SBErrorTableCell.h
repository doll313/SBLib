/*
#####################################################################
# File    : SBErrorTableCell.h
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
#import "SBDataCollectionCell.h"

//错误单元格
@interface SBErrorTableCell : SBDataTableCell {
}

@property (nonatomic, copy) NSString *errorMessage;
@property (nonatomic, assign) BOOL canUserClicked;

//加载错误数据
-(void)loadErrorMessage;
@end


//全屏错误单元格
@interface SBFullErrorCell : SBErrorTableCell
@property (nonatomic, strong) UIImageView *emptyImageView;//空图片
@end




#pragma mark - CollectionView


//错误单元格
@interface SBErrorCollectionCell : SBDataCollectionCell

@property (nonatomic, copy) NSString *errorMessage;
//加载错误数据
-(void)loadErrorMessage;

@end

//全屏错误单元格
@interface SBFullErrorCollectionCell : SBErrorCollectionCell
@property (nonatomic, strong) UIImageView *emptyImageView;//空图片
@end

