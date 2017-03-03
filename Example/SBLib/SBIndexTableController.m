//
//  SBIndexTableController.m
//  SBLib
//
//  Created by roronoa on 2016/12/15.
//  Copyright © 2016年 yuki.wang. All rights reserved.
//

#import "SBIndexTableController.h"
#import "SBIndexTableView.h"
#import "SBConstant.h"

@interface SBIndexTableController ()

@property (nonatomic, strong) SBIndexTableView *iTable;

@end

@implementation SBIndexTableController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.iTable.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.iTable = [[SBIndexTableView alloc] initWithStyle:NO];
    self.iTable.ctrl = self;
    self.iTable.indexKey = __KEY_CELL_TITLE;
    self.iTable.isFirstLetter = YES;
    self.iTable.listDataCellClass = [SBTitleCell class];
    self.iTable.listEmptyCellClass = [SBEmptyTableCell class];
    [self.view addSubview:self.iTable];

    //计算单元格的高度
    self.iTable.heightForRow = ^CGFloat(SBTableView *tableView, NSIndexPath *indexPath) {
        return 44;
    };

    NSArray *titleArray = @[
                            @"🐱张三",
                            @"张1",
                            @"张2",
                            @"张3",
                            @"🐵张4",
                            @"565",
                            @"99999",
                            @"李3",
                            @"李5",
                            @"李6",
                            @"李7",
                            @"李8",
                            @"王9",
                            @"王101",
                            @"王92",
                            @"🦇王103",
                            @"王923",
                            @"王105",
                            @"abc",
                            @"thomas",
                            @"🐱张三",
                            @"a张1",
                            @"b张2",
                            @"c张3",
                            @"d🐵张4",
                            @"e565",
                            @"f99999",
                            @"g李3",
                            @"h李5",
                            @"i李6",
                            @"j李7",
                            @"k李8",
                            @"l王9",
                            @"m王101",
                            @"n王92",
                            @"o🦇王103",
                            @"p王923",
                            @"q王105",
                            @"rabc",
                            @"sthomas",
                            @"tp王923",
                            @"uq王105",
                            @"vrabc",
                            @"wsthomas",
                            @"xtp王923",
                            @"yuq王105",
                            @"zvrabc",
                            @"uuuuwsthomas",
                            ];

    DataItemResult *iResult = [[DataItemResult alloc] init];
    //单元格
    for (int i = 0; i < titleArray.count; i++) {
        DataItemDetail *detail = [DataItemDetail detail];
        [detail setString:titleArray[i] forKey:__KEY_CELL_TITLE];
        [iResult addItem:detail];
    }

    [self.iTable appendResult:iResult];

    [self.iTable reloadData];
}

@end
