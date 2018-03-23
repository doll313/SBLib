//
//  SBTestWindowController.m
//  SBLib_Example
//
//  Created by Thomas Wang on 2018/3/23.
//  Copyright © 2018年 yuki.wang. All rights reserved.
//

#import "SBTestWindowController.h"
#import "SBTestWindow.h"

@interface SBTestWindowController ()
@property (nonatomic, strong) SBTableView *animTable;

@end

@implementation SBTestWindowController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.animTable.frame = self.view.bounds;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self tableDidLoad];
}
#pragma mark -
#pragma mark 列表
//列表
- (void)tableDidLoad {
    self.animTable = [[SBTableView alloc] initWithStyle:NO];
    self.animTable.ctrl = self;
    [self.view addSubview:self.animTable];
    
    SBWS(__self)
    
    // 计算单元格高度
    self.animTable.heightForRow = ^CGFloat(SBTableView *tableView, NSIndexPath *indexPath) {
        return APPCONFIG_UI_TABLE_CELL_HEIGHT;
    };
    
    // 单元格点击事件
    self.animTable.didSelectRow = ^(SBTableView *tableView, NSIndexPath *indexPath) {
        DataItemDetail *cellDetail = [tableView dataOfIndexPath:indexPath];
        NSString *titleStr = [cellDetail getString:__KEY_CELL_TITLE];
        
        SBTestWindow *window = [[SBTestWindow alloc] init];
        
        if ([titleStr isEqualToString:@"normal"]) {
            window.presentStyle = SBSmallWindowPresentStyle_Normal;
            window.windowW = 260;
            window.windowH = 200;
        }
        else if ([titleStr isEqualToString:@"bottom"]) {
            window.presentStyle = SBSmallWindowPresentStyle_FromBottom;
            window.windowH = 240;
        }
        else if ([titleStr isEqualToString:@"right"]) {
            window.presentStyle = SBSmallWindowPresentStyle_FromRight;
            window.windowW = 100;
        }
        [tableView.ctrl presentViewController:window animated:YES completion:nil];
    };
    
    // 帐户资料
    SBTableData *sectionData = [[SBTableData alloc] init];
    sectionData.mDataCellClass = [SBTitleCell class];
    [self.animTable addSectionWithData:sectionData];
    
    NSArray *titleArray = @[@"normal",
                            @"bottom",
                            @"right",
                            ];
    
    //单元格
    for (int i = 0; i < titleArray.count; i++) {
        DataItemDetail *detail = [DataItemDetail detail];
        [detail setString:titleArray[i] forKey:__KEY_CELL_TITLE];
        [sectionData.tableDataResult addItem:detail];
    }
    
    [self.animTable reloadData];
}

@end
