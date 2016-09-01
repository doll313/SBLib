/*
#####################################################################
# File    : UIViewCagegory.m
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

#import "UIView+SBMODULE.h"

@implementation UIView (sbmodule)


//frame accessors

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)top
{
    return self.origin.y;
}

- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)left
{
    return self.origin.x;
}

- (void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.left + self.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.top + self.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.left;
}

- (void)setX:(CGFloat)x
{
    self.frame = CGRectMake(x, self.top, self.width, self.height);
}

- (CGFloat)y
{
    return self.top;
}

- (void)setY:(CGFloat)y
{
    self.frame = CGRectMake(self.left, y, self.width, self.height);
}

//bounds accessors

- (CGSize)boundsSize
{
    return self.bounds.size;
}

- (void)setBoundsSize:(CGSize)size
{
    CGRect bounds = self.bounds;
    bounds.size = size;
    self.bounds = bounds;
}

- (CGFloat)boundsWidth
{
    return self.boundsSize.width;
}

- (void)setBoundsWidth:(CGFloat)width
{
    CGRect bounds = self.bounds;
    bounds.size.width = width;
    self.bounds = bounds;
}

- (CGFloat)boundsHeight
{
    return self.boundsSize.height;
}

- (void)setBoundsHeight:(CGFloat)height
{
    CGRect bounds = self.bounds;
    bounds.size.height = height;
    self.bounds = bounds;
}


- (CGFloat)centerX;
{
    return [self center].x;
}

- (void)setCenterX:(CGFloat)centerX;
{
    [self setCenter:CGPointMake(centerX, self.center.y)];
}

- (CGFloat)centerY;
{
    return [self center].y;
}

- (void)setCenterY:(CGFloat)centerY;
{
    [self setCenter:CGPointMake(self.center.x, centerY)];
}

//content getters

- (CGRect)contentBounds
{
    return CGRectMake(0.0f, 0.0f, self.boundsWidth, self.boundsHeight);
}

- (CGPoint)contentCenter
{
    return CGPointMake(self.boundsWidth/2.0f, self.boundsHeight/2.0f);
}

//additional frame setters

- (void)setLeft:(CGFloat)left right:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    frame.size.width = right - left;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width right:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - width;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setTop:(CGFloat)top bottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    frame.size.height = bottom - top;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height bottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - height;
    frame.size.height = height;
    self.frame = frame;
}

//animation

- (void)crossfadeWithDuration:(NSTimeInterval)duration
{
    //jump through a few hoops to avoid QuartzCore framework dependency
    CAAnimation *animation = [NSClassFromString(@"CATransition") animation];
    [animation setValue:@"kCATransitionFade" forKey:@"type"];
    animation.duration = duration;
    [self.layer addAnimation:animation forKey:nil];
}

- (void)crossfadeWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion
{
    [self crossfadeWithDuration:duration];
    if (completion)
    {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), completion);
    }
}

//added by nirui
- (CGPoint)originPointInWindow
{
    return [self convertPoint:CGPointMake(0, 0) toView:nil];
}

- (CGPoint)maxPointInWindow
{
    CGPoint originPoint = [self convertPoint:CGPointMake(0, 0) toView:nil];
    return CGPointMake(originPoint.x + self.width, originPoint.y + self.height);
}


#pragma mark -
#pragma mark 位置
//设置起点的y值
- (void)sb_setMinY:(CGFloat)top {
    CGRect rect = self.frame;
    
    rect.origin.y = top;
    
    self.frame = rect;
}

//设置起点的x值
- (void)sb_setMinX:(CGFloat)left {
    CGRect rect = self.frame;
    
    rect.origin.x = left;
    
    self.frame = rect;
}

//在视图上方
- (void)sb_topOfView:(UIView *)view {
    [self sb_topOfView:view withMargin:0];
}

//在视图上方多少像素
- (void)sb_topOfView:(UIView *)view withMargin:(CGFloat)margin {
    if (nil == view) {
        return;
    }
    
    CGRect rect = self.frame;
    
    rect.origin.y = view.frame.origin.y - self.frame.size.height - margin;
    
    self.frame = rect;
}

//在视图下方
- (void)sb_bottomOfView:(UIView *)view {
    [self sb_bottomOfView:view withMargin:0];
}

//在视图下方多少像素
- (void)sb_bottomOfView:(UIView *)view withMargin:(CGFloat)margin {
    if (nil == view) {
        return;
    }

    CGRect rect = self.frame;

    rect.origin.y = view.frame.origin.y + view.frame.size.height + margin;

    self.frame = rect;
}

//在视图左方
- (void)sb_leftOfView:(UIView *)view {
    [self sb_leftOfView:view withMargin:0];
}

//在视图左方多少像素
- (void)sb_leftOfView:(UIView *)view withMargin:(CGFloat)margin {
    [self sb_leftOfView:view withMargin:margin sameVertical:NO];
}

//在视图左方多少像素并垂直居中
- (void)sb_leftOfView:(UIView *)view withMargin:(CGFloat)margin sameVertical:(BOOL)same {
    if (nil == view) {
        return;
    }

    CGRect rect = self.frame;

    rect.origin.x = view.frame.origin.x - rect.size.width - margin;

    if (same) {
        rect.origin.y = view.frame.origin.y + (view.frame.size.height - rect.size.height) / 2;
    }

    self.frame = rect;
}

//在视图右方
- (void)sb_rightOfView:(UIView *)view {
    [self sb_rightOfView:view withMargin:0];
}

//在视图右方多少像素
- (void)sb_rightOfView:(UIView *)view withMargin:(CGFloat)margin {
    [self sb_rightOfView:view withMargin:margin sameVertical:NO];
}

//在视图右方多少像素并垂直居中
- (void)sb_rightOfView:(UIView *)view withMargin:(CGFloat)margin sameVertical:(BOOL)same {
    if (nil == view) {
        return;
    }

    CGRect rect = self.frame;

    rect.origin.x = view.frame.origin.x + view.frame.size.width + margin;

    if (same) {
        rect.origin.y = view.frame.origin.y + (view.frame.size.height - rect.size.height) / 2;
    }

    self.frame = rect;
}

//在另一视图的水平中间
- (void)sb_centerOfView:(UIView *)view {
    CGRect rect = self.frame;
    CGRect viewRect = view.frame;
    
    rect.origin.x = (viewRect.size.width - rect.size.width) / 2;
    
    self.frame = rect;
}

//在另一视图的垂直中间
- (void)sb_verticalOfView:(UIView *)view {
    CGRect rect = self.frame;
    CGRect viewRect = view.frame;
    
    rect.origin.y = (viewRect.size.height - rect.size.height) / 2;
    
    self.frame = rect;
}

#pragma mark -
#pragma mark 大小
//设置视图宽
- (void)sb_setWidth:(CGFloat)width {
    CGRect rect = self.frame;

    rect.size.width = width;

    self.frame = rect;
}

//设置视图高
- (void)sb_setHeight:(CGFloat)height {
    CGRect rect = self.frame;

    rect.size.height = height;

    self.frame = rect;
}

#pragma mark -
#pragma mark 其他
//添加单机手势
- (UITapGestureRecognizer *)sb_setTapGesture:(id)target action:(SEL)action {
    assert(nil != target);
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
    tap.delegate = target;
    return tap ;
}

/** 通过view获取controller */
- (UIViewController *)sb_viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]] && ![nextResponder isKindOfClass:[UINavigationController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    
    return nil;
}

@end
