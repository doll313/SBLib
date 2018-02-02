//
//  SBApiRecordCell.m
//  EMLive
//
//  Created by roronoa on 2017/3/6.
//  Copyright © 2017年 roronoa. All rights reserved.
//

#import "SBApiRecordCell.h"
#import "UIView+SBMODULE.h"

@implementation SBApiRecordCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];

    self.stateView = [UIView new];
    [self.contentView addSubview:self.stateView];

    self.startLbl = [UILabel new];
    self.startLbl.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.startLbl];

    self.lengthLbl = [UILabel new];
    self.lengthLbl.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:self.lengthLbl];

    self.intervalLbl = [UILabel new];
    self.intervalLbl.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:self.intervalLbl];

    self.methodLbl = [UILabel new];
    self.methodLbl.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.methodLbl];

    self.domainLbl = [UILabel new];
    self.domainLbl.numberOfLines = 3;
    self.domainLbl.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.domainLbl];
    
    self.codeLbl = [UILabel new];
    self.codeLbl.font = [UIFont boldSystemFontOfSize:18];
    self.codeLbl.textColor = [UIColor whiteColor];
    self.codeLbl.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.codeLbl];

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.startLbl sizeToFit];
    [self.intervalLbl sizeToFit];
    [self.lengthLbl sizeToFit];

    self.stateView.frame = CGRectMake(0, 0, 6, SBApiRecordCellHeight);
    self.codeLbl.frame = CGRectMake(self.width - SBApiRecordCellHeight, 0, SBApiRecordCellHeight, SBApiRecordCellHeight);
    self.startLbl.frame = CGRectMake(self.stateView.right + 10, 0, self.startLbl.width, 20);
    self.lengthLbl.frame = CGRectMake(self.codeLbl.left - 10 - self.lengthLbl.width, 0, self.lengthLbl.width, 20);
    self.intervalLbl.frame = CGRectMake(self.lengthLbl.left - 10 - self.intervalLbl.width, 0, self.intervalLbl.width, 20);
    self.methodLbl.frame = CGRectMake(self.stateView.right + 10, 20, 44, SBApiRecordCellHeight - 20);
    self.domainLbl.frame = CGRectMake(self.methodLbl.right + 10, 20, self.codeLbl.left - self.methodLbl.right - 20, SBApiRecordCellHeight - 20);
}

- (void)bindCellData {
    [super bindCellData];

    SBHttpTask *task = (SBHttpTask *)[self.cellDetail getObject:__KEY_CELL_CODE];

    NSURLRequest *request = task.sessionDataTask.currentRequest;
    NSURLResponse *response = task.sessionDataTask.response;

    NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
    NSString *absoluteString = request.URL.absoluteString;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm:ss";
    NSString *time = [formatter stringFromDate:task.startDate];

    self.stateView.backgroundColor = [self statusColor:statusCode];
    self.startLbl.text = [NSString stringWithFormat:@"开始:%@", time];
    self.intervalLbl.text = [NSString stringWithFormat:@"响应:%.2fs", task.durationTime];
    self.lengthLbl.text = [NSString stringWithFormat:@"接收:%zdkb", task.sessionDataTask.countOfBytesReceived / 1024];
    self.methodLbl.text = [NSString stringWithFormat:@"[%@]", request.HTTPMethod];
    self.domainLbl.text = [NSString stringWithFormat:@"URL:%@", absoluteString];
    self.codeLbl.text = @(statusCode).stringValue;
    self.codeLbl.backgroundColor = [self statusColor:statusCode];
    
}

- (UIColor *)statusColor:(NSInteger)statusCode {
    if (statusCode >= 200 && statusCode < 300) {
        return [UIColor greenColor];
    }
    else if (statusCode >= 300 && statusCode < 400) {
        return [UIColor cyanColor];
    }
    else if (statusCode >= 400 && statusCode < 500) {
        return [UIColor orangeColor];
    }
    else if (statusCode >= 500 && statusCode < 600) {
        return [UIColor redColor];
    }
    else  {
        return [UIColor grayColor];
    }
}

@end
