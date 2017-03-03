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

    SBWS(__self)

    //
    self.iTable = [[SBTableView alloc] initWithStyle:NO];
    self.iTable.ctrl = self;
    self.iTable.frame = self.view.bounds;
    [self.view addSubview:self.iTable];

    self.iTable.requestData = ^SBHttpDataLoader*(SBTableData *tableViewData) {
        NSString *url = [NSString stringWithFormat:@"https://lvbsns.eastmoney.com/LVB/api/Channel/GetLiveChannelInfo?network=Wifi&version=1.7.0&pi=&count=%@&product=emlive&plat=Iphone&sdkversion=1,9,1951&device_id=De88d2C89111-9987-48F6-9CFE-72FCFE7C5F0a01dB&page=%@&model=Simulator&osversion=10.2", @(tableViewData.pageSize), @(tableViewData.pageAt)];
        return [[SBHttpDataLoader alloc] initWithURL:url httpMethod:@"POST" delegate:tableViewData];

    };

    self.iTable.receiveData = ^(SBTableView *tableView, SBTableData *tableViewData, DataItemResult *result) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result.rawData options:NSJSONReadingMutableContainers error:nil];

        NSDictionary *data = dict[@"data"];
        NSArray *livelist = data[@"livelist"];
        for (NSDictionary *live in livelist) {
            DataItemDetail *info = [DataItemDetail detailFromDictionary:live];
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

    [sectionData loadData];
}

@end
