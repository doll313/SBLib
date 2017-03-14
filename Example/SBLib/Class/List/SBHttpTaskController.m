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


    self.httpLoader = [[SBHttpDataLoader alloc] initWithURL:@"http://www.weather.com.cn/data/cityinfo/101010100.html" httpMethod:@"GET" delegate:self];

}


/** onReceived方法：在数据装载器装载数据结束后调用的方法 */
- (void)dataLoader:(SBHttpDataLoader *)dataLoader onReceived:(DataItemResult *)result {
    if (dataLoader == self.httpLoader) {

        NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:result.rawData options:NSJSONReadingMutableContainers error:nil]);
    }
}
@end
