/*
 #####################################################################
 # File    : UIImageCagegory.m
 # Project : 
 # Created : 2013-03-30
 # DevTeam : thomas only one
 # Author  : thomas
 # Notes   : 自动缩放图片大小
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

#import "UIImage+SBMODULE.h"
#include <QuartzCore/QuartzCore.h>

#define __SB_COLOR_BARPROTRAIT_BG       RGB(56, 100, 190)
#define __SB_FONT_BARPROTRAIT           30.0f
#define __SB_BOARD_BARPROTRAIT          120.0f

@implementation UIImage (sbmodule)

//压缩图片到这个尺寸，大小会跟着变 等比的
- (UIImage*)sb_scalingForSize:(CGSize)targetSize {
    CGFloat width = self.size.width;                //现在的宽
    CGFloat height = self.size.height;
    CGFloat targetWidth = targetSize.width;          //想要的宽
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaledWidth = targetWidth;      //缩放后的宽 （因为给的数据不一定等比例缩放大小，所以额外有一个局部变量）
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(self.size, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        //缩放比例
        CGFloat scaleFactor = (widthFactor > heightFactor) ? widthFactor : heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) 
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5f;
        else
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5f;
    }      
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [self drawInRect:thumbnailRect];
    
    //压缩后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)sb_scalingToAspectRatioForTargetWidth:(CGFloat)targetWidth {
    CGFloat scale = [UIScreen mainScreen].scale;
    float oldWidth = self.size.width;
    float scaleFactor = targetWidth / oldWidth;
    
    float newHeight = self.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(newWidth, newHeight),NO,scale);
    [self drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//将image 画成圆形   但是性能消耗大 不要在单元格复用场景，或者大量图片场景使用 好处是圆角干净 不带毛刺
- (UIImage *)sb_drawRound {
    CGFloat width =self.size.width;
    CGFloat height =self.size.height;

    CGFloat radius = width / 2;
    if (height < width) {
        radius = height / 2;
    }

    UIBezierPath *maskShape = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,0, width, height) cornerRadius:radius];

    UIGraphicsBeginImageContextWithOptions(self.size,NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGContextSaveGState(ctx);
    CGContextAddPath(ctx, maskShape.CGPath);
    CGContextClip(ctx);

    CGContextTranslateCTM(ctx,0, height);
    CGContextScaleCTM(ctx,1.0,-1.0);
    CGContextDrawImage(ctx,CGRectMake(0,0, width, height),self.CGImage);
    CGContextRestoreGState(ctx);

    UIImage*resultingImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

//绘制带圆角的image
- (UIImage *)sb_roundedImage:(CGFloat)radius size:(CGSize)size {
    CGFloat scale = self.scale;
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect imageRect = (CGRect){0,0,size};
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:imageRect cornerRadius:radius];
    CGContextAddPath(context, path.CGPath);
    CGContextEOClip(context);
    [self drawInRect:imageRect];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;

}

- (UIImage *)sb_roundCorner:(CGFloat)radius {
    return [self sb_roundedImage:radius size:self.size];
}

/** 变圆 */
- (UIImage *)sb_roundCorner {
    return [self sb_roundedImage:self.size.width size:self.size];
}

