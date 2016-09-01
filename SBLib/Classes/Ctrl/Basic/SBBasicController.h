/*
#####################################################################
# File    : SBBasicController.h
# Project : 
# Created : 2015-03-16
# DevTeam : Thomas Develop
# Author  : 
# Notes   : 工程中所有 controller 都要继承于此
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

/**工程中所有 controller 都要继承于此**/

@interface SBBasicController : UIViewController {
}

@property (nonatomic, assign) BOOL observerKeyboard;        //检测键盘


/** 初始化UI界面 */
- (void)customView;

/** 返回上一级 (已经实现，有特殊要求可以重写)*/
- (void)sbCtrlPopNav:(id)sender;

//键盘弹出
- (void)keyboardDidShow:(NSNotification *)notification;

//键盘消失
- (void)keyboardWillHide:(NSNotification *)notification;

//键盘出现 子类一般不可重写
- (void)observerKeyboardDidShow:(NSNotification *)notification ;

//键盘消失 子类一般不可重写
- (void)observerKeyboardWillHide:(NSNotification *)notification;
@end
