/*
 #####################################################################
 # File    : NSAttributedString+Attributes.h
 # Project :
 # Created : 2013-06-19
 # DevTeam : 
 # Author  : thomas
 # Notes   : NSAttributedString扩展 这个跟图文混排强相关的扩展我特意放这个文件夹
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
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

#if __has_feature(objc_arc)
#define BRIDGE_CAST __bridge
#define BRIDGE_TRANSFER_CAST __bridge_transfer
#else
#define BRIDGE_CAST
#define BRIDGE_TRANSFER_CAST
#endif

//arc 的内存管理
#if !__has_feature(objc_arc)
#define BRIDGE_CAST
#define MRC_RETAIN(x) [x retain]
#define MRC_RELEASE(x) [x release]; x = nil
#define MRC_AUTORELEASE(x) [x autorelease]
#else
#define BRIDGE_CAST __bridge
#define MRC_RETAIN(x) (x)
#define MRC_RELEASE(x)
#define MRC_AUTORELEASE(x) (x)
#endif

extern NSString* kOHLinkAttributeName;
extern NSString* kOHEmoitAttributeName;

//NSAttributedString扩展
@interface NSAttributedString (OHCommodityConstructors)
//初始化方法
+(id)attributedStringWithString:(NSString*)string;
+(id)attributedStringWithAttributedString:(NSAttributedString*)attrStr;

//自适应大小
-(CGSize)sizeConstrainedToSize:(CGSize)maxSize;

//自适应大小
-(CGSize)sizeConstrainedToSize:(CGSize)maxSize fitRange:(NSRange*)fitRange;

//在特定位置显示字体
-(CTFontRef)fontAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange;

//在特定位置显示颜色
-(UIColor*)textColorAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange;

//在特定位置显示下划线
-(BOOL)textIsUnderlinedAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange;

//在特定位置显示下划线
-(int32_t)textUnderlineStyleAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange;

//在特定位置显示粗体
-(BOOL)textIsBoldAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange;

//在特定位置显示文字格式
-(CTTextAlignment)textAlignmentAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange;

//在特定位置显示文字模式
-(CTLineBreakMode)lineBreakModeAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange;

//在特定位置显示文字链接
-(NSURL*)linkAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange;

//计算高度
-(CGFloat)textHeightOfConstrainedWidth:(CGFloat )width;
@end


#pragma mark - 
//NSAttributedString扩展
@interface NSMutableAttributedString (OHCommodityStyleModifiers)
//设置字体
-(void)setFont:(UIFont*)font;
-(void)setFont:(UIFont*)font range:(NSRange)range;
-(void)setFontName:(NSString*)fontName size:(CGFloat)size;
-(void)setFontName:(NSString*)fontName size:(CGFloat)size range:(NSRange)range;
-(void)setFontFamily:(NSString*)fontFamily size:(CGFloat)size bold:(BOOL)isBold italic:(BOOL)isItalic range:(NSRange)range;

//设置颜色
-(void)setTextColor:(UIColor*)color;
-(void)setTextColor:(UIColor*)color range:(NSRange)range;

//设置下划线
-(void)setTextIsUnderlined:(BOOL)underlined;
-(void)setTextIsUnderlined:(BOOL)underlined range:(NSRange)range;
-(void)setTextUnderlineStyle:(int32_t)style range:(NSRange)range;

//设置粗体
-(void)setTextBold:(BOOL)isBold range:(NSRange)range;

//设置对齐方式 和换行方式
-(void)setTextAlignment:(CTTextAlignment)alignment lineBreakMode:(CTLineBreakMode)lineBreakMode;
//设置对齐方式 和换行方式 以及段间距
-(void)setTextAlignment:(CTTextAlignment)alignment lineBreakMode:(CTLineBreakMode)lineBreakMode range:(NSRange)range ;

//设置字间距
-(void)setTextSpacing:(CGFloat )number;


//设置行间距 和段间距
-(void)setLineSpacing:(CGFloat)lineSpace  paragraphSpacing:(CGFloat)paraSpace;


//设置链接
-(void)setLink:(NSURL*)link range:(NSRange)range;

//设置表情
-(void)setEmoit:(NSString *)link range:(NSRange)range;


@end


