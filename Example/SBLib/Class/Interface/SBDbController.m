//
//  SBDbController.m
//  SBLib
//
//  Created by roronoa on 2017/5/26.
//  Copyright © 2017年 yuki.wang. All rights reserved.
//

#import "SBDbController.h"
#import "SBConstant.h"

@interface SBDbController ()

@end

@implementation SBDbController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *b = [UIButton new];
    b.frame = CGRectMake(10, 10, 120, 56);
    [b setTitle:@"设置" forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(storeInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];



    UIButton *c = [UIButton new];
    c.frame = CGRectMake(10, 90, 120, 56);
    [c setTitle:@"读取" forState:UIControlStateNormal];
    [c setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [c addTarget:self action:@selector(readInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:c];

}

- (void)storeInfo:(id)sender {
    DataItemDetail *detail = [DataItemDetail new];

    //设置字体颜色
    NSString *str1 = @"设置字体颜色";
    NSDictionary *dictAttr1 = @{NSForegroundColorAttributeName:[UIColor purpleColor]};
    NSAttributedString *attr1 = [[NSAttributedString alloc]initWithString:str1 attributes:dictAttr1];

    NSString *str2 = @"设置字符间距";
    NSDictionary *dictAttr2 = @{NSKernAttributeName:@(4)};
    NSAttributedString *attr2 = [[NSAttributedString alloc]initWithString:str2 attributes:dictAttr2];

    [detail setString:@"123" forKey:@"s1"];
    [detail setString:@"abcdefg" forKey:@"s2"];
    [detail setString:@"🐶🦁🐮🐷🐽🐸🐙" forKey:@"s3"];
    [detail setBool:YES forKey:@"b1"];
    [detail setInt:999 forKey:@"n1"];
    [detail setInt:456 forKey:@"n2"];
    [detail setArray:@[@"1", @"2", @"3"] forKey:@"l1"];
    [detail setATTString:attr1 forKey:@"a1"];
    [detail setATTString:attr2 forKey:@"a2"];

    NSLog(@"设置\r\n");
    [detail dump];

    [[SBAppCoreInfo getCacheDB] setDetailValue:STORE_CACHE_USERINFO dataKey:@"detail" data:detail];
}

- (void)readInfo:(id)sender {
    DataItemDetail *detail = [[SBAppCoreInfo getCacheDB] getDetailValue:STORE_CACHE_USERINFO dataKey:@"detail"];
    NSLog(@"读取\r\n");
    [detail dump];
}

@end
