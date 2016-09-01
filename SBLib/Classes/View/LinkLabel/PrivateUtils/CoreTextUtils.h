/*
 #####################################################################
 # File    : CoreTextUtils.h
 # Project :
 # Created : 2013-06-19
 # DevTeam : 
 # Author  : thomas
 # Notes   : 图文混排 对应 uilable之间的属性转换
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
#import <CoreText/CoreText.h>

/////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Text Alignment Convertion
/////////////////////////////////////////////////////////////////////////////////////

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
CTTextAlignment CTTextAlignmentFromUITextAlignment(UITextAlignment alignment);
CTLineBreakMode CTLineBreakModeFromUILineBreakMode(UILineBreakMode lineBreakMode);
#else
CTTextAlignment CTTextAlignmentFromUITextAlignment(NSTextAlignment alignment);
CTLineBreakMode CTLineBreakModeFromUILineBreakMode(NSLineBreakMode lineBreakMode);
#endif


/////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Flipping Coordinates
/////////////////////////////////////////////////////////////////////////////////////

CGPoint CGPointFlipped(CGPoint point, CGRect bounds);
CGRect CGRectFlipped(CGRect rect, CGRect bounds);

/////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSRange / CFRange
/////////////////////////////////////////////////////////////////////////////////////

NSRange NSRangeFromCFRange(CFRange range);

/////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CoreText CTLine/CTRun utils
/////////////////////////////////////////////////////////////////////////////////////

CGRect CTLineGetTypographicBoundsAsRect(CTLineRef line, CGPoint lineOrigin);
CGRect CTRunGetTypographicBoundsAsRect(CTRunRef run, CTLineRef line, CGPoint lineOrigin);
BOOL CTLineContainsCharactersFromStringRange(CTLineRef line, NSRange range);
BOOL CTRunContainsCharactersFromStringRange(CTRunRef run, NSRange range);
