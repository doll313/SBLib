/*
#####################################################################
# File    : BasicController.m
# Project : 
# Created : 2014-05-22
# DevTeam : Thomas Develop
# Author  : 
# Notes   :
#####################################################################
### Change Logs   ###################################################
#####################################################################
---------------------------------------------------------------------
# Date  :
# Author:
# Notes :
#
#####################################################################
*/

#import "SBBasicController.h"

static BOOL _ctrl_alloc_debug;

@interface SBBasicController() {
@private
    BOOL _customed;
    CGFloat viewHeight;       /**界面高度**/
}

@end;

@implementation SBBasicController

/** 初始化变量 */
- (id)init {
    self = [super init];
    
    //默认隐藏底部tabbar
    self.hidesBottomBarWhenPushed = YES;
    
    _customed = NO;
    
    //调试单元格内存
    _ctrl_alloc_debug = [[NSUserDefaults standardUserDefaults] boolForKey:DEBUG_MALLOC_FOR_TABLE_CELL];
    if (_ctrl_alloc_debug) {
        NSLog(@"ctrl-malloc[init]: %@", NSStringFromClass([self class]));
    }
    
	return self;
}

/** 释放资源 */
- (void)dealloc {
    //调试单元格内存
    if (_ctrl_alloc_debug) {
        NSLog(@"ctrl-malloc[dealloc]: %@", NSStringFromClass([self class]));
    }
    
    
    if (self.observerKeyboard) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //记录界面的高度
    if (viewHeight == 0) {
        viewHeight = CGRectGetHeight(self.view.frame);
    }
}

/** 初始化UI界面 */
- (void)customView {
    //视图背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    //添加手势返回 IOS7及以上系统才能使用
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f){
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/** 视图加载完成 */
- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
	if (!_customed) {
		_customed = YES;
        
        //代码加载控件或数据
		[self customView];
	}
}

//返回上一级
- (void)sbCtrlPopNav:(id)sender {
    [self sb_colseCtrl];
}

/** 监听键盘 **/
- (void)setObserverKeyboard:(BOOL)observerKeyboard {
    _observerKeyboard=observerKeyboard;
    if (observerKeyboard) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observerKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observerKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        //键盘
        [self.view sb_setTapGesture:self action:@selector(hideKeyBoard)];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}

//隐藏键盘
- (void)hideKeyBoard {
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark 键盘
//键盘弹出
- (void)observerKeyboardDidShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyBoardHeight = CGRectGetHeight(keyboardRect);
//    keyBoardHeight = MIN(216, keyBoardHeight);
    
    if (keyBoardHeight != 0) {
        CGFloat newHeight = viewHeight - keyBoardHeight;
        [self.view sb_setHeight:newHeight];
        [UIView animateWithDuration:0.1f animations:^{
        } completion:^(BOOL finished) {
            [self keyboardDidShow:notification];
        }];
    }
}

//键盘弹出
- (void)keyboardDidShow:(NSNotification *)notification {
    
}

//键盘消失
- (void)observerKeyboardWillHide:(NSNotification *)notification {
    [self.view sb_setHeight:viewHeight];
    [self keyboardWillHide:notification];
}
//键盘消失
- (void)keyboardWillHide:(NSNotification *)notification {
    
}

@end
