/*
 #####################################################################
 # File    : SBSwitchCell.m
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

#import "SBSwitchCell.h"

@implementation SBSwitchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //选择器
        self.valueSw = [[UISwitch alloc] init];
        [self.valueSw addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:self.valueSw];
        
        self.accessoryView = self.valueSw;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}

- (void)bindCellData {
    [super bindCellData];
    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

//选择器发生改变
- (void)switchDidChange:(id)sender {
    
}

@end
