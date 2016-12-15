/*
 #####################################################################
 # File    : SBTitleCell.m
 # Project : StockBar
 # Created : 14/10/27
 # DevTeam : Thomas
 # Author  : Thomas
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

#import "SBTitleCell.h"

CGFloat const SBTitleCellHeight = 50.0f;
CGFloat const SBTitleSubtitleFont = 13.0f;      //副标题字体

static CGFloat const SBTitleCellTitleFont = 15.0f;      //标题字体

#define __SB_COLOR_TCELL_TITLE                RGB(0x00, 0x00, 0x00)       //标题颜色


@implementation SBTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //标题
        self.titleLbl = [[SBCellLabel alloc] init];
        [self.titleLbl setPermanentBackgroundColor:[UIColor clearColor]];
        self.titleLbl.textColor = __SB_COLOR_TCELL_TITLE;
        self.titleLbl.font = [UIFont systemFontOfSize:SBTitleCellTitleFont];
        [self.contentView addSubview:self.titleLbl];
        
        //副标题
        self.subTitleLbl = [[SBCellLabel alloc] init];
        [self.subTitleLbl setPermanentBackgroundColor:[UIColor clearColor]];
        self.subTitleLbl.textColor = __SB_COLOR_TCELL_SUBTITLE;
        self.subTitleLbl.font = [UIFont systemFontOfSize:SBTitleSubtitleFont];
        self.subTitleLbl.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.subTitleLbl];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //标题
    CGFloat width = CGRectGetWidth(self.contentView.frame);//cell宽度
    CGFloat height = CGRectGetHeight(self.frame);
    
    self.titleLbl.frame = CGRectMake(APPCONFIG_UI_TABLE_PADDING, 0, 1, 1);
    [self.titleLbl sizeToFit];
    [self.titleLbl sb_setHeight:height];
    //副标题
    self.subTitleLbl.frame = CGRectMake(0, 0, 1, 1);
    [self.subTitleLbl sizeToFit];
    [self.subTitleLbl sb_setHeight:height];
    
    
    //先布局一次，看是否超出宽度
    [self.subTitleLbl sb_rightOfView:self.titleLbl withMargin:APPCONFIG_UI_TABLE_PADDING];
    //如果发现界面异常，则说明主副标题宽度太大，可在子类中重新布局
    if (CGRectGetMaxX(self.subTitleLbl.frame) > width) {//如果超出界面宽度，则重新定义
        [self.titleLbl sb_setWidth:width /3 * 1];
        self.subTitleLbl.frame = self.titleLbl.bounds;
    }
    
    //主副标题间隔
    CGFloat marginFloat ;
    if (!CGRectGetWidth(self.titleLbl.frame)) {//如果没有主标题,副标题前移
        marginFloat = 0;
    }else{
        marginFloat = CGRectGetWidth(self.contentView.frame) - CGRectGetWidth(self.subTitleLbl.frame) - CGRectGetWidth(self.titleLbl.frame) - APPCONFIG_UI_TABLE_PADDING;//算出主副标题最终间隔
    }
    //最终布局
    [self.subTitleLbl sb_rightOfView:self.titleLbl withMargin:marginFloat];
}

//竖直布局
-(void)layoutTitleCellVerticalFrame{
    self.subTitleLbl.textAlignment = NSTextAlignmentLeft;
    CGFloat width = CGRectGetWidth(self.frame);//cell宽度
    width = floor(width/3 * 2);
    CGFloat cellHeight = CGRectGetHeight(self.frame);
    
    [self.titleLbl sizeToFit];
    [self.subTitleLbl sizeToFit];
    
    if (CGRectGetWidth(self.titleLbl.frame) > width) {
        [self.titleLbl sb_setWidth:width];
    }else if (CGRectGetWidth(self.subTitleLbl.frame) > width){
        [self.subTitleLbl sb_setWidth:width];
    }
    
    CGFloat minY = floor((cellHeight - CGRectGetHeight(_titleLbl.bounds) - CGRectGetHeight(_subTitleLbl.bounds) - APPCONFIG_UI_WIDGET_PADDING) /2 );
    [self.titleLbl sb_setMinY:minY];
    
    [self.subTitleLbl sb_setMinX:CGRectGetMinX(self.titleLbl.frame)];
    [self.subTitleLbl sb_bottomOfView:self.titleLbl withMargin:APPCONFIG_UI_WIDGET_PADDING];
}


- (void)bindCellData {
    [super bindCellData];
    
    NSString *titleStr = [self.cellDetail getString:__KEY_CELL_TITLE];
    NSString *valueStr = [self.cellDetail getString:__KEY_CELL_VALUE];
    self.subTitleLbl.hidden = SBStringIsEmpty(valueStr);
    
    self.titleLbl.text = titleStr;
    self.subTitleLbl.text = valueStr;
}

@end
