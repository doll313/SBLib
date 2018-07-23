//
//  SBApiRecordController.m
//  SBLib
//
//  Created by roronoa on 2017/3/6.
//  Copyright © 2017年 roronoa. All rights reserved.
//

#import "SBApiRecordController.h"
#import "UIAlertView+SB.h"   //
#import "NSData+SBMODULE.h"
#import "SBURLRecorder.h"           //URL记录
#import "SBApiRecordCell.h"
#import "NSDictionary+SBMODULE.h"   //解析 param
#import "SBApiInfoController.h"


@interface SBApiRecordController ()

@property (nonatomic, strong) SBTableView *logTable;

@end

@implementation SBApiRecordController


- (void)customView {
    [super customView];

    [self navDidLoad];
    [self tableDidLoad];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.logTable.frame = self.view.bounds;
}

- (void)navDidLoad {
    self.navigationItem.title = @"HTTP记录";

    //筛选
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"非200" style:UIBarButtonItemStylePlain target:self action:@selector(filter:)];
    self.navigationItem.rightBarButtonItem = item;

}

//筛选
- (void)filter:(id)sender {
    NSString *title = self.navigationItem.rightBarButtonItem.title;
    if ([title isEqualToString:@"非200"]) {
        self.navigationItem.rightBarButtonItem.title = @"全部";
    }
    else {
        self.navigationItem.rightBarButtonItem.title = @"非200";
    }

    //添加数据
    [self appendDatas];
    [self.logTable reloadData];
}

- (void)tableDidLoad {
    self.logTable = [[SBTableView alloc] initWithStyle:NO];
    self.logTable.ctrl = self;
    self.logTable.rowHeight = 72.0f;
    [self.view addSubview:self.logTable];

    SBWS(__self)

    // 单元格点击事件
    self.logTable.didSelectRow = ^(SBTableView *tableView, NSIndexPath *indexPath) {
        [__self didSelected:indexPath];
    };

    //
    self.logTable.heightForRow =  ^CGFloat(SBTableView *tableView, NSIndexPath *indexPath) {
        return SBApiRecordCellHeight;
    };

    // 单元格点击事件
    self.logTable.emptyCellClicked = ^(SBTableData *tableViewData) {
    };

    //
    SBTableData *sectionData = [[SBTableData alloc] init];
    sectionData.mDataCellClass = [SBApiRecordCell class];
    [self.logTable addSectionWithData:sectionData];

    [self appendDatas];
    [self.logTable reloadData];

}

//添加数据
- (void)appendDatas {
    SBTableData *sectionData = [self.logTable dataOfSection:0];
    [sectionData clearData];

    DataItemResult *result = [SBURLRecorder records];
    NSString *title = self.navigationItem.rightBarButtonItem.title;

    if ([title isEqualToString:@"非200"]) {
        [sectionData.tableDataResult appendItems:result];
    }
    else {
        for (int i = 0; i<[result count]; i++) {
            DataItemDetail *detail = [result getItem:i];
            SBHttpTask *task = (SBHttpTask *)[detail getObject:__KEY_CELL_CODE];
            NSURLResponse *response = task.sessionDataTask.response;
            NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;

            if (statusCode != 200) {
                [sectionData.tableDataResult addItem:detail];
            }
        }
    }
    sectionData.tableDataResult.message = @"🍔🌭🍕🍤🍟🌮🌯";
    sectionData.httpStatus = SBTableDataStatusFinished;
}

- (void)didSelected:(NSIndexPath *)indexPath {
    DataItemDetail *cellDetail = [self.logTable dataOfIndexPath:indexPath];

    NSString *string = @"";

    SBHttpTask *task = (SBHttpTask *)[cellDetail getObject:__KEY_CELL_CODE];

    NSURLRequest *request = task.sessionDataTask.currentRequest;
    NSURLResponse *response = task.sessionDataTask.response;

    NSDictionary *allHTTPHeaderFields = request.allHTTPHeaderFields;
    NSString *body = [[NSString alloc] initWithData:task.postData encoding:NSUTF8StringEncoding];
    NSDictionary *bodyDictionary = [NSDictionary sb_dictionaryWithURL:body];
    NSDictionary *recieveDictionary = [task.recieveData sb_objectFromJSONData];
    NSString *recieve = [recieveDictionary description];

    if (request) {
        string = [string stringByAppendingString:request.description];
        string = [string stringByAppendingString:@"\r\n"];
        string = [string stringByAppendingString:@"\r\n"];
    }
    if (bodyDictionary.allKeys.count > 0) {
        string = [string stringByAppendingString:body];
        string = [string stringByAppendingString:@"\r\n"];
        string = [string stringByAppendingString:@"\r\n"];
    }
    else {
        string = [string stringByAppendingString:body];
        string = [string stringByAppendingString:@"\r\n"];
        string = [string stringByAppendingString:@"\r\n"];
    }
    
    if (allHTTPHeaderFields.count > 0) {
        string = [string stringByAppendingString:allHTTPHeaderFields.description];
        string = [string stringByAppendingString:@"\r\n"];
        string = [string stringByAppendingString:@"\r\n"];
    }
    if (response) {
        string = [string stringByAppendingString:response.description];
        string = [string stringByAppendingString:@"\r\n"];
        string = [string stringByAppendingString:@"\r\n"];
    }
    if (recieve) {
        string = [string stringByAppendingString:recieve];
    }
    else {
        NSString *temp = [[NSString alloc] initWithData:task.recieveData encoding:NSUTF8StringEncoding];
        string = [string stringByAppendingString:SBNoNil(temp)];
    }

    SBApiInfoController *iCtrl = [[SBApiInfoController alloc] init];
    iCtrl.textString = string;
    [self.navigationController pushViewController:iCtrl animated:YES];


}

@end
