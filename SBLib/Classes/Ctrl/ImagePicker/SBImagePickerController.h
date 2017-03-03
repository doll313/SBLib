/*
#####################################################################
# File    : UI51jobImagePicker.h
# Project : ios_51job
# Created : 2012-11-30
# DevTeam : 51job Development Team
# Author  : thomas (roronoa@foxmail.com)
# Notes   : 图片选择器
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


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/** 进入相册或者拍照的 url */
NS_INLINE SBURLAction *sb_actionurl_imagepicker(int imagePickerType, int sourceType, id ctrl) {
    NSString *actionURL = [NSString stringWithFormat:@"stockbar://SBImagePickerController?imagePickerType=%d&sourceType=%d", imagePickerType, sourceType];
    SBURLAction *action = [SBURLAction actionWithURLString:actionURL];
    [action setObject:ctrl forKey:@"parentController"];
    return action;
}

typedef enum {
	SBImagePickerTypeForPick,      //直接选择
	SBImagePickerTypeForEdit,      //需要剪裁
} SBImagePickerType;

//上传图片的大小
#define MAX_IMAGE_DATA_WIFI          (1024 * 1024 * 1.2f)
#define MAX_IMAGE_DATA_3G          (1024 * 1024 * 0.6f)

/**
 *  选择图片回调
 */
@protocol SBImagePickerDelegate <NSObject>

/** 获取照片 */
- (void)pickedImage:(UIImage *)image;

@optional

/** 获取了图片 如果实现了 则不再自动消失 */
- (void)didFinishPickingMediaWithInfo:(NSDictionary *)info;

/** 退出选图片页面 如果实现了 则不再自动消失 */
- (void)cancelImagePicker:(id)picker;

@end

@interface SBImagePickerController : UIImagePickerController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
}

@property (nonatomic, assign) SBImagePickerType imagePickerType;
@property (nonatomic, assign) id<SBImagePickerDelegate> protocol;
@property (nonatomic, assign) UIViewController *parentController;        //如果需要编辑图片 必传

// 压缩图片
+ (UIImage *)scalePicture:(UIImage *)image;

@end
