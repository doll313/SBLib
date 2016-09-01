/*
#####################################################################
# File    : UILabelCagegory.m
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

#import "Component+SBMODULE.h"

@implementation UITextField (sbmodule)
//一种hack方式，为textfield设置padding
- (void)sb_addFieldPadding:(CGFloat)padding {
    //一种hack方式，为textfield设置padding
    UIView *_paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, padding, 0)];
    self.leftView = _paddingView;
    self.rightView = _paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.rightViewMode = UITextFieldViewModeAlways;
}

@end


@implementation UITextView (sbmodule)

- (void)sb_insertTextAtCursor:(NSString *)text {
    NSUInteger location = self.selectedRange.location;
    NSMutableString *inputStr = [[NSMutableString alloc] initWithString:self.text];
    [inputStr insertString:text atIndex:location];
    self.text = inputStr;
    self.selectedRange = NSMakeRange(location + text.length, 0);
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
}

- (CGFloat)sb_textHeight {
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        // This is the code for iOS 7. contentSize no longer returns the correct value, so
        // we have to calculate it.
        //
        // This is partly borrowed from HPGrowingTextView, but I've replaced the
        // magic fudge factors with the calculated values (having worked out where
        // they came from)
        
        CGRect frame = self.bounds;
        
        // Take account of the padding added around the text.
        
        UIEdgeInsets textContainerInsets = self.textContainerInset;
        UIEdgeInsets contentInsets = self.contentInset;
        
        CGFloat leftRightContainerPadding = textContainerInsets.left + textContainerInsets.right + self.textContainer.lineFragmentPadding * 2;
        CGFloat topPadding = textContainerInsets.top + contentInsets.top;
        CGFloat topBottomPadding = topPadding + textContainerInsets.bottom + contentInsets.bottom;
        
        frame.size.width -= leftRightContainerPadding;
        frame.size.height -= topBottomPadding;
        
        NSString *textToMeasure = self.text;
        if ([textToMeasure hasSuffix:@"\n"])
        {
            textToMeasure = [NSString stringWithFormat:@"%@-", self.text];
        }
        
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSDictionary *attributes = @{ NSFontAttributeName: self.font, NSParagraphStyleAttributeName : paragraphStyle };
        
        CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
        
        CGFloat measuredHeight = ceilf(CGRectGetHeight(size) + textContainerInsets.top + textContainerInsets.bottom);
        return measuredHeight;
    }
    else
    {
        return self.contentSize.height;
    }
}

@end

@implementation UITableViewCell (sbmodule)

/**  添加点击背景颜色 */
- (void)sb_selectedColor:(UIColor *)color{
    self.selectedBackgroundView =[[UIView alloc] initWithFrame:self.bounds];
    self.selectedBackgroundView.backgroundColor = color;
}

@end


@implementation UIWindow (sbmodule)

- (UIViewController *)sb_topMostViewController {
    return [self topViewControllerWithRootViewController:self.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

@end