+ (NSString *)sb_typeForImageData:(NSData *)imageData {
    uint8_t c;
    [imageData getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}

+ (UIImage *)sb_creatImageByView:(UIView *)view {
    CGRect rect = view.frame;
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

//压缩内存
- (UIImage *)sb_zipImage:(CGFloat)maxRam {
    NSData *imageData = UIImageJPEGRepresentation(self, 0.75f);
    
    //在这里有些手机会有memery waring，然后再对imagedata进行操作会crash
    //压缩图片需要一定的时间，视手机而定
    @try {
        //图片的大小（多少kb）
        NSUInteger length = [imageData length];
        
        //想要的缩放比
        if (maxRam < length) {
            //图片实际大小
            CGFloat imageWidth = self.size.width;
            CGFloat imageHeight = self.size.height;
            
            CGFloat scale = sqrtf(maxRam / length);
            
            //缩放到这个尺寸
            return [self sb_scalingForSize:CGSizeMake(imageWidth * scale, imageHeight * scale)];
        }

        return self;
    }
    @catch (NSException *exception) {
        //        NSLog(@"exception %@", [exception description]);
        return self;
    }
}

- (UIImage *)sb_imageWithTintColor:(UIColor *)tintColor
{
    return [self sb_imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *)sb_imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

+(UIImage *)sb_imageWithColor:(UIColor *)aColor{
    return [UIImage sb_imageWithColor:aColor withFrame:CGRectMake(0, 0, 1, 1)];
}

+(UIImage *)sb_imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame{
    UIGraphicsBeginImageContext(aFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [aColor CGColor]);
    CGContextFillRect(context, aFrame);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)sb_imageWithColor:(UIColor *)color
                          size:(CGSize)size
                       corners:(UIRectCorner)corners
                   cornerRadii:(CGSize)cornerRadii
                   borderWidth:(CGFloat)borderWidth
                   borderColor:(UIColor *)borderColor {//根据颜色生成带圆角和边框的图片
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:cornerRadii];
    [path closePath];
    [path addClip];

    [color setFill];
    [path fill];

    path.lineWidth = borderWidth;
    [borderColor setStroke];
    [path stroke];

    UIImage *currentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return currentImage;
}

/** 文字转图片 */
+(UIImage *)sb_imageFromText:(NSString *)string size:(CGSize)size font:(NSInteger)fontsize textColor:(UIColor *)textColor backColor:(UIColor *)backColor{
    
    NSString *text = string;
    NSUInteger length = text.length;
    if (length == 0) {
        return nil;
    }
    
    // set the font type and size
    UIFont *font = [UIFont systemFontOfSize:fontsize];
    CGSize textsize  = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    if (textsize.width > size.width || textsize.height > size.height) {
        size = textsize;
    }
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGFloat textMinX = floor((size.width - textsize.width)/2);
    textMinX  = textMinX > 0 ? textMinX : 0;
    CGFloat textMinY = floor((size.height - textsize.height)/2);
    textMinY = textMinY > 0 ? textMinY : 0;
    CGRect textRect = CGRectMake(textMinX, textMinY, textsize.width, textsize.height);
    
    
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddRect(ctx, rect);
    CGContextSetFillColorWithColor(ctx, backColor.CGColor);
    CGContextFillPath(ctx);
    
    [textColor set];
    [text drawInRect:textRect withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:textColor}];
    
    // transfer image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//渐变色
+ (UIImage*)sb_drawGradientInRect:(CGSize)size withColors:(NSArray*)colors {
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) [ar addObject:(id)c.CGColor];
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    
    //     CGContextClipToRect(context, rect);
    
    CGPoint start = CGPointMake(0.0, 0.0);
    CGPoint end = CGPointMake(0.0, size.height);
    
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    
    // Clean up
    CGColorSpaceRelease(colorSpace); // Necessary?
    UIGraphicsEndImageContext(); // Clean up
    return image;
}

//渐变色
+ (UIImage *)sb_radialGradientImage:(CGSize)size start:(float)start end:(float)end centre:(CGPoint)centre radius:(float)radius{
    // Initialise
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    
    // Create the gradient's colours
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { start,start,start, 1.0,  // Start color
        end,end,end, 1.0 }; // End color
    
    CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef myGradient = CGGradientCreateWithColorComponents (myColorspace, components, locations, num_locations);
    
    // Normalise the 0-1 ranged inputs to the width of the image
    CGPoint myCentrePoint = CGPointMake(centre.x * size.width, centre.y * size.height);
    float myRadius = MIN(size.width, size.height) * radius;
    
    // Draw it!
    CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), myGradient, myCentrePoint,
                                 0, myCentrePoint, myRadius,
                                 kCGGradientDrawsAfterEndLocation);
    
    // Grab it as an autoreleased image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Clean up
    CGColorSpaceRelease(myColorspace); // Necessary?
    CGGradientRelease(myGradient); // Necessary?
    UIGraphicsEndImageContext(); // Clean up
    return image;
}


@end
