/*
 #####################################################################
 # File    : UI51jobImagePicker.m
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

#import "SBImagePickerController.h"
#import "SBImageEditorController.h"

@interface SBImagePickerController()

@end

@implementation SBImagePickerController

- (id)init {
    self = [super init];

    self.delegate = self;
    self.allowsEditing = NO;

    return self;
}

- (void)dealloc {
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

//获取好照片后的代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    //代理自己处理获取时间
    if (self.parentController != nil && [self.parentController respondsToSelector:@selector(didFinishPickingMediaWithInfo:)]) {
        [self.parentController didFinishPickingMediaWithInfo:info];
    }
    else {
        UIImage *image = info[UIImagePickerControllerOriginalImage];

        if (nil == image) {
            [self sb_showAlert:@"未获取到图片"];
            return;
        } else if(image.scale * image.size.width < 74 || image.scale * image.size.height < 74){
            [self sb_showAlert:@"原图太小，请重新选择"];
            return;
        }

        if (self.imagePickerType == SBImagePickerTypeForEdit) { //修改头像
            [self dismissViewControllerAnimated:YES completion:^{
                //剪裁图片 简历的图片和粉丝团的图片尺寸不一样
                SBImageEditorController *eCtrl = [[SBImageEditorController alloc] initWithImage:image];
                eCtrl.parentCtrl = self.parentController;
                eCtrl.sourceType = self.sourceType;
                [self.parentController.navigationController pushViewController:eCtrl animated:YES];
            }];
        }else{
            //选取照片
            assert(self.imagePickerType == SBImagePickerTypeForPick);
            if (self.parentController != nil && [self.parentController respondsToSelector:@selector(pickedImage:)]) {
                [self.parentController pickedImage:image];
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (self.parentController != nil && [self.parentController respondsToSelector:@selector(cancelImagePicker:)]) {
        [self.parentController cancelImagePicker:picker];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


//压缩图片
+ (UIImage *)scalePicture:(UIImage *)image{
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75f);
    //当前网络状态

    
    CGFloat updateFileMaxRam = MAX_IMAGE_DATA_3G;

    //在这里有些手机会有memery waring，然后再对imagedata进行操作会crash
    //压缩图片需要一定的时间，视手机而定
    @try {
        //图片的大小（多少kb）
        NSUInteger length = [imageData length];
        
        //想要的缩放比
        if (updateFileMaxRam < length) {
            //图片实际大小
            CGFloat imageWidth = image.size.width;
            CGFloat imageHeight = image.size.height;
            
            CGFloat scale = sqrtf(updateFileMaxRam / length);
            
            //缩放到这个尺寸
            image = [image sb_scalingForSize:CGSizeMake(imageWidth * scale, imageHeight * scale)];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"压缩图片 exception %@", [exception description]);
    }
    
    return image;
}

@end
