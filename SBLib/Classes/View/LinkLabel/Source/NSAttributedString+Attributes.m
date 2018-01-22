/*
 #####################################################################
 # File    : NSAttributedString+Attributes.m
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


#import "NSAttributedString+Attributes.h"

//NSString* kOHLinkAttributeName = @"NSLinkAttributeName"; // Use the same value as OSX, to be compatible in case Apple port this to iOS one day too

/////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSAttributedString Additions

@implementation NSAttributedString (OHCommodityConstructors)
+(NSAttributedString*)attributedStringWithString:(NSString*)string {
    if (string) {
        return MRC_AUTORELEASE([[self alloc] initWithString:string]);
    } else {
        return nil;
    }
}

+(NSAttributedString*)attributedStringWithAttributedString:(NSAttributedString*)attrStr {
    if (attrStr) {
        return MRC_AUTORELEASE([[self alloc] initWithAttributedString:attrStr]);
    } else {
        return nil;
    }
}
static inline CGSize ajustedSize(CGSize originalSize) {
    CGSize ajustedSize = originalSize;
    ajustedSize.width = ceilf(originalSize.width);
    ajustedSize.height = ceilf(originalSize.height);
    return ajustedSize;
}

-(CGSize)sizeConstrainedToSize:(CGSize)maxSize {
    return ajustedSize([self sizeConstrainedToSize:maxSize fitRange:NULL]);
}

-(CGSize)sizeConstrainedToSize:(CGSize)maxSize fitRange:(NSRange*)fitRange
{
    CGSize size = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading context:nil].size;
    return ajustedSize(size);
}

-(CTFontRef)fontAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange {
    id attr = [self attribute:(BRIDGE_CAST NSString*)kCTFontAttributeName atIndex:index effectiveRange:aRange];
    return (BRIDGE_CAST CTFontRef)attr;
}

-(UIColor*)textColorAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange{
    id attr = [self attribute:(BRIDGE_CAST NSString*)kCTForegroundColorAttributeName atIndex:index effectiveRange:aRange];
    return [UIColor colorWithCGColor:(BRIDGE_CAST CGColorRef)attr];
}

-(BOOL)textIsUnderlinedAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange {
    int32_t underlineStyle = [self textUnderlineStyleAtIndex:index effectiveRange:aRange];
    return (underlineStyle & 0xFF) != kCTUnderlineStyleNone;
}

-(int32_t)textUnderlineStyleAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange {
    id attr = [self attribute:(BRIDGE_CAST NSString*)kCTUnderlineStyleAttributeName atIndex:index effectiveRange:aRange];
    return [(NSNumber*)attr intValue];
}

-(BOOL)textIsBoldAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange {
    CTFontRef font = [self fontAtIndex:index effectiveRange:aRange];
    CTFontSymbolicTraits traits = CTFontGetSymbolicTraits(font);
    return (traits & kCTFontBoldTrait) != 0;
}

-(CTTextAlignment)textAlignmentAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange {
    id attr = [self attribute:(BRIDGE_CAST NSString*)kCTParagraphStyleAttributeName atIndex:index effectiveRange:aRange];
    CTParagraphStyleRef style = (BRIDGE_CAST CTParagraphStyleRef)attr;
    CTTextAlignment textAlign = kCTTextAlignmentJustified;
    CTParagraphStyleGetValueForSpecifier(style, kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &textAlign);
    return textAlign;
}

-(CTLineBreakMode)lineBreakModeAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange {
    id attr = [self attribute:(BRIDGE_CAST NSString*)kCTParagraphStyleAttributeName atIndex:index effectiveRange:aRange];
    CTParagraphStyleRef style = (BRIDGE_CAST CTParagraphStyleRef)attr;
    CTLineBreakMode lineBreakMode = kCTLineBreakByWordWrapping;
    CTParagraphStyleGetValueForSpecifier(style, kCTParagraphStyleSpecifierLineBreakMode, sizeof(CTLineBreakMode), &lineBreakMode);
    return lineBreakMode;
}

-(NSURL*)linkAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange {
    return [self attribute:kOHLinkAttributeName atIndex:index effectiveRange:aRange];
}


//根据显示的宽度计算文字所占的高度
-(CGFloat)textHeightOfConstrainedWidth:(CGFloat)width {
    CGFloat height = [self sizeConstrainedToSize:CGSizeMake(width, INT32_MAX)].height;
    return [self adjustHeight:height attributeString:self];
}

//区分行数，一行高度不加行间距
-(CGFloat)adjustHeight:(CGFloat)height attributeString:(NSAttributedString * )string{
    __block CGFloat fontHeight;
    __block CGFloat lineSpace;
    [string enumerateAttributesInRange:NSMakeRange(0, string.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        fontHeight = [(UIFont *)attrs[NSFontAttributeName] lineHeight];
        lineSpace = [(NSParagraphStyle *)attrs[NSParagraphStyleAttributeName] lineSpacing];
        fontHeight = ceilf(fontHeight);
    }];
    
    if ((height - fontHeight) <= lineSpace) {
        height = fontHeight;
    }
    return height;
}

- (BOOL)containChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}

@end



/////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSMutableAttributedString Additions

@implementation NSMutableAttributedString (OHCommodityStyleModifiers)

-(void)setFont:(UIFont*)font
{
    if (self.length > 0) {
        [self addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,self.length)];
    }
}
-(void)setFont:(UIFont*)font range:(NSRange)range
{
    if (self.length > 0) {
        [self addAttribute:NSFontAttributeName value:font range:range];
    }
}
-(void)setFontName:(NSString*)fontName size:(CGFloat)size
{
	[self setFontName:fontName size:size range:NSMakeRange(0,[self length])];
}
-(void)setFontName:(NSString*)fontName size:(CGFloat)size range:(NSRange)range
{
	// kCTFontAttributeName
	CTFontRef aFont = CTFontCreateWithName((BRIDGE_CAST CFStringRef)fontName, size, NULL);
	if (aFont)
    {
//        [self removeAttribute:(BRIDGE_CAST NSString*)kCTFontAttributeName range:range]; // Work around for Apple leak
        [self addAttribute:(BRIDGE_CAST NSString*)kCTFontAttributeName value:(BRIDGE_CAST id)aFont range:range];
        CFRelease(aFont);
    }
}
-(void)setFontFamily:(NSString*)fontFamily size:(CGFloat)size bold:(BOOL)isBold italic:(BOOL)isItalic range:(NSRange)range
{
	// kCTFontFamilyNameAttribute + kCTFontTraitsAttribute
	CTFontSymbolicTraits symTrait = (isBold?kCTFontBoldTrait:0) | (isItalic?kCTFontItalicTrait:0);
	NSDictionary* trait = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:symTrait]
                                                      forKey:(BRIDGE_CAST NSString*)kCTFontSymbolicTrait];
	NSDictionary* attr = [NSDictionary dictionaryWithObjectsAndKeys:
						  fontFamily,kCTFontFamilyNameAttribute,
						  trait,kCTFontTraitsAttribute,nil];
	
	CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((BRIDGE_CAST CFDictionaryRef)attr);
	if (!desc) return;
	CTFontRef aFont = CTFontCreateWithFontDescriptor(desc, size, NULL);
	CFRelease(desc);
	if (!aFont) return;

//	[self removeAttribute:(BRIDGE_CAST NSString*)kCTFontAttributeName range:range]; // Work around for Apple leak
	[self addAttribute:(BRIDGE_CAST NSString*)kCTFontAttributeName value:(BRIDGE_CAST id)aFont range:range];
	CFRelease(aFont);
}

-(void)setTextColor:(UIColor*)color
{
	[self setTextColor:color range:NSMakeRange(0,[self length])];
}
-(void)setTextColor:(UIColor*)color range:(NSRange)range
{
	// kCTForegroundColorAttributeName
//	[self removeAttribute:(BRIDGE_CAST NSString*)kCTForegroundColorAttributeName range:range]; // Work around for Apple leak
	[self addAttribute:(BRIDGE_CAST NSString*)kCTForegroundColorAttributeName value:(BRIDGE_CAST id)color.CGColor range:range];
}

-(void)setTextIsUnderlined:(BOOL)underlined
{
	[self setTextIsUnderlined:underlined range:NSMakeRange(0,[self length])];
}
-(void)setTextIsUnderlined:(BOOL)underlined range:(NSRange)range
{
	int32_t style = underlined ? (kCTUnderlineStyleSingle|kCTUnderlinePatternSolid) : kCTUnderlineStyleNone;
	[self setTextUnderlineStyle:style range:range];
}
-(void)setTextUnderlineStyle:(int32_t)style range:(NSRange)range
{
//	[self removeAttribute:(BRIDGE_CAST NSString*)kCTUnderlineStyleAttributeName range:range]; // Work around for Apple leak
	[self addAttribute:(BRIDGE_CAST NSString*)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:style] range:range];
}

-(void)setTextBold:(BOOL)isBold range:(NSRange)range
{
	NSUInteger startPoint = range.location;
	NSRange effectiveRange;
	do {
		// Get font at startPoint
		CTFontRef currentFont = (BRIDGE_CAST CTFontRef)[self attribute:(BRIDGE_CAST NSString*)kCTFontAttributeName atIndex:startPoint effectiveRange:&effectiveRange];
        if (!currentFont)
        {
            currentFont = CTFontCreateUIFontForLanguage(kCTFontLabelFontType, 0.0, NULL);
            (void)MRC_AUTORELEASE((BRIDGE_TRANSFER_CAST id)currentFont);
        }
		// The range for which this font is effective
		NSRange fontRange = NSIntersectionRange(range, effectiveRange);
		// Create bold/unbold font variant for this font and apply
		CTFontRef newFont = CTFontCreateCopyWithSymbolicTraits(currentFont, 0.0, NULL, (isBold?kCTFontBoldTrait:0), kCTFontBoldTrait);
		if (newFont)
        {
//			[self removeAttribute:(BRIDGE_CAST NSString*)kCTFontAttributeName range:fontRange]; // Work around for Apple leak
			[self addAttribute:(BRIDGE_CAST NSString*)kCTFontAttributeName value:(BRIDGE_CAST id)newFont range:fontRange];
			CFRelease(newFont);
		} else {
			CFStringRef fontName = CTFontCopyFullName(currentFont);
			NSLog(@"[OHAttributedLabel] Warning: can't find a bold font variant for font %@. Try another font family (like Helvetica) instead.",
                  (BRIDGE_CAST NSString*)fontName);
            if (fontName) CFRelease(fontName);
		}
		////[self removeAttribute:(NSString*)kCTFontWeightTrait range:fontRange]; // Work around for Apple leak
		////[self addAttribute:(NSString*)kCTFontWeightTrait value:(id)[NSNumber numberWithInt:1.0f] range:fontRange];
		
		// If the fontRange was not covering the whole range, continue with next run
		startPoint = NSMaxRange(effectiveRange);
	} while(startPoint<NSMaxRange(range));
}
-(void)setTextAlignment:(CTTextAlignment)alignment lineBreakMode:(CTLineBreakMode)lineBreakMode {


	[self setTextAlignment:alignment lineBreakMode:lineBreakMode range:NSMakeRange(0,[self length])];
}


//设置对齐方式 和换行方式
-(void)setTextAlignment:(CTTextAlignment)alignment lineBreakMode:(CTLineBreakMode)lineBreakMode range:(NSRange)range {
//    CGFloat spacing = 0.0;  //间距

	CTParagraphStyleSetting paraStyles[2] = {
		{.spec = kCTParagraphStyleSpecifierAlignment, .valueSize = sizeof(CTTextAlignment), .value = (const void*)&alignment},
		{.spec = kCTParagraphStyleSpecifierLineBreakMode, .valueSize = sizeof(CTLineBreakMode), .value = (const void*)&lineBreakMode},
	};
	CTParagraphStyleRef aStyle = CTParagraphStyleCreate(paraStyles, 2);
//	[self removeAttribute:(BRIDGE_CAST NSString*)kCTParagraphStyleAttributeName range:range]; // Work around for Apple leak
	[self addAttribute:(BRIDGE_CAST NSString*)kCTParagraphStyleAttributeName value:(BRIDGE_CAST id)aStyle range:range];
	CFRelease(aStyle);
}

//设置文字间距
-(void)setTextSpacing:(CGFloat )number
{
    [self addAttribute:NSKernAttributeName value:@(number) range:NSMakeRange(0, self.length)];
}
//设置行间距 和段间距
-(NSMutableAttributedString *)setLineSpacing:(CGFloat)lineSpacing  paragraphSpacing:(CGFloat)paragraphSpacing{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;// 字体的行间距
    paragraphStyle.paragraphSpacing = paragraphSpacing;
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    return self;
}


-(void)setLink:(NSURL*)link range:(NSRange)range
{
    [self removeAttribute:NSLinkAttributeName range:range]; // Work around for Apple leak
    if (link) {
        [self addAttribute:NSLinkAttributeName value:link range:range];
    }
}

-(void)setEmoit:(NSString *)link range:(NSRange)range
{
    [self removeAttribute:NSLinkAttributeName range:range]; // Work around for Apple leak
    if (link) {
        [self addAttribute:NSLinkAttributeName value:link range:range];
    }
}

@end



