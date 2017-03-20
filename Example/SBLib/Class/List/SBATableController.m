//
//  SBATableController.m
//  SBLib
//
//  Created by roronoa on 2017/2/9.
//  Copyright © 2017年 yuki.wang. All rights reserved.
//

#import "SBATableController.h"
#import "SBTableView.h"
#import "SBConstant.h"

@interface SBATableController ()

@property (nonatomic, strong) SBTableView *iTable;

@end

@implementation SBATableController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    SBWS(__self)

    //
    self.iTable = [[SBTableView alloc] initWithStyle:NO];
    self.iTable.ctrl = self;
    self.iTable.frame = self.view.bounds;
    [self.view addSubview:self.iTable];

    //计算单元格的高度
    self.iTable.heightForRow = ^CGFloat(SBTableView *tableView, NSIndexPath *indexPath) {
        return 44;
    };


    self.iTable.canEditRow = ^(SBTableView *tableView, NSIndexPath *indexPath) {
        return YES;
    };


    self.iTable.editActions = ^NSArray<UITableViewRowAction *> *(SBTableView *tableView, NSIndexPath *indexPath) {
        return [__self editActions];
    };

    self.iTable.didSelectFinish = ^(SBTableView *tableView, NSIndexPath *indexPath) {
        NSLog(@"didSelectFinish");
    };

    // 帐户资料
    SBTableData *sectionData = [[SBTableData alloc] init];
    sectionData.mDataCellClass = [SBTitleCell class];
    sectionData.hasFinishCell = YES;
    sectionData.httpStatus = SBTableDataStatusFinished;
    [self.iTable addSectionWithData:sectionData];

    NSArray *titleArray = @[@"a",
                            @"b",
                            @"c",
                            @"d",
                            ];

    //单元格
    for (int i = 0; i < titleArray.count; i++) {
        DataItemDetail *detail = [DataItemDetail detail];
        [detail setString:titleArray[i] forKey:__KEY_CELL_TITLE];
        [sectionData.tableDataResult addItem:detail];
    }

    [self.iTable reloadData];


    UIImage *nImage = [UIImage sb_imageWithColor:[UIColor redColor] withFrame:CGRectMake(0, 0, 56, 26)];
    nImage = [nImage sb_roundCorner:5];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 300, 56, 26)];
    img.image = nImage;
    [self.view addSubview:img];
}

- (NSArray *)editActions {
    NSMutableArray *actions = [NSMutableArray array];
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"忽略未读" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {

    }];
    [actions addObject:action];

    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {

    }];
    [actions addObject:action2];

    return actions;
}


@end
