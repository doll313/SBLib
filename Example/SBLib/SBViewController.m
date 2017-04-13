//
//  SBViewController.m
//  SBLib
//
//  Created by yuki.wang on 08/30/2016.
//  Copyright (c) 2016 yuki.wang. All rights reserved.
//

#import "SBViewController.h"
#import "SBCONSTANT.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "AFNetworking.h"

@interface SBViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) SBTableView *animTable;
@property (nonatomic, strong) CLLocationManager *locationManager;

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

        if ([titleStr isEqualToString:@"alert"]) {
            [tableView.ctrl sb_quickOpenCtrl:@"SBAlertDemoController"];
        }
        else if ([titleStr isEqualToString:@"index"]) {
            [tableView.ctrl sb_quickOpenCtrl:@"SBIndexTableController"];
        }
        else if ([titleStr isEqualToString:@"table"]) {
            [tableView.ctrl sb_quickOpenCtrl:@"SBATableController"];
        }
        else if ([titleStr isEqualToString:@"http"]) {
            [tableView.ctrl sb_quickOpenCtrl:@"SBHttpTaskController"];
        }
        else if ([titleStr isEqualToString:@"refresh"]) {
            [tableView.ctrl sb_quickOpenCtrl:@"SBRefreshTableController"];
        }

        else if ([titleStr isEqualToString:@"location"]) {
            [__self doLocation];
        }
        else if ([titleStr isEqualToString:@"collection"]) {
            [tableView.ctrl sb_quickOpenCtrl:@"SBFallCollectionController"];
        }
    };

    // 帐户资料
    SBTableData *sectionData = [[SBTableData alloc] init];
    sectionData.mDataCellClass = [SBTitleCell class];
    [self.animTable addSectionWithData:sectionData];

    NSArray *titleArray = @[@"alert",
                            @"index",
                            @"http",
                            @"table",
                            @"refresh",
                            @"location",
                            @"collection",
                            ];

    //单元格
    for (int i = 0; i < titleArray.count; i++) {
        DataItemDetail *detail = [DataItemDetail detail];
        [detail setString:titleArray[i] forKey:__KEY_CELL_TITLE];
        [sectionData.tableDataResult addItem:detail];
    }

    [self.animTable reloadData];
}

-(void)doLocation {

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://api.douban.com/v2/book/isbn/9787505715660" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];//    self.locationManager = [[CLLocationManager alloc] init];
//    // 设置定位精度，十米，百米，最好
//    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
//    self.locationManager.delegate = self;
//
//    // 开始时时定位
//    [self.locationManager startUpdatingLocation];
}

// 错误信息
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error");
}

// 6.0 以上调用这个函数
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    NSLog(@"locations %@", locations);

    CLLocation *newLocation = locations[0];
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);

    //    CLLocation *newLocation = locations[1];
    //    CLLocationCoordinate2D newCoordinate = newLocation.coordinate;
    //    NSLog(@"经度：%f,纬度：%f",newCoordinate.longitude,newCoordinate.latitude);

    // 计算两个坐标距离
    //    float distance = [newLocation distanceFromLocation:oldLocation];
    //    NSLog(@"%f",distance);

    [manager stopUpdatingLocation];

    //------------------位置反编码---5.0之后使用-----------------
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error){

                       for (CLPlacemark *place in placemarks) {
                           NSLog(@"CLPlacemark %@", place);
                           //                           NSLog(@"thoroughfare,%@",place.thoroughfare);       // 街道
                           //                           NSLog(@"subThoroughfare,%@",place.subThoroughfare); // 子街道
                           //                           NSLog(@"locality,%@",place.locality);               // 市
                           //                           NSLog(@"subLocality,%@",place.subLocality);         // 区
                           //                           NSLog(@"country,%@",place.country);                 // 国家
                       }

                   }];

}

// 6.0 调用此函数
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"%@", @"ok");
}
@end
