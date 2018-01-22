/*
 #####################################################################
 # File    : LinkLabel.m
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

#import "SBLinkLabel.h"
#import "CoreTextUtils.h"
#import "NSString+SBMODULE.h"
#import <SBLib/NSAttributedString+Attributes.h>

#pragma mark - 私有变量 私有方法
const int UITextAlignmentJustify = ((UITextAlignment)kCTJustifiedTextAlignment);

@interface SBLinkLabel() {
	NSAttributedString* _attributedText;                //原声图文字符串
    NSAttributedString* _attributedTextWithLinks;           //带链接的图文字符串
    BOOL _needsRecomputeLinksInText;                        //需要重新计算链接位置                
	CTFrameRef textFrame;                               //显示区域
	CGRect drawingRect;                                 //绘制区域
	CGPoint _touchStartPoint;                           //点击的位置
}

//可点击链接
@property(nonatomic, retain) NSTextCheckingResult* activeLink;

@end


@implementation SBLinkLabel
- (id) initWithFrame:(CGRect)aFrame
{
	self = [super initWithFrame:aFrame];
	if (self != nil) {
        _linkColor = MRC_RETAIN(RGB(0x35, 0x75, 0x99));
        _highlightedLinkColor = MRC_RETAIN([UIColor colorWithWhite:0.4 alpha:0.3]);
        
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeRedraw;
        self.backgroundColor = [UIColor clearColor];
        
        //重置属性
        [self resetAttributedText];
	}
	return self;
}

-(void)dealloc {
	[self resetTextFrame]; // CFRelease the text frame
#if ! __has_feature(objc_arc)
    [_images release];

    [_linkColor release]; _linkColor = nil;
	[_highlightedLinkColor release]; _highlightedLinkColor = nil;
	[_activeLink release]; _activeLink = nil;

	[_attributedText release]; _attributedText = nil;
    [_attributedTextWithLinks release]; _attributedTextWithLinks = nil;

	[super dealloc];
#endif
}


#pragma mark - 链接相关
//重置链接
-(void)setNeedsRecomputeLinksInText{
    _needsRecomputeLinksInText = YES;
    [self setNeedsDisplay];
}

//重置链接
-(void)recomputeLinksInTextIfNeeded {
    if (!_needsRecomputeLinksInText) {
        return;
    }
    
    _needsRecomputeLinksInText = NO;
    
    if (!_attributedText) {
        MRC_RELEASE(_attributedTextWithLinks);
        _attributedTextWithLinks = MRC_RETAIN(_attributedText);
        return;
	}
    
    @autoreleasepool
    {
        NSMutableAttributedString* mutAS = [_attributedText mutableCopy];
        
        void (^applyLinkStyle)(NSTextCheckingResult*) = ^(NSTextCheckingResult* result) {
            UIColor* thisLinkColor = self.linkColor;
            
            if (thisLinkColor) {
                [mutAS setTextColor:thisLinkColor range:[result range]];
            }
            
//            //网页加入下划线
//            if ([mutAS.string contains:@"http"]) {
//                [mutAS setTextUnderlineStyle:kCTUnderlineStyleSingle range:[result range]];
//            }
            
            //下划线或粗体，
//            int32_t uStyle = kCTUnderlineStyleSingle | kCTUnderlinePatternSolid;
//            if ((uStyle & 0xFFFF) != kCTUnderlineStyleNone) {
//                [mutAS setTextUnderlineStyle:uStyle range:[result range]];
//            }
//            
//            if (uStyle & kOHBoldStyleTraitMask) {
//                [mutAS setTextBold:((uStyle & kOHBoldStyleTraitSetBold) == kOHBoldStyleTraitSetBold) range:[result range]];
//            }
        };
        
        // 让链接位置变颜色
        [_attributedText enumerateAttribute:NSLinkAttributeName inRange:NSMakeRange(0, [_attributedText length])
                                    options:NSAttributedStringEnumerationReverse usingBlock:^(id value, NSRange range, BOOL *stop)
         {
             if (value)
             {
                 NSTextCheckingResult* result = [NSTextCheckingResult linkCheckingResultWithRange:range URL:(NSURL*)value];
                 applyLinkStyle(result);
             }
         }];
        
        MRC_RELEASE(_attributedTextWithLinks);
        _attributedTextWithLinks = [[NSAttributedString alloc] initWithAttributedString:mutAS];
        
        MRC_RELEASE(mutAS);
    } // @autoreleasepool
    
    [self setNeedsDisplay];
}

-(NSTextCheckingResult*)linkAtCharacterIndex:(CFIndex)idx
{
	__block NSTextCheckingResult* foundResult = nil;
	
    @autoreleasepool
    {
        // Links set by text attribute
        if (_attributedText) {
            [_attributedText enumerateAttribute:NSLinkAttributeName inRange:NSMakeRange(0, [_attributedText length])
                                        options:0 usingBlock:^(id value, NSRange range, BOOL *stop)  {
                 if (value && NSLocationInRange(idx, range)) {
                     NSTextCheckingResult* result = [NSTextCheckingResult linkCheckingResultWithRange:range URL:(NSURL*)value];
                     foundResult = MRC_RETAIN(result);
                     *stop = YES;
                 }
             }];
        }
    } // @autoreleasepool
    
	return MRC_AUTORELEASE(foundResult);
}

-(NSTextCheckingResult*)linkAtPoint:(CGPoint)point {
	static const CGFloat kVMargin = 5.f;
	if (!CGRectContainsPoint(CGRectInset(drawingRect, 0, -kVMargin), point)) {
        return nil;
    }
	
	CFArrayRef lines = CTFrameGetLines(textFrame);
	if (!lines) {
        return nil;
    }
	CFIndex nbLines = CFArrayGetCount(lines);
	NSTextCheckingResult* link = nil;
	
	CGPoint origins[nbLines];
	CTFrameGetLineOrigins(textFrame, CFRangeMake(0,0), origins);
	
	for (int lineIndex=0 ; lineIndex<nbLines ; ++lineIndex) {
		// this actually the origin of the line rect, so we need the whole rect to flip it
		CGPoint lineOriginFlipped = origins[lineIndex];
		
		CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
		CGRect lineRectFlipped = CTLineGetTypographicBoundsAsRect(line, lineOriginFlipped);
		CGRect lineRect = CGRectFlipped(lineRectFlipped, CGRectFlipped(drawingRect,self.bounds));
		
		lineRect = CGRectInset(lineRect, 0, -kVMargin);
		if (CGRectContainsPoint(lineRect, point))
        {
			CGPoint relativePoint = CGPointMake(point.x-CGRectGetMinX(lineRect),
												point.y-CGRectGetMinY(lineRect));
			CFIndex idx = CTLineGetStringIndexForPosition(line, relativePoint);
            if ((relativePoint.x < CTLineGetOffsetForStringIndex(line, idx, NULL)) && (idx>0))
            {
                // CTLineGetStringIndexForPosition compute the *carret* position, not the character under the CGPoint. So if the index
                // returned correspond to the character *after* the tapped point, because we tapped on the right half of the character,
                // then substract 1 to the index to get to the real tapped character index.
                --idx;
            }
            
			link = ([self linkAtCharacterIndex:idx]);
			if (link)
            {
                return link;
            }
		}
	}
	return nil;
}

//点击了view
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	// never return self. always return the result of [super hitTest..].
	// this takes userInteraction state, enabled, alpha values etc. into account
	UIView *hitResult = [super hitTest:point withEvent:event];
	
	// don't check for links if the event was handled by one of the subviews
	if (hitResult != self) {
		return hitResult;
	}
    
    BOOL didHitLink = ([self linkAtPoint:point] != nil);
    if (!didHitLink) {
        // not catch the touch if it didn't hit a link
        return nil;
    }
    
	return hitResult;
}

//点击开始
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch* touch = [touches anyObject];
	CGPoint pt = [touch locationInView:self];
	
	self.activeLink = [self linkAtPoint:pt];
	_touchStartPoint = pt;
	
	// 需要高亮
	[self setNeedsDisplay];
}

//点击结束
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch* touch = [touches anyObject];
	CGPoint pt = [touch locationInView:self];
	
	NSTextCheckingResult *linkAtTouchesEnded = [self linkAtPoint:pt];
	
	BOOL closeToStart = (fabs(_touchStartPoint.x - pt.x) < 10 && fabs(_touchStartPoint.y - pt.y) < 10);

    //解析链接
	if (_activeLink && (NSEqualRanges(_activeLink.range,linkAtTouchesEnded.range) || closeToStart)) {
        //回调处理
		if (self.delegate && [self.delegate respondsToSelector:@selector(clickedLinkStr:meaning:)]) {
            NSString *_linkStr = [self.attributedText.string substringWithRange:_activeLink.range];
            
            //链接数据
            NSTextCheckingResult* linkToOpen = _activeLink;
            (void)MRC_AUTORELEASE(MRC_RETAIN(linkToOpen));
            
            //网页或者其他
            if ([[UIApplication sharedApplication] canOpenURL:linkToOpen.URL]) {
                [self.delegate clickedLinkStr:_linkStr meaning:[linkToOpen.URL absoluteString]];
            } else {
                [self.delegate clickedLinkStr:_linkStr meaning:[[linkToOpen.URL absoluteString] emsb_base64DecodedString]];
                
            }
        
        }
	}
	
	self.activeLink = nil;
	[self setNeedsDisplay];
}

//点击取消
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	self.activeLink = nil;
	[self setNeedsDisplay];
}


#pragma mark - 绘制
-(void)resetTextFrame {
	if (textFrame) {
		CFRelease(textFrame);
		textFrame = NULL;
	}
}

//绘制文字
- (void)drawTextInRect:(CGRect)aRect {
	if (_attributedText) {
        @autoreleasepool
        {
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            CGContextSaveGState(ctx);
            
            //倒转画布
            CGContextConcatCTM(ctx, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f));
            
            //画阴影
            if (self.shadowColor) {
                CGContextSetShadowWithColor(ctx, self.shadowOffset, 0.0, self.shadowColor.CGColor);
            }
            
            //加载图片元素
            [self.images removeAllObjects];
            if ([self.images count]<=0) {
                //算出所有图片
                if (self.images==nil) {
                    self.images = [NSMutableArray array];
                }
                
                [_attributedText enumerateAttribute:kOHEmoitAttributeName inRange:NSMakeRange(0, [_attributedText length])
                                            options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
                     if (value)  {
                         
                         //add the image for drawing
                         NSArray *ary = [value componentsSeparatedByString:@"|"];
                         if ([ary count] == 3) {
                             for (int i = 0; i < range.length; i++) {
                                 [self.images addObject:
                                  [NSDictionary dictionaryWithObjectsAndKeys:
                                   ary[1], @"width",
                                   ary[2], @"height",
                                   ary[0], @"fileName",
                                   [NSNumber numberWithLong: range.location + i], @"location",
                                   nil]
                                  ];
                             }
                         }
                         
                     }
                 }];
//                self.images = [[self.images reverseObjectEnumerator] allObjects];
            }
                        
            [self recomputeLinksInTextIfNeeded];
            
            NSAttributedString* attributedStringToDisplay = _attributedTextWithLinks;
            
            if (self.highlighted && self.highlightedTextColor != nil) {
                NSMutableAttributedString* mutAS = [attributedStringToDisplay mutableCopy];
                [mutAS setTextColor:self.highlightedTextColor];
                attributedStringToDisplay = mutAS;
                (void)MRC_AUTORELEASE(mutAS);
            }
            
            if (textFrame == NULL) {
                CFAttributedStringRef cfAttrStrWithLinks = (BRIDGE_CAST CFAttributedStringRef)attributedStringToDisplay;
                CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(cfAttrStrWithLinks);
                drawingRect = self.bounds;
                
                CGMutablePathRef path = CGPathCreateMutable();
                CGPathAddRect(path, NULL, drawingRect);
                textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
                if ([self.images count]) {
                    [self attachImagesWithFrame:textFrame withImages:self.images withContext:ctx];
                }
                CGPathRelease(path);
                CFRelease(framesetter);
            }
            
            // 高亮显示
            if (_activeLink) {
                [self drawActiveLinkHighlightForRect:drawingRect];
            }
            
            CTFrameDraw(textFrame, ctx);
            
            CGContextRestoreGState(ctx);
        } // @autoreleasepool
	} else {
		[super drawTextInRect:aRect];
	}
}

//图片显示
-(void)attachImagesWithFrame:(CTFrameRef)f withImages:(NSMutableArray *)imags withContext:(CGContextRef) ctx {
    //drawing images
    NSArray *lines = (NSArray *)CTFrameGetLines(f); //1
    
    NSMutableArray *imgs = [NSMutableArray array];
    
    CGPoint origins[[lines count]];
    CTFrameGetLineOrigins(f, CFRangeMake(0, 0), origins); //2
    
    int imgIndex = 0; //3
    
    NSDictionary* nextImage = [imags objectAtIndex:imgIndex];
    int imgLocation = [[nextImage objectForKey:@"location"] intValue];
    
    //find images for the current column
    CFRange frameRange = CTFrameGetVisibleStringRange(f); //4
    while ( imgLocation < frameRange.location ) {
        imgIndex++;
        if (imgIndex>=[imags count]) {
            return; //quit if no images for this column
        }
        nextImage = [imags objectAtIndex:imgIndex];
        imgLocation = [[nextImage objectForKey:@"location"] intValue];
    }
    
    NSUInteger lineIndex = 0;
    for (id lineObj in lines) { //5
        CTLineRef line = (__bridge CTLineRef)lineObj;
        
        NSArray *glyphRuns = (NSArray *)CTLineGetGlyphRuns(line);
        for (id runObj in glyphRuns) { //6
            CTRunRef run = (__bridge CTRunRef)runObj;
            CFRange runRange = CTRunGetStringRange(run);
            
            if ( runRange.location <= imgLocation && runRange.location+runRange.length > imgLocation ) { //7
	            CGRect runBounds;
	            CGFloat ascent;//height above the baseline
	            CGFloat descent;//height below the baseline
	            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL); //8
	            runBounds.size.height = ascent + descent;
                
	            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL); //9
	            runBounds.origin.x = origins[lineIndex].x  + xOffset;
	            runBounds.origin.y = origins[lineIndex].y;
	            runBounds.origin.y -= descent;

                UIImage *img = [UIImage imageNamed: [nextImage objectForKey:@"fileName"] ];
                CGPathRef pathRef = CTFrameGetPath(f); //10
                CGRect colRect = CGPathGetBoundingBox(pathRef);
                CGRect imgBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
                [imgs addObject:  [NSArray arrayWithObjects:img, NSStringFromCGRect(imgBounds) , nil]  ];//11
                //load the next image //12
                imgIndex++;
                if (imgIndex < [self.images count]) {
                    nextImage = [self.images objectAtIndex: imgIndex];
                    imgLocation = [[nextImage objectForKey: @"location"] intValue];
                }
                
            }
        }
        lineIndex++;
    }
    
    for (NSArray* imageData in imgs) {
        if (imageData.count > 0) {
            UIImage* img = [imageData objectAtIndex:0];
            CGRect imgBounds = CGRectFromString([imageData objectAtIndex:1]);
            CGContextDrawImage(ctx, CGRectMake(imgBounds.origin.x, imgBounds.origin.y, 15.0f, 15.0f), img.CGImage);
        }
    }
    
}

//画高亮时的显示
-(void)drawActiveLinkHighlightForRect:(CGRect)rect {
    if (!self.highlightedLinkColor) {
        return;
    }
    
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSaveGState(ctx);
	CGContextConcatCTM(ctx, CGAffineTransformMakeTranslation(rect.origin.x, rect.origin.y));
	[self.highlightedLinkColor setFill];
	
	NSRange activeLinkRange = _activeLink.range;
	
	CFArrayRef lines = CTFrameGetLines(textFrame);
	CFIndex lineCount = CFArrayGetCount(lines);
	CGPoint lineOrigins[lineCount];
	CTFrameGetLineOrigins(textFrame, CFRangeMake(0,0), lineOrigins);
	for (CFIndex lineIndex = 0; lineIndex < lineCount; lineIndex++) {
		CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
		
		if (!CTLineContainsCharactersFromStringRange(line, activeLinkRange)) {
			continue; // with next line
		}
		
		// we use this rect to union the bounds of successive runs that belong to the same active link
		CGRect unionRect = CGRectZero;
		
		CFArrayRef runs = CTLineGetGlyphRuns(line);
		CFIndex runCount = CFArrayGetCount(runs);
		for (CFIndex runIndex = 0; runIndex < runCount; runIndex++)
        {
			CTRunRef run = CFArrayGetValueAtIndex(runs, runIndex);
			
			if (!CTRunContainsCharactersFromStringRange(run, activeLinkRange))
            {
				if (!CGRectIsEmpty(unionRect))
                {
					CGContextFillRect(ctx, unionRect);
					unionRect = CGRectZero;
				}
				continue; // with next run
			}
			
			CGRect linkRunRect = CTRunGetTypographicBoundsAsRect(run, line, lineOrigins[lineIndex]);
			linkRunRect = CGRectIntegral(linkRunRect);		// putting the rect on pixel edges
			linkRunRect = CGRectInset(linkRunRect, -1, -1);	// increase the rect a little
			if (CGRectIsEmpty(unionRect))
            {
				unionRect = linkRunRect;
			} else {
				unionRect = CGRectUnion(unionRect, linkRunRect);
			}
		}
		if (!CGRectIsEmpty(unionRect))
        {
			CGContextFillRect(ctx, unionRect);
			//unionRect = CGRectZero;
		}
	}
	CGContextRestoreGState(ctx);
}

//自适应
- (CGSize)sizeThatFits:(CGSize)size {
    [self recomputeLinksInTextIfNeeded];
    return _attributedTextWithLinks ? [_attributedTextWithLinks sizeConstrainedToSize:size] : CGSizeZero;
}

#pragma mark - Setters/Getters
@synthesize activeLink = _activeLink;
@synthesize linkColor = _linkColor;
@synthesize highlightedLinkColor = _highlightedLinkColor;
@synthesize delegate = _delegate;
@synthesize images = _images;

//重新设置属性
-(void)resetAttributedText {
	NSMutableAttributedString* mutAttrStr = [NSMutableAttributedString attributedStringWithString:self.text];
    
	if (self.font) {
        [mutAttrStr setFont:self.font];
    }
    
	if (self.textColor) {
        [mutAttrStr setTextColor:self.textColor];
    }
	CTTextAlignment coreTextAlign = CTTextAlignmentFromUITextAlignment(self.textAlignment);
	CTLineBreakMode coreTextLBMode = CTLineBreakModeFromUILineBreakMode(self.lineBreakMode);
	[mutAttrStr setTextAlignment:coreTextAlign lineBreakMode:coreTextLBMode];
    
	self.attributedText = [NSAttributedString attributedStringWithAttributedString:mutAttrStr];
}

-(NSAttributedString*)attributedText {
	if (!_attributedText) {
		[self resetAttributedText];
	}
    return _attributedText;
}

-(void)setAttributedText:(NSAttributedString*)newText {
	MRC_RELEASE(_attributedText);
	_attributedText = MRC_RETAIN(newText);
	[self setAccessibilityLabel:_attributedText.string];
    [self setNeedsRecomputeLinksInText];
}

-(void)setText:(NSString *)text {
	NSString* cleanedText = [[text stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"]
							 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	[super setText:cleanedText]; // will call setNeedsDisplay too
	[self resetAttributedText];
}

-(void)setFont:(UIFont *)font {
    if (_attributedText) {
        NSMutableAttributedString* mutAS = [NSMutableAttributedString attributedStringWithAttributedString:_attributedText];
        [mutAS setFont:font];
        MRC_RELEASE(_attributedText);
        _attributedText = [[NSAttributedString alloc] initWithAttributedString:mutAS];
    }
	[super setFont:font]; // will call setNeedsDisplay too
}

-(void)setTextColor:(UIColor *)color {
    if (_attributedText) {
        NSMutableAttributedString* mutAS = [NSMutableAttributedString attributedStringWithAttributedString:_attributedText];
        [mutAS setTextColor:color];
        MRC_RELEASE(_attributedText);
        _attributedText = [[NSAttributedString alloc] initWithAttributedString:mutAS];
    }
	[super setTextColor:color]; // will call setNeedsDisplay too
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
-(void)setTextAlignment:(UITextAlignment)alignment
#else
-(void)setTextAlignment:(NSTextAlignment)alignment
#endif
{
    if (_attributedText) {
        CTTextAlignment coreTextAlign = CTTextAlignmentFromUITextAlignment(alignment);
        CTLineBreakMode coreTextLBMode = CTLineBreakModeFromUILineBreakMode(self.lineBreakMode);
        NSMutableAttributedString* mutAS = [NSMutableAttributedString attributedStringWithAttributedString:_attributedText];
        [mutAS setTextAlignment:coreTextAlign lineBreakMode:coreTextLBMode];
        MRC_RELEASE(_attributedText);
        _attributedText = [[NSAttributedString alloc] initWithAttributedString:mutAS];
    }
	[super setTextAlignment:alignment]; // will call setNeedsDisplay too
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
-(void)setLineBreakMode:(UILineBreakMode)lineBreakMode
#else
-(void)setLineBreakMode:(NSLineBreakMode)lineBreakMode
#endif
{
    if (_attributedText) {
        CTTextAlignment coreTextAlign = CTTextAlignmentFromUITextAlignment(self.textAlignment);
        CTLineBreakMode coreTextLBMode = CTLineBreakModeFromUILineBreakMode(lineBreakMode);
        NSMutableAttributedString* mutAS = [NSMutableAttributedString attributedStringWithAttributedString:_attributedText];
        [mutAS setTextAlignment:coreTextAlign lineBreakMode:coreTextLBMode];
        MRC_RELEASE(_attributedText);
        _attributedText = [[NSAttributedString alloc] initWithAttributedString:mutAS];
    }
	[super setLineBreakMode:lineBreakMode]; // will call setNeedsDisplay too
}

-(void)setLinkColor:(UIColor *)newLinkColor {
    MRC_RELEASE(_linkColor);
    _linkColor = MRC_RETAIN(newLinkColor);
    
    [self setNeedsRecomputeLinksInText];
}

-(void)setNeedsDisplay
{
	[self resetTextFrame];
	[super setNeedsDisplay];
}


@end
