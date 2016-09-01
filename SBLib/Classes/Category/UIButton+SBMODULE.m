/*
 #####################################################################
 # File    : UIButtonCagegory.m
 # Project :
 # Created : 2013-03-30
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

#import "UIButton+SBMODULE.h"

@implementation UIButton (sbmodule)

- (void)sb_titleLeftIcon {
    UIImage *image = [self imageForState:UIControlStateNormal];
    
    [self setContentEdgeInsets:UIEdgeInsetsZero];
    [self setImageEdgeInsets:UIEdgeInsetsZero];
    [self setTitleEdgeInsets:UIEdgeInsetsZero];
    [self.titleLabel sizeToFit];
    
    CGRect titleRect = [self titleRectForContentRect:self.bounds];
    CGRect imageRect = [self imageRectForContentRect:self.bounds];
    
    CGFloat imagePaddingV = (self.frame.size.height - image.size.height) / 2;
    CGFloat titlePaddingV = (self.frame.size.height - titleRect.size.height) / 2;
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(imagePaddingV,
                                              titleRect.origin.x + titleRect.size.width - imageRect.origin.x - imageRect.size.width - 10,
                                              imagePaddingV,
                                              self.frame.size.width - titleRect.origin.x - titleRect.size.width)];
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(titlePaddingV,
                                              imageRect.origin.x - titleRect.origin.x + 10,
                                              titlePaddingV,
                                              self.frame.size.width - imageRect.origin.x - titleRect.size.width)];
}

//图标在左，文字在右
- (void)sb_titleRightIcon {
    UIImage *image = [self imageForState:UIControlStateNormal];
    
    [self setContentEdgeInsets:UIEdgeInsetsZero];
    [self setTitleEdgeInsets:UIEdgeInsetsZero];
    [self.titleLabel sizeToFit];
    
    CGRect titleRect = [self titleRectForContentRect:self.bounds];
    CGRect imageRect = [self imageRectForContentRect:self.bounds];
    
    CGFloat imagePaddingV = (self.frame.size.height - image.size.height) / 2;
    CGFloat paddingH = (self.frame.size.width - titleRect.size.width - imageRect.size.width) / 2;
    
    //图片位置
    [self setImageEdgeInsets:UIEdgeInsetsMake(imagePaddingV,
                                              paddingH + titleRect.size.width,
                                              imagePaddingV,
                                              0
                                              )];
    
    
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
}

- (void)sb_titleUnderIcon {
    [self sb_titleUnderIcon:0];
}

- (void)sb_titleUnderIcon:(CGFloat)paddingText {
    UIImage *image = [self imageForState:UIControlStateNormal];
    
    [self setContentEdgeInsets:UIEdgeInsetsZero];
    [self setImageEdgeInsets:UIEdgeInsetsZero];
    [self setTitleEdgeInsets:UIEdgeInsetsZero];
    
    [self.titleLabel sizeToFit];
    
    CGRect titleRect = [self titleRectForContentRect:self.bounds];
    
    CGFloat imageHeight = image.size.height;
    CGFloat imageWidth = image.size.width;
    CGFloat paddingV = (self.frame.size.height - paddingText - imageHeight - titleRect.size.height) / 2;
    CGFloat paddingH = (self.frame.size.width - imageWidth) / 2;
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(paddingV, paddingH, paddingV + titleRect.size.height, paddingH)];
    
    CGRect imageRect = [self imageRectForContentRect:self.bounds];
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(imageRect.origin.y + imageRect.size.height + paddingText,
                                              0 - imageRect.size.width,
                                              imageRect.origin.y - paddingText,
                                              0)];
}

- (void)sb_titleUnderIcon:(CGFloat)paddingText imageSize:(CGSize)imageSize imageY:(float)imageY{
    UIImage *image = [self imageForState:UIControlStateNormal];
    
    CGFloat paddingV = imageY;
    CGFloat paddingB = CGRectGetHeight(self.bounds) - paddingV - imageSize.height;
    CGFloat paddingH = (self.frame.size.width - imageSize.width) / 2;
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(paddingV, paddingH, paddingB, paddingH)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(paddingV + imageSize.height + paddingText,
                                              0 - image.size.width,
                                              0,
                                              0)];
}

- (void)sb_subViewToRightTop:(UIView *)view {
    if (nil == view) {
        return;
    }
    
    CGRect rect = view.frame;
    CGRect imageRect = [self imageRectForContentRect:self.bounds];
    
    rect.origin.y = imageRect.origin.y - rect.size.height / 2;
    rect.origin.x = imageRect.origin.x + imageRect.size.width - rect.size.width / 2;
    
    [self bringSubviewToFront:view];
    
    view.frame = rect;
}
@end
