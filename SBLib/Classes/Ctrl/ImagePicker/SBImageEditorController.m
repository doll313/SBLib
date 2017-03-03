/*
 #####################################################################
 # File    : UI51jobImageEditor.m
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

#import "SBImageEditorController.h"
#import "SBImagePickerController.h"


#define photoMaxWidth       270.0f
#define photoMaxHeight      270.0f

#define curScreenWidth      (([UIScreen mainScreen].bounds.size.width))
#define curScreenHeight     (([UIScreen mainScreen].bounds.size.width) - 20 - 44)

#define UIViewAutoresizingFlexibleAll      (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)

@interface SBImageEditorController() {
    UIScrollView *scrollView;
    UIImageView *imageView;
    
    UIView *whiteCutBox;
    UIView *blueCutBox;
    
    CGFloat cutBoxWidth;
    CGFloat cutBoxHeight;
}

@end

@implementation SBImageEditorController

#pragma mark -
#pragma mark init
- (id)initWithImage:(UIImage *)image {
    self = [super init];

    assert(nil != image);
    
    //剪裁框大小
    cutBoxWidth = curScreenWidth;
    cutBoxHeight =  curScreenWidth;

    scrollView = nil;
    imageView = nil;
    whiteCutBox = nil;
    blueCutBox = nil;
    
    scrollView = [[UIScrollView alloc] init];
    imageView = [[UIImageView alloc] init];
    whiteCutBox = [[UIView alloc] init];
    blueCutBox = [[UIView alloc] init];
    
    imageView.image = image;

    return self;
}

- (void)dealloc {
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航条
    NSString *leftTitle = (self.sourceType == UIImagePickerControllerSourceTypeCamera ? @"重新拍摄" : @"重新选取");
    UIBarButtonItem *_leftItem = [[UIBarButtonItem alloc] initWithTitle:leftTitle style:UIBarButtonItemStylePlain target:self action:@selector(giveUp)];
    UIBarButtonItem *_rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(use)];
    self.navigationItem.leftBarButtonItems = @[];
    self.navigationItem.leftBarButtonItem = _leftItem;
    self.navigationItem.rightBarButtonItem = _rightItem;
    
    //图片素材
    CGSize imageSize = imageView.image.size;
    
    if (imageSize.width < cutBoxWidth) {
        imageSize.height *= cutBoxWidth / imageSize.width;
        imageSize.width   = cutBoxWidth;
    }
    
    if (imageSize.height < cutBoxHeight) {
        imageSize.width *= cutBoxHeight / imageSize.height;
        imageSize.height = cutBoxHeight;
    }
    
    if (imageSize.width > curScreenWidth) {
        imageSize.height *= curScreenWidth / imageSize.width;
        imageSize.width   = curScreenWidth;
    }
    
    if (imageSize.height > curScreenHeight) {
        imageSize.width *= curScreenHeight / imageSize.height;
        imageSize.height = curScreenHeight;
    }
    
    imageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    imageView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:imageView];
    
    CGFloat maxScale = MAX(imageView.image.size.width / cutBoxWidth, imageView.image.size.height / cutBoxHeight);
    CGFloat minScale = MAX(cutBoxWidth / imageSize.width, cutBoxHeight / imageSize.height);
    
    scrollView.frame = CGRectMake((CGRectGetWidth(self.view.bounds) - cutBoxWidth) / 2,
                                  (CGRectGetHeight(self.view.bounds) - cutBoxHeight) / 2,
                                  cutBoxWidth, cutBoxHeight);
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleAll;
    scrollView.contentSize = imageSize;
    scrollView.contentOffset = CGPointMake((imageSize.width - cutBoxWidth) / 2, (imageSize.height - cutBoxHeight) / 2);
    scrollView.delegate = self;
    scrollView.maximumZoomScale = MAX(maxScale, minScale);
    scrollView.minimumZoomScale = minScale;
    scrollView.multipleTouchEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.clipsToBounds = NO;
    scrollView.contentMode = UIViewContentModeCenter;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.zoomScale = minScale;
    [self.view addSubview:scrollView];
    
    
    whiteCutBox.frame = CGRectMake(0, 0, cutBoxWidth, cutBoxHeight);
    whiteCutBox.autoresizingMask = UIViewAutoresizingFlexibleAll;
    whiteCutBox.center = CGPointMake(scrollView.center.x + 1, scrollView.center.y + 1);
    whiteCutBox.layer.borderColor = [UIColor whiteColor].CGColor;
    whiteCutBox.layer.borderWidth = 1;
    whiteCutBox.userInteractionEnabled = NO;
    [self.view addSubview:whiteCutBox];
    
    blueCutBox.frame = CGRectMake(0, 0, cutBoxWidth, cutBoxHeight);
    blueCutBox.autoresizingMask = UIViewAutoresizingFlexibleAll;
    blueCutBox.center = scrollView.center;
    blueCutBox.layer.borderColor = [UIColor blueColor].CGColor;
    blueCutBox.layer.borderWidth = 1;
    blueCutBox.userInteractionEnabled = NO;
    [self.view addSubview:blueCutBox];
}
#pragma mark -
#pragma mark 缩放回调
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return imageView;
}

#pragma mark -
#pragma mark 切图
- (UIImage *)getCutImageNew {
    //起点x轴比例
    float orignXRate = scrollView.contentOffset.x/scrollView.contentSize.width;
    //起点y轴比例
    float orignYRate = scrollView.contentOffset.y/scrollView.contentSize.height;
    //图片缩放比例
    float imageZoomRate = scrollView.contentSize.height/imageView.image.size.height;
    float orignX = imageView.image.size.width*orignXRate;
    float orignY = imageView.image.size.height*orignYRate;
    float boxImgSize = cutBoxHeight/imageZoomRate;
    
    CGRect cutImageRect = CGRectZero;
    cutImageRect.origin.x = orignX;
    cutImageRect.origin.y = orignY;
    cutImageRect.size.width = boxImgSize;
    cutImageRect.size.height = boxImgSize;
    //    CGImageRef imageRef = imageView.image.CGImage;
    //    CGImageRef boxImageRef = CGImageCreateWithImageInRect(imageRef, cutImageRect);
    //    UIGraphicsBeginImageContext(cutImageRect.size);
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextDrawImage(context, cutImageRect, boxImageRef);
    //    UIImage *boxImage = [UIImage imageWithCGImage:boxImageRef];
    //    UIGraphicsEndImageContext();
    //    CGImageRelease(boxImageRef);
    //下面代码百度的 不晓得什么意思。解决上面方法拍照会旋转90度
    CGFloat (^rad)(CGFloat) = ^CGFloat(CGFloat deg) {
        return deg / 180.0f * (CGFloat) M_PI;
    };

    CGAffineTransform rectTransform;
    switch (imageView.image.imageOrientation) {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -imageView.image.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -imageView.image.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -imageView.image.size.width, -imageView.image.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    
    // adjust the transformation scale based on the image scale
    rectTransform = CGAffineTransformScale(rectTransform, imageView.image.scale, imageView.image.scale);
    
    // apply the transformation to the rect to create a new, shifted rect
    CGRect transformedCropSquare = CGRectApplyAffineTransform(cutImageRect, rectTransform);
    // use the rect to crop the image
    CGImageRef imageRef = CGImageCreateWithImageInRect(imageView.image.CGImage, transformedCropSquare);
    // create a new UIImage and set the scale and orientation appropriately
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:imageView.image.scale orientation:imageView.image.imageOrientation];
    // memory cleanup
    CGImageRelease(imageRef);
    
    whiteCutBox.hidden = NO;
    blueCutBox.hidden = NO;
    return result;
}

#pragma mark -
#pragma mark 切图
- (UIImage *)getCutImage {
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect cutImageRect = CGRectZero;
    
    cutImageRect.origin.x = image.scale * blueCutBox.frame.origin.x;
    cutImageRect.origin.y = image.scale * blueCutBox.frame.origin.y;
    cutImageRect.size.width = image.scale * blueCutBox.frame.size.width;
    cutImageRect.size.height = image.scale * blueCutBox.frame.size.height;
    
    CGImageRef imageRef = image.CGImage;
    CGImageRef boxImageRef = CGImageCreateWithImageInRect(imageRef, cutImageRect);
    UIGraphicsBeginImageContext(cutImageRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, cutImageRect, boxImageRef);
    UIImage *boxImage = [UIImage imageWithCGImage:boxImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(boxImageRef);
    
    CGSize cutImageSize = boxImage.size;
    
    if (imageView.image.size.width < imageView.frame.size.width) {
        cutImageSize = boxImage.size;
        CGFloat scale = imageView.image.size.width / imageView.frame.size.width;
        
        cutImageSize.width  *= scale;
        cutImageSize.height *= scale;
    }
    
    if (cutImageSize.width > photoMaxWidth) {
        cutImageSize.width  = photoMaxWidth;
        cutImageSize.height = photoMaxHeight;
    }
    
    if (cutImageSize.width > 0 && cutImageSize.height > 0) {
        UIGraphicsBeginImageContext(cutImageSize);
        [boxImage drawInRect:CGRectMake(0, 0, cutImageSize.width, cutImageSize.height)];
        boxImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    whiteCutBox.hidden = NO;
    blueCutBox.hidden = NO;
    
    return boxImage;
}

- (void)cutImageAndSend {
    UIImage *image = [self getCutImageNew];

    if (self.protocol != nil && [self.protocol respondsToSelector:@selector(pickedImage:)]) {
        [self.protocol pickedImage:image];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)giveUp {
    [self.navigationController popViewControllerAnimated:NO];
    [self.parentCtrl sb_modalCtrl:sb_actionurl_imagepicker(SBImagePickerTypeForEdit, self.sourceType, self.parentCtrl)];
}

- (void)use {
	whiteCutBox.hidden = YES;
	blueCutBox.hidden = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self cutImageAndSend];
    });
}

@end
