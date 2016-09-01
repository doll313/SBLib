/*
 #####################################################################
 # File    : LoadingView.h
 # Project :
 # Created : 2013-04-01
 # DevTeam : thomas
 # Author  : thomas
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

#import "SBLoadingTips.h"
#import "SBDataTableCell.h"

@implementation SBLoadingTips
@synthesize activityView = _activityView;
@synthesize loadingLabel = _loadingLabel;
@synthesize text = _text;
@synthesize textColor = _textColor;

#define ACTIVITYVIEW_HEIGHT   20.0f
#define ACTIVITYVIEW_WIDTH    20.0f
#define ACTIVITYVIEW_PADDING  3.0f

#pragma mark -
#pragma mark 生命周期
- (id)initWithFrame:(CGRect)rect {
    if ((self = [super initWithFrame:rect])) {
		_loadingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_loadingLabel.backgroundColor = [UIColor clearColor];
		_loadingLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _loadingLabel.font = [UIFont systemFontOfSize:__SB_FONT_TABLE_DEFAULT_TIPS];
		_loadingLabel.numberOfLines = 0;
        _loadingLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:_loadingLabel];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.backgroundColor = [UIColor clearColor];
        [_activityView startAnimating];
		[self addSubview:_activityView];

		self.backgroundColor = [UIColor clearColor];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self resetSubViewsFrame];
}

- (void)resetSubViewsFrame {
    [_loadingLabel sizeToFit];
    [_loadingLabel sb_setHeight:CGRectGetHeight(self.bounds)];
    [_loadingLabel sb_centerOfView:self];
    
    _activityView.frame = CGRectMake(0, 0, ACTIVITYVIEW_WIDTH, ACTIVITYVIEW_HEIGHT);
    [_activityView sb_leftOfView:_loadingLabel withMargin:APPCONFIG_UI_WIDGET_PADDING sameVertical:YES];
}

- (void)showLoadingView {
    [self resetSubViewsFrame];
}

- (void)setText:(NSString *)newText {
	if (nil == newText) {
		newText = @"";
	}
    
	if ([newText isEqualToString:_text]) {
		_text = newText;
        
		_loadingLabel.text = _text;
		self.hidden = NO;
	}
}

- (NSString *)getText {
	return _loadingLabel.text;
}

- (void)setTextColor:(UIColor *)newTextColor {
	if (nil == newTextColor) {
		newTextColor = [UIColor blackColor];
	}
    
	if(newTextColor != _textColor){
		_textColor = newTextColor;
        
		_loadingLabel.textColor = _textColor;
	}
}

- (UIColor *)getTextColor {
	return _loadingLabel.textColor;
}


@end
