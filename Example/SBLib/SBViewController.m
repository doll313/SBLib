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
@property (nonatomic, strong) SBNetworkFlow *netFlow;
@property (nonatomic, strong) SBFpsHelper *fpsHelper;

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

    self.netFlow = [[SBNetworkFlow alloc] init];
    [self.netFlow startblock:^(u_int32_t sendFlow, u_int32_t receivedFlow) {
//        NSLog(@"%@, %@", @(sendFlow),@(receivedFlow));
    }];

    self.fpsHelper = [[SBFpsHelper alloc] init];
    [self.fpsHelper startblock:^(CGFloat fps) {
        NSLog(@"%.f FPS", fps);
    }];

    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark -
#pragma mark 列表
//列表
- (void)tableDidLoad {
    self.animTable = [[SBTableView alloc] initWithStyle:NO];
    self.animTable.ctrl = self;
    [self.view addSubview:self.animTable];

//    SBWS(__self)

    // 计算单元格高度
    self.animTable.heightForRow = ^CGFloat(SBTableView *tableView, NSIndexPath *indexPath) {
        return APPCONFIG_UI_TABLE_CELL_HEIGHT;
    };

    // 单元格点击事件
    self.animTable.didSelectRow = ^(SBTableView *tableView, NSIndexPath *indexPath) {
        DataItemDetail *cellDetail = [tableView dataOfIndexPath:indexPath];
        NSString *titleStr = [cellDetail getString:__KEY_CELL_TITLE];

        if ([titleStr isEqualToString:@"alert"]) {
            [tableView.ctrl sb_quickOpenCtrl:@"SBAlertDemoController"];
        }
        else if ([titleStr isEqualToString:@"index"]) {
            [tableView.ctrl sb_quickOpenCtrl:@"SBIndexTableController"];
        }
        else if ([titleStr isEqualToString:@"http"]) {
            NSURL *url = [NSURL URLWithString:@"https://liveavatar.eastmoney.com/qface/1095014665825048/1024?v=1478249720"];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

            NSURLSession *session = [NSURLSession sharedSession];
            // 由于要先对request先行处理,我们通过request初始化task
            NSURLSessionTask *task = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                }];
            [task resume];
        }
    };

    // 帐户资料
    SBTableData *sectionData = [[SBTableData alloc] init];
    sectionData.mDataCellClass = [SBTitleCell class];
    [self.animTable addSectionWithData:sectionData];

    NSArray *titleArray = @[@"alert",
                            @"index",
                            @"http",
                            ];

    //单元格
    for (int i = 0; i < titleArray.count; i++) {
        DataItemDetail *detail = [DataItemDetail detail];
        [detail setString:titleArray[i] forKey:__KEY_CELL_TITLE];
        [sectionData.tableDataResult addItem:detail];
    }

    [self.animTable reloadData];

    NSString *ss = [SBAppCoreInfo sb_description];
    NSLog(@"%@",ss);
}

@end
