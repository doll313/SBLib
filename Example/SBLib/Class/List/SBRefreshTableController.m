//
//  SBRefreshTableController.m
//  SBLib
//
//  Created by roronoa on 2017/3/3.
//  Copyright © 2017年 yuki.wang. All rights reserved.
//

#import "SBRefreshTableController.h"
#import "SBConstant.h"

@interface SBRefreshTableController ()

@property (nonatomic, strong) SBTableView *iTable;

@end

@implementation SBRefreshTableController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];


    UIBarButtonItem *i1 =[[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refresh:)];
    UIBarButtonItem *i2 =[[UIBarButtonItem alloc] initWithTitle:@"替换" style:UIBarButtonItemStylePlain target:self action:@selector(replace:)];
    self.navigationItem.rightBarButtonItems = @[i1, i2];

    //
    self.iTable = [[SBTableView alloc] initWithStyle:NO];
    self.iTable.ctrl = self;
//    self.iTable.isRefreshType = YES;
    self.iTable.frame = self.view.bounds;
    [self.view addSubview:self.iTable];

    self.iTable.requestData = ^SBHttpDataLoader*(SBTableData *tableViewData) {
        if (tableViewData.tag == 0) {
            return [[SBHttpDataLoader alloc] initWithURL:@"http://www.weather.com.cn/data/cityinfo/101010100.html" httpMethod:@"GET" delegate:tableViewData];
        }
        else if (tableViewData.tag == 1) {
            return [[SBHttpDataLoader alloc] initWithURL:@"http://www.weather.com.cn/data/cityinfo/101010200.html" httpMethod:@"GET" delegate:tableViewData];
        }
        else {
            return [[SBHttpDataLoader alloc] initWithURL:@"http://www.weather.com.cn/data/cityinfo/101010300.html" httpMethod:@"GET" delegate:tableViewData];
        }
    };

    self.iTable.receiveData = ^(SBTableView *tableView, SBTableData *tableViewData, DataItemResult *result) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result.rawData options:NSJSONReadingMutableContainers error:nil];

        NSDictionary *weatherinfo = dict[@"weatherinfo"];
        for (NSString *key in weatherinfo.allKeys) {
            DataItemDetail *info = [DataItemDetail new];
            [info setString:key forKey:__KEY_CELL_TITLE];
            [info setString:weatherinfo[key] forKey:__KEY_CELL_VALUE];
            [result.dataList addObject:info];
        }
        result.maxCount = [dict[@"count"] integerValue];

        [tableViewData.tableDataResult appendItems:result];


    };

    //计算单元格的高度
    self.iTable.heightForRow = ^CGFloat(SBTableView *tableView, NSIndexPath *indexPath) {
        return 44;
    };


    self.iTable.canEditRow = ^(SBTableView *tableView, NSIndexPath *indexPath) {
        return YES;
    };

    self.iTable.didSelectFinish = ^(SBTableView *tableView, NSIndexPath *indexPath) {
        NSLog(@"didSelectFinish");
    };

    // 帐户资料
    SBTableData *sectionData = [[SBTableData alloc] init];
    sectionData.mDataCellClass = [SBTitleCell class];
    sectionData.hasFinishCell = YES;
    [self.iTable addSectionWithData:sectionData];

    [sectionData refreshData];
}

- (void)refresh:(id)sender {
    SBTableData *cData = [self.iTable dataOfSection:0];
    cData.tag = 1;
    [cData refreshData];
}

- (void)replace:(id)sender {
    SBTableData *cData = [self.iTable dataOfSection:0];
    cData.tag = 2;
    [cData replaceData];
}
@end
