/*
#####################################################################
# File    : SBErrorTableCell.m
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

#import "SBErrorTableCell.h"
#import "UIView+SBMODULE.h"
#import "SBTableData.h"
#import "SBCollectionData.h"

@interface SBErrorTableCell ()
@property (nonatomic, strong) UIButton *customButton;
@end


@implementation SBErrorTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.accessoryType = UITableViewCellAccessoryNone;
	self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //边框外不可见
    self.clipsToBounds = YES;

    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.customButton.frame = self.contentView.bounds;
}

- (void)bindCellData {
    [super bindCellData];
    
    //加载错误信息
    [self loadErrorMessage];
}

- (void)setCanUserClicked:(BOOL)canUserClicked {
    if (canUserClicked) {
        [self.customButton removeFromSuperview];
        return;
    }
    
    //底部放一个按钮，为了不让点击空白处重新刷新界面
    self.customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.customButton];
}

//加载错误数据
-(void)loadErrorMessage {
    self.displayLabel.hidden = NO;
    NSString *errorStr = self.tableData.tableDataResult.message;
    NSString *defaultMessage = @"数据加载出错，点击可重试!";
    if (!errorStr) {
        errorStr = defaultMessage;
    }
    if (self.tableData.pageAt > 1) {
        errorStr = defaultMessage;
    }
    self.displayLabel.text = errorStr;
    
    self.errorMessage = self.displayLabel.text;
}
@end


//全屏错误单元格
@implementation SBFullErrorCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        //图片
    self.emptyImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.emptyImageView];
    
    return self;
}

- (void)dealloc {
}

- (void)bindCellData {
    [super bindCellData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //默认的空单元格高度是带列表头的
    CGFloat cellWidth = CGRectGetWidth(self.bounds);
    CGFloat cellHeight = CGRectGetHeight(self.bounds);
    
    CGFloat imageWidth = self.emptyImageView.image.size.width;
    CGFloat imageHeight = self.emptyImageView.image.size.height;
    self.emptyImageView.frame = CGRectMake((cellWidth - imageWidth) / 2, 0, imageWidth, imageHeight);
    
    [self.displayLabel sizeToFit];
    [self.displayLabel sb_centerOfView:self.contentView];
    
    CGFloat margin = 16.0f;
    [self.emptyImageView sb_setMinY:(cellHeight - imageHeight - CGRectGetHeight(self.displayLabel.frame) - margin * 2) / 2];
    [self.displayLabel sb_bottomOfView:self.emptyImageView withMargin:margin];
    
    //去掉底部分割线
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, cellWidth);
}

@end

@implementation SBErrorCollectionCell

- (void)bindItemData {
    [super bindItemData];
    
    //加载错误信息
    [self loadErrorMessage];
}

//加载错误数据
-(void)loadErrorMessage {
    NSString *errorStr = self.collectionData.tableDataResult.message;
    NSString *defaultMessage = @"数据加载出错，点击可重试!";
    self.displayLabel.hidden = NO;
    if (!errorStr) {
        errorStr = defaultMessage;
    }
    if (self.collectionData.pageAt > 1) {
        errorStr = defaultMessage;
    }
    self.displayLabel.text = errorStr;
    
    self.errorMessage = self.displayLabel.text;
}

@end


//全屏错误单元格
@implementation SBFullErrorCollectionCell
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    //图片
    self.emptyImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.emptyImageView];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat cellWidth = CGRectGetWidth(self.bounds);
    CGFloat cellHeight = CGRectGetHeight(self.bounds);
    
    CGFloat imageWidth = self.emptyImageView.image.size.width;
    CGFloat imageHeight = self.emptyImageView.image.size.height;
    self.emptyImageView.frame = CGRectMake((cellWidth - imageWidth) / 2, 0, imageWidth, imageHeight);
    
    [self.displayLabel sizeToFit];
    [self.displayLabel sb_centerOfView:self.contentView];
    
    CGFloat margin = 16.0f;
    [self.emptyImageView sb_setMinY:(cellHeight - imageHeight - CGRectGetHeight(self.displayLabel.frame) - margin * 2) / 2];
    [self.displayLabel sb_bottomOfView:self.emptyImageView withMargin:margin];
    
}

@end
