/*
 #####################################################################
 # File    : UIImageCagegory.h
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

#import "UIView+SBMODULE.h"

//为SDK自带的 UIImage 类添加一些实用方法
@interface UIImage (sbmodule)

/**压缩到目标尺寸（像素大小）*/
- (UIImage *)sb_scalingForSize:(CGSize)targetSize;

/** 缩放图片会根据是否retina缩放图片 */
- (UIImage *)sb_scalingToAspectRatioForTargetWidth:(CGFloat)targetWidth;

/**绘制带圆角的image*/
- (UIImage *)sb_roundedImage:(CGFloat)radius size:(CGSize)size;

/** 变圆 */
- (UIImage *)sb_roundCorner:(CGFloat)radius;

/** 变圆 */
- (UIImage *)sb_roundCorner;

/** 将image 画成圆形   但是性能消耗大 不要在单元格复用场景，或者大量图片场景使用 好处是圆角干净 不带毛刺 */
- (UIImage *)sb_drawRound;

/**猜测图像的格式*/
+ (NSString *)sb_typeForImageData:(NSData *)imageData;

//UIView---->UIImage
+ (UIImage *)sb_creatImageByView:(UIView *)view;

//压缩内存
- (UIImage *)sb_zipImage:(CGFloat)maxRam;

/** 纯色填充 */
- (UIImage *)sb_imageWithTintColor:(UIColor *)tintColor;

/** 纯色图片 */
+(UIImage *)sb_imageWithColor:(UIColor *)aColor;
+(UIImage *)sb_imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;

/**根据颜色生成带圆角和边框的图片*/
+ (UIImage *)sb_imageWithColor:(UIColor *)color size:(CGSize)size corners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/** 文字转图片 */
+(UIImage *)sb_imageFromText:(NSString *)string size:(CGSize)size font:(NSInteger)fontsize textColor:(UIColor *)textColor backColor:(UIColor *)backColor;

//渐变色
+ (UIImage*)sb_drawGradientInRect:(CGSize)size withColors:(NSArray*)colors;

//渐变色
+ (UIImage *)sb_radialGradientImage:(CGSize)size start:(float)start end:(float)end centre:(CGPoint)centre radius:(float)radius;
@end
