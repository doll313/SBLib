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
    [self.view addSubview:self.iTable];

    //计算单元格的高度
    self.iTable.heightForRow = ^CGFloat(SBTableView *tableView, NSIndexPath *indexPath) {
        return 44;
    };

    NSArray *titleArray = @[@"张三",
                            @"张1",
                            @"张2",
                            @"张3",
                            @"张4",
                            @"李3",
                            @"李5",
                            @"李6",
                            @"李7",
                            @"李8",
                            @"王9",
                            @"王101",
                            @"王92",
                            @"王103",
                            @"王923",
                            @"王105",
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
