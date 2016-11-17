//
//  SBViewController.m
//  SBLib
//
//  Created by yuki.wang on 08/30/2016.
//  Copyright (c) 2016 yuki.wang. All rights reserved.
//

#import "SBViewController.h"
#import "SBCONSTANT.h"

@interface SBViewController ()

@property (nonatomic, strong) SBTableView *animTable;

@end

@implementation SBViewController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.animTable.frame = self.view.bounds;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self tableDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
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

        if ([titleStr isEqualToString:@"1"]) {
            [__self clicked1];
        }
        else if ([titleStr isEqualToString:@"2"]) {
            [__self clicked2];
        }
        else if ([titleStr isEqualToString:@"3"]) {
            [__self clicked3];
        }
        else if ([titleStr isEqualToString:@"4"]) {
            [__self clicked4];
        }
        else if ([titleStr isEqualToString:@"5"]) {
            [__self clicked5];
        }
        else if ([titleStr isEqualToString:@"6"]) {
            [__self clicked6];
        }
    };

    // 帐户资料
    SBTableData *sectionData = [[SBTableData alloc] init];
    sectionData.mDataCellClass = [SBTitleCell class];
    [self.animTable addSectionWithData:sectionData];

    NSArray *titleArray = @[@"1",
                            @"2",
                            @"3",
                            @"4",
                            @"5",
                            @"6",
                            ];

    //单元格
    for (int i = 0; i < titleArray.count; i++) {
        DataItemDetail *detail = [DataItemDetail detail];
        [detail setString:titleArray[i] forKey:__KEY_CELL_TITLE];
        [sectionData.tableDataResult addItem:detail];
    }

    [self.animTable reloadData];
}

- (void)clicked1 {
    [UIWindow sb_showTips:@"jjjjj" hiddenAfterSeconds:2];
}
- (void)clicked2 {
    [self.view sb_showTips:@"jjjjj" hiddenAfterSeconds:2];
}
- (void)clicked3 {
    [self sb_showTips:@"jjjjj" hiddenAfterSeconds:2];
}
- (void)clicked4 {
    [UIWindow sb_showTips:@""];
}
- (void)clicked5 {
    [UIWindow sb_showTips:@"abc" showIndicator:YES hiddenAfterSeconds:2];
}
- (void)clicked6 {
    [self sb_showAlert:@"asdfa" handler:^(UIAlertAction *action) {
        NSLog(@"56789");
    }];
}

@end
