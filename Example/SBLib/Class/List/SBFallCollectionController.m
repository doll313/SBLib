//
//  SBFallCollectionController.m
//  SBLib
//
//  Created by roronoa on 2017/4/12.
//  Copyright © 2017年 yuki.wang. All rights reserved.
//

#import "SBFallCollectionController.h"
#import "SBFallLayout.h"
#import "SBFallFooter.h"
#import "SBConstant.h"

@interface SBFallCollectionCell : SBDataCollectionCell

@end
@implementation SBFallCollectionCell

- (void)preItemData {
    [super preItemData];

    NSLog(@"%zd", self.indexPath.row);
}

- (void)bindItemData {
    [super bindItemData];

    self.displayLabel.font = [UIFont systemFontOfSize:18];
    self.displayLabel.text = [self.itemDetail getString:__KEY_CELL_TITLE];
}

@end

@interface SBFallCollectionController ()

@property (nonatomic, strong) SBCollectionView *iCollectionView;

@end

@implementation SBFallCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    SBWS(__self)

    SBFallLayout *f = [[SBFallLayout alloc] init];
    //
    self.iCollectionView = [[SBCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:f];
    self.iCollectionView.ctrl = self;
    self.iCollectionView.isRefreshType = YES;
    self.iCollectionView.frame = self.view.bounds;
    [self.view addSubview:self.iCollectionView];

    UIImageView *headerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"abc.png"]];
    headerView.contentMode = UIViewContentModeScaleAspectFill;
    headerView.clipsToBounds = YES;
    headerView.frame = CGRectMake(0, 0, self.view.width, 128);

//    self.iCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

    //请求数据
    self.iCollectionView.requestData = ^(SBCollectionData *collectionData) {
        return [[SBHttpDataLoader alloc] initWithURL:@"http://www.weather.com.cn/data/cityinfo/101010100.html" httpMethod:@"GET" delegate:collectionData];
    };

    //接受数据
    self.iCollectionView.receiveData = ^(SBCollectionView *collectionView, SBCollectionData *collectionData, DataItemResult *result) {
        if (result.hasError) {
            return;
        }

        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result.rawData options:NSJSONReadingMutableContainers error:nil];
        dict = dict[@"weatherinfo"];
        if (dict) {
            for (NSString *key in dict.allKeys) {
                DataItemDetail *detail = [DataItemDetail detail];
                [detail setString:dict[key] forKey:__KEY_CELL_TITLE];
                [collectionData.tableDataResult addItem:detail];
            }
            for (NSString *key in dict.allKeys) {
                DataItemDetail *detail = [DataItemDetail detail];
                [detail setString:dict[key] forKey:__KEY_CELL_TITLE];
                [collectionData.tableDataResult addItem:detail];
            }
            for (NSString *key in dict.allKeys) {
                DataItemDetail *detail = [DataItemDetail detail];
                [detail setString:dict[key] forKey:__KEY_CELL_TITLE];
                [collectionData.tableDataResult addItem:detail];
            }
            for (NSString *key in dict.allKeys) {
                DataItemDetail *detail = [DataItemDetail detail];
                [detail setString:dict[key] forKey:__KEY_CELL_TITLE];
                [collectionData.tableDataResult addItem:detail];
            }
        }
        if (collectionData.pageAt == 4) {
            collectionData.tableDataResult.maxCount = collectionData.tableDataResult.count;
        }
        else {
            collectionData.tableDataResult.maxCount = collectionData.tableDataResult.count + 1;
        }

    };

    //item size
    self.iCollectionView.sizeForItem = ^ (SBCollectionView *collectionView, UICollectionViewLayout *collectionViewLayout,  NSIndexPath *indexPath) {
        CGFloat width = (collectionView.width - 15 ) / 2;
        if (indexPath.row == 1) {
            return CGSizeMake(width, width);
        }
        else {
            return CGSizeMake(width, width * 2);
        }
    };

    //item size
    self.iCollectionView.insetForSection = ^ (SBCollectionView *collectionView, UICollectionViewLayout *collectionViewLayout,  NSInteger section) {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    };


    self.iCollectionView.willDisplayCell = ^(SBCollectionView *collectionView, UICollectionViewCell *cell, NSIndexPath *indexPath) {
        NSInteger t = indexPath.row % 4;
        if (t == 0) {
            cell.backgroundColor = [UIColor redColor];
        }

        else if (t == 1) {
            cell.backgroundColor = [UIColor yellowColor];
        }

        else if (t == 2) {
            cell.backgroundColor = [UIColor blueColor];
        }

        else {
            cell.backgroundColor = [UIColor greenColor];
        }
    };

    // 帐户资料
    SBCollectionData *sectionData = [[SBCollectionData alloc] init];
    sectionData.mDataCellClass = [SBFallCollectionCell class];
    sectionData.mFooterClass = [SBFallFooter class];
//    sectionData.hasFinishCell = YES;
    [self.iCollectionView addSectionWithData:sectionData];

    [sectionData refreshData];
}
@end
