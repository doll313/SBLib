//
//  SBApiRecordCell.h
//  SBLib
//
//  Created by roronoa on 2017/3/6.
//  Copyright © 2017年 roronoa. All rights reserved.
//

#import "SBDataTableCell.h"

#define SBApiRecordCellHeight    72.0f

/** api 显示单元格 **/
@interface SBApiRecordCell :SBDataTableCell

@property (nonatomic, strong) UIView *stateView;
@property (nonatomic, strong) UILabel *startLbl;
@property (nonatomic, strong) UILabel *intervalLbl;
@property (nonatomic, strong) UILabel *lengthLbl;
@property (nonatomic, strong) UILabel *methodLbl;
@property (nonatomic, strong) UILabel *domainLbl;
@property (nonatomic, strong) UILabel *codeLbl;

@end
