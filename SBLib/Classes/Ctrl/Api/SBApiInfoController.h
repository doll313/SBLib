//
//  SBApiInfoController.h
//  SBLib
//
//  Created by roronoa on 2017/3/7.
//  Copyright © 2017年 roronoa. All rights reserved.
//

#import "SBBasicController.h"   //统一界面父类

/** 请求详情 **/
@interface SBApiInfoController : SBBasicController

@property (nonatomic, strong) UITextView *tv;
@property (nonatomic, strong) NSString *textString;

@end
