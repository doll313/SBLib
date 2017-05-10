//
//  SBHttpTaskController.m
//  SBLib
//
//  Created by roronoa on 2017/3/2.
//  Copyright © 2017年 yuki.wang. All rights reserved.
//

#import "SBHttpTaskController.h"
#import "SBCONSTANT.h"

@interface SBHttpTaskController ()

@property (nonatomic, strong) SBHttpDataLoader *httpLoader;

@end

@implementation SBHttpTaskController

- (void)dealloc {
    [self.httpLoader stopLoading];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    SBWS(__self)
    self.httpLoader = [[SBHttpDataLoader alloc] initWithURL:@"http://www.weather.com.cn/data/cityinfo/101010100.html" httpMethod:@"GET" delegate:nil];
    self.httpLoader.onReceived = ^(SBHttpDataLoader * _Nonnull loader, DataItemResult * _Nonnull result) {
        [__self dataLoader:loader onReceived:result];
    };

}


/** onReceived方法：在数据装载器装载数据结束后调用的方法 */
- (void)dataLoader:(SBHttpDataLoader *)dataLoader onReceived:(DataItemResult *)result {
    if (dataLoader == self.httpLoader) {

        NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:result.rawData options:NSJSONReadingMutableContainers error:nil]);
    }
}
@end
