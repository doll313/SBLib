//
//  ELQRCodeTool.h
//  ELQRCodeExample
//
//  Created by thomas on 16/12/2.
//  Copyright © 2016年 thomas. All rights reserved.

//网上原封不动抄的  by thomas

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
#import <AVFoundation/AVFoundation.h>

@interface SBQRCodeTool : NSObject

/** 生成一张普通的二维码 */
+ (UIImage *)sb_generateWithDefaultQRCodeData:(NSString *)data imageViewWidth:(CGFloat)imageViewWidth;
/** 生成一张带有logo的二维码（logoScaleToSuperView：相对于父视图的缩放比取值范围0-1；0，不显示，1，代表与父视图大小相同） */
+ (UIImage *)sb_generateWithLogoQRCodeData:(NSString *)data logoImageName:(NSString *)logoImageName logoScaleToSuperView:(CGFloat)logoScaleToSuperView;
/** 生成一张彩色的二维码 */
+ (UIImage *)sb_generateWithColorQRCodeData:(NSString *)data backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor;

/** 扫描二维码 */
+ (void)sb_scanningQRCodeOutsideVC:(UIViewController *)outsideVC session:(AVCaptureSession *)session previewLayer:(AVCaptureVideoPreviewLayer *)previewLayer;

@end
