//
//  SBPickerView.h
//  SBLib
//
//  Created by thomas on 15/12/31.
//  Copyright © 2017年 thomas. All rights reserved.
//
//功能：将PickerView，DatePicker封装得更加简单易用，并可搭配UITextField使用（可选)

#import <UIKit/UIKit.h>

extern CGFloat const SBPickerViewHeight;//工具条高度

@interface SBPickerView : UIView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) NSArray *arrayData; //容器数据
@property (strong, nonatomic) UIButton *btnLeft;//外面可控制按钮文案，字体颜色，不要拿到.m文件里去
@property (strong, nonatomic) UIButton *btnRight;
@property (strong, nonatomic) UIView *maskView;//黑色半透明背景，hidden属性可控制该背景是否显示
@property (nonatomic, strong) UITextField *receiverField;//接收数据的TextField（可不设置，如果使用者连回调都懒得处理了，设置他自动帮你处理receiverField的数据）
@property (strong, nonatomic) NSString *strAppending;//有多列时receiverField显示文案的连接符，比如显示男-25岁，则strAppending是“-”

/**正在滚动的某行某列的回调*/
@property (copy, nonatomic) void(^valueChanged)(SBPickerView * picker, NSInteger row, NSInteger component);

/**选择完成回调(数组中存放选中的行，多列则有多个值)*/
@property (copy, nonatomic) void(^valueDidChanged)(SBPickerView * picker, NSArray *value);

/**时间滚动的回调*/
@property (copy, nonatomic) void(^dateChanged)(SBPickerView * picker, NSString *strDate);

/**时间选择完成回调*/
@property (copy, nonatomic) void(^dateDidChanged)(SBPickerView * picker, NSString *strDate);

/**
 *  一般picker
 *
 *  @param component 列数
 *  @param array     当有多列时为包含多个小数组的大数组，当只有一列时是包含字符串的数组
 *
 *  @return SBPickerView
 */
- (id)initWithComponents:(NSInteger)component dataSource:(NSArray *)array height:(CGFloat)height;

/**
 时间picker
 
 @param format 时间格式
 @param height 高度
 @return 时间
 */
- (id)initWithFormat:(NSString *)format height:(CGFloat)height;

//显示
- (void)show;

//消失
- (void)dismiss;

/*
 点击完成-子类重载
 */
- (void)finished:(id)sender;

/**
 设置选中行、列

 @param row 选中列
 @param component 选中列
 @param animated 是否动画
 */
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;

@end
