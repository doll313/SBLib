/*
 #####################################################################
 # File    : CoreTextUtils.m
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

#import "CoreTextUtils.h"

/////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Text Alignment Convertion
/////////////////////////////////////////////////////////////////////////////////////


#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
CTTextAlignment CTTextAlignmentFromUITextAlignment(UITextAlignment alignment) {
    if (alignment == (UITextAlignment)kCTJustifiedTextAlignment)
    {
        /** special OOB value, so test it outside of the switch to avoid warning */
        return kCTJustifiedTextAlignment;
    }
	switch (alignment)
    {
		case UITextAlignmentLeft: return kCTLeftTextAlignment;
		case UITextAlignmentCenter: return kCTCenterTextAlignment;
		case UITextAlignmentRight: return kCTRightTextAlignment;
		default: return kCTNaturalTextAlignment;
    }
}


CTLineBreakMode CTLineBreakModeFromUILineBreakMode(UILineBreakMode lineBreakMode)
{
	switch (lineBreakMode)
    {
		case UILineBreakModeWordWrap: return kCTLineBreakByWordWrapping;
		case UILineBreakModeCharacterWrap: return kCTLineBreakByCharWrapping;
		case UILineBreakModeClip: return kCTLineBreakByClipping;
		case UILineBreakModeHeadTruncation: return kCTLineBreakByTruncatingHead;
		case UILineBreakModeTailTruncation: return kCTLineBreakByTruncatingTail;
		case UILineBreakModeMiddleTruncation: return kCTLineBreakByTruncatingMiddle;
		default: return 0;
	}
}
#else
CTTextAlignment CTTextAlignmentFromUITextAlignment(NSTextAlignment alignment) {
    if (alignment == (NSTextAlignment)kCTJustifiedTextAlignment)
    {
        /** special OOB value, so test it outside of the switch to avoid warning */
        return kCTJustifiedTextAlignment;
    }
    switch (alignment)
    {
		case NSTextAlignmentLeft: return kCTLeftTextAlignment;
		case NSTextAlignmentCenter: return kCTCenterTextAlignment;
		case NSTextAlignmentRight: return kCTRightTextAlignment;
		default: return kCTNaturalTextAlignment;
    }
}

CTLineBreakMode CTLineBreakModeFromUILineBreakMode(NSLineBreakMode lineBreakMode)
{
	switch (lineBreakMode)
    {
		case NSLineBreakByWordWrapping: return kCTLineBreakByWordWrapping;
		case NSLineBreakByCharWrapping: return kCTLineBreakByCharWrapping;
		case NSLineBreakByClipping: return kCTLineBreakByClipping;
		case NSLineBreakByTruncatingHead: return kCTLineBreakByTruncatingHead;
		case NSLineBreakByTruncatingTail: return kCTLineBreakByTruncatingTail;
		case NSLineBreakByTruncatingMiddle: return kCTLineBreakByTruncatingMiddle;
		default: return 0;
	}
}
#endif

/////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Flipping Coordinates
/////////////////////////////////////////////////////////////////////////////////////

// Don't use this method for origins. Origins always depend on the height of the rect.
CGPoint CGPointFlipped(CGPoint point, CGRect bounds)
{
	return CGPointMake(point.x, CGRectGetMaxY(bounds)-point.y);
}

CGRect CGRectFlipped(CGRect rect, CGRect bounds)
{
	return CGRectMake(CGRectGetMinX(rect),
					  CGRectGetMaxY(bounds)-CGRectGetMaxY(rect),
					  CGRectGetWidth(rect),
					  CGRectGetHeight(rect));
}

/////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSRange / CFRange
/////////////////////////////////////////////////////////////////////////////////////

NSRange NSRangeFromCFRange(CFRange range)
{
	return NSMakeRange(range.location, range.length);
}

/////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CoreText CTLine/CTRun utils
/////////////////////////////////////////////////////////////////////////////////////

// Font Metrics: http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/FontHandling/Tasks/GettingFontMetrics.html
CGRect CTLineGetTypographicBoundsAsRect(CTLineRef line, CGPoint lineOrigin)
{
	CGFloat ascent = 0;
	CGFloat descent = 0;
	CGFloat leading = 0;
	CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
	CGFloat height = ascent + descent;
	
	return CGRectMake(lineOrigin.x,
					  lineOrigin.y - descent,
					  width,
					  height);
}

CGRect CTRunGetTypographicBoundsAsRect(CTRunRef run, CTLineRef line, CGPoint lineOrigin)
{
	CGFloat ascent = 0;
	CGFloat descent = 0;
	CGFloat leading = 0;
	CGFloat width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, &leading);
	CGFloat height = ascent + descent;
	
	CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
	
	return CGRectMake(lineOrigin.x + xOffset,
					  lineOrigin.y - descent,
					  width,
					  height);
}

BOOL CTLineContainsCharactersFromStringRange(CTLineRef line, NSRange range)
{
	NSRange lineRange = NSRangeFromCFRange(CTLineGetStringRange(line));
	NSRange intersectedRange = NSIntersectionRange(lineRange, range);
	return (intersectedRange.length > 0);
}

BOOL CTRunContainsCharactersFromStringRange(CTRunRef run, NSRange range)
{
	NSRange runRange = NSRangeFromCFRange(CTRunGetStringRange(run));
	NSRange intersectedRange = NSIntersectionRange(runRange, range);
	return (intersectedRange.length > 0);
}



