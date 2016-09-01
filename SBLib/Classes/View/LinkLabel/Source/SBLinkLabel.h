/*
 #####################################################################
 # File    : LinkLabel.h
 # Project :
 # Created : 2013-06-19
 # DevTeam : 
 # Author  : thomas
 # Notes   : 带点击的label
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

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "NSAttributedString+Attributes.h"

//回调
@class SBLinkLabel;
@protocol SBLinkLabelDelegate <NSObject>
@optional
-(void)clickedLinkStr:(NSString *)linkStr meaning:(NSString *)meaning;
@end


/////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Constants
/////////////////////////////////////////////////////////////////////////////////////

extern const int UITextAlignmentJustify
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
__attribute__((deprecated("You should use 'setTextAlignment:lineBreakMode:' on your NSAttributedString instead.")));
#else
__attribute__((unavailable("Since iOS6 SDK, you have to use 'setTextAlignment:lineBreakMode:' on your NSAttributedString instead.")));
#endif

#ifndef NS_OPTIONS
// For older compilers compatibility. But you should really update your Xcode and LLVM.
#define NS_OPTIONS(_type, _name) _type _name; enum _name
#endif
//粗体转换
typedef NS_OPTIONS(int32_t, OHBoldStyleTrait) {
    kOHBoldStyleTraitMask       = 0x030000,
    kOHBoldStyleTraitSetBold    = 0x030000,
    kOHBoldStyleTraitUnSetBold  = 0x020000,
};

@interface SBLinkLabel : UILabel <UIAppearance>

//图文混排中的图片
@property (retain, nonatomic) NSMutableArray* images;

//图文混排中的文字
@property(nonatomic, copy) NSAttributedString* attributedText;

//重置文字
-(void)resetAttributedText;

//重置链接信息等
-(void)setNeedsRecomputeLinksInText;

//链接文字的颜色
@property(nonatomic, strong) UIColor* linkColor UI_APPEARANCE_SELECTOR;

//链接文字的高亮点击色
@property(nonatomic, strong) UIColor* highlightedLinkColor UI_APPEARANCE_SELECTOR;

//回调
@property(nonatomic, assign) id<SBLinkLabelDelegate> delegate;
@end
