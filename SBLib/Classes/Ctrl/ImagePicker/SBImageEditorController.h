/*
 #####################################################################
 # File    : UI51jobImageEditor.h
 # Project : ios_51job
 # Created : 2012-11-30
 # DevTeam : 51job Development Team
 # Author  : thomas (roronoa@foxmail.com)
 # Notes   : 图片编辑器
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

#import "SBImagePickerController.h"

//编辑照片
@interface SBImageEditorController : SBBasicController <UIScrollViewDelegate> {
    @private
}
@property (nonatomic, assign) UIImagePickerControllerSourceType sourceType;
@property (nonatomic, assign) id<SBImagePickerDelegate> delegate;
@property (nonatomic, strong) UIViewController<SBImagePickerDelegate> *parentCtrl;

/** 唯一初始化方法 */
- (id)initWithImage:(UIImage *)image;

@end
