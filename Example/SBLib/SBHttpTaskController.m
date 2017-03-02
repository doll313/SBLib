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

    self.httpLoader = [[SBHttpDataLoader alloc] initWithURL:@"https://lvbqas.eastmoney.com:8101/LVB/api/User/GetUserFollowList?network=Wifi&version=1.7.0&pi=&count=20&product=emlive&plat=Iphone&sdkversion=1,9,1951&user_id=1007014679755394&ctoken=U3Yb2y4wmGLPdypjF1PLesSDXMwPYlteWIgMzoCBRH_KKllJI4_JxqRtyGKR45HvLJMQHGJZsZZrmoKMHvrFOU2HeeCBp5dOA3WIbR82aZXzgEQhLHDfI8nLjgcyIGV_cirxnvoxRuzsrZ3OCB_ChNvnx5ne37QAiVERTKdjKEE&device_id=De88d2C89111-9987-48F6-9CFE-72FCFE7C5F0a01dB&page=1&model=Simulator&osversion=10.2&utoken=s3wlV4neEHunYQqUx4ePiEjh7DnAYyEckvNJDfI32sSilx7uBqj3vLLmy1Qc6MVdxhOvozCeLgywcHmy2nkxrinKBqAA134g9Yjax_MrkIZMrOUvw7FZ2FhJPhy2OlY51KM3OuZjVS9OWOXs8MQBDVQOLUVaxbmNlPEWgadW23JKCFjHwBdBgRUuxerMKLcHQejMmgxDa6MP47R3roAyNZcyWag8FcKT5qVo29Vw0wiFYH4JJyx_S0E_YjdmZmTDSYrGsPiUlj123kRBaufqAZM5oEq2udQySfkrkSa6uOY" httpMethod:@"POST" delegate:self];

}


/** onReceived方法：在数据装载器装载数据结束后调用的方法 */
- (void)dataLoader:(SBHttpDataLoader *)dataLoader onReceived:(DataItemResult *)result {
    if (dataLoader == self.httpLoader) {

        NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:result.rawData options:NSJSONReadingMutableContainers error:nil]);
    }
}
@end
