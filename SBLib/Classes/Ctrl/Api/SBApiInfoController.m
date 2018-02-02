//
//  SBApiInfoController.m
//  EMLive
//
//  Created by roronoa on 2017/3/7.
//  Copyright © 2017年 roronoa. All rights reserved.
//

#import "SBApiInfoController.h"
#import "UIAlertView+SB.h"
#import "UIViewController+SBMODULE.h"       //UIViewController 扩展

@interface SBApiInfoController ()


@end

@implementation SBApiInfoController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.tv.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"HttpTask记录";

    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendInfo:)];
    self.navigationItem.rightBarButtonItem = sendItem;

    NSString *string = [self.textString copy];
    if (string.length >= 10000) {
        string = [string substringToIndex:9999];
    }

    self.tv = [[UITextView alloc] init];
    self.tv.font = [UIFont systemFontOfSize:14];
    self.tv.text= string;
    self.tv.editable = NO;
    self.tv.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    [self.view addSubview:self.tv];
}

- (void)sendInfo:(id)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    dateString = [dateString stringByAppendingString:@".txt"];

    NSFileManager *manager = [NSFileManager defaultManager];
    //获取document路径,括号中属性为当前应用程序独享
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:dateString];
    if (![manager fileExistsAtPath:filePath]) {
        [manager createFileAtPath:filePath contents:nil attributes:nil];

    }

    [self sb_showTips:@"正在分析数据..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.textString writeToFile:filePath atomically:YES encoding:4 error:nil];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self sb_hiddenTips];
            [self sb_shareDocumentPath:filePath];
        });

    });

}
@end
