//
//  SBHttpTaskController.m
//  SBLib
//
//  Created by roronoa on 2017/3/2.
//  Copyright © 2017年 yuki.wang. All rights reserved.
//

#import "SBHttpTaskController.h"
#import "SBCONSTANT.h"

@interface SBHttpTaskController ()<SBHttpDataLoaderDelegate>

@property (nonatomic, strong) SBHttpDataLoader *httpLoader;

@end

@implementation SBHttpTaskController

- (void)dealloc {
    [self.httpLoader stopLoading];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];


    NSString *domainURL = @"https://lvbaccount.eastmoney.com/api/EMLivePassport/SendActiveCodeForEMLiveLogin";

    NSString *uniqueId = @"C7a10ABB1D75-0BD4-4DEB-88C6-0859B9A0DF4078dE";      //用户唯一识别
    NSString *productType = @"EmLive";      //用户产品类型
    NSString *appVersion = SBAppVersion;      //用户产品版本信息
    NSString *deviceType = [SBAppCoreInfo sharedSBAppCoreInfo].clientOS;      //用户设备类型
    NSString *deviceModel = [SBAppCoreInfo sharedSBAppCoreInfo].clientMachine;      //用户设备型号
    NSString *domainName = @"EMLiveAPP";      //站点名字

    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] init];
    mParams[@"UniqueID"] = uniqueId;
    mParams[@"ProductType"] = productType;
    mParams[@"Version"] = appVersion;
    mParams[@"DeviceType"] = deviceType;
    mParams[@"DeviceModel"] = deviceModel;
    mParams[@"DomainName"] = domainName;
    mParams[@"CountryID"] = @"0042";
    mParams[@"UMobphone"] = @"18616021211";
    mParams[@"VCode"] = @"";
    mParams[@"VCodeContext"] = @"";

    //    NSString *sParams = [mParams sb_URLArgumentsString];
    //    domainURL = [NSString stringWithFormat:@"%@?%@", domainURL, sParams];

    //json格式传参
//    self.httpLoader = [[SBHttpDataLoader alloc] initWithURL:domainURL httpMethod:@"POST" delegate:self];
//    self.httpLoader.httpTask.jsonDict = [mParams mutableCopy];
//    self.httpLoader.httpTask.aHTTPHeaderField = @{@"em_clt_uiid":uniqueId};

//    self.httpLoader = [[SBHttpDataLoader alloc] initWithURL:@"https://lvbsns.eastmoney.com/LVB/api/Channel/GetLiveChannelInfo?network=Wifi&version=1.7.0&pi=&count=30&product=emlive&plat=Iphone&sdkversion=1,9,1951&device_id=De88d2C89111-9987-48F6-9CFE-72FCFE7C5F0a01dB&page=1&model=Simulator&osversion=10.2" httpMethod:@"POST" delegate:self];

}


/** onReceived方法：在数据装载器装载数据结束后调用的方法 */
- (void)dataLoader:(SBHttpDataLoader *)dataLoader onReceived:(DataItemResult *)result {
    if (dataLoader == self.httpLoader) {

        NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:result.rawData options:NSJSONReadingMutableContainers error:nil]);
    }
}
@end
