//
//  SBRefreshHeader.m
//  Pods
//
//  Created by roronoa on 2017/7/4.
//
//

#import "SBRefreshHeader.h"            //橡皮膏刷新
#import <QuartzCore/QuartzCore.h>
#import "UIScrollView+MJExtension.h"
#import "UIView+MJExtension.h"
#import "UIView+SBMODULE.h"
static NSString *const kSBRefreshContentOffset = @"contentOffset";
static NSString *const kSBRefreshContentOffsetPanState = @"state";

static CGFloat const kSBRefreshOpenHeight = 33.0f;  /**< 刷新ing高度 */
static CGFloat const kSBRefreshTopMaxPadding = 9.0f;  /**< 最大上边距 */
static CGFloat const kSBRefreshTopMinPadding = 7.0f;  /**< 最小上边距 */
static CGFloat const kSBRefreshTopMaxRadius = 14.0f;  /**< 最大上圆半径 */
static CGFloat const kSBRefreshTopMinRadius = 11.5f;  /**< 最小上圆半径 */
static CGFloat const kSBRefreshBottomMaxPadding = 6.0f;  /**< 最大下边距 */
static CGFloat const kSBRefreshBottomMinPadding = 5.0f;  /**< 最小下边距 */
static CGFloat const kSBRefreshBottomMaxRadius = kSBRefreshTopMaxRadius;  /**< 最大下圆半径 */
static CGFloat const kSBRefreshBottomMinRadius = 3.0f;  /**< 最小下圆半径 */
static CGFloat const kSBRefreshArrowMaxSize = 2.5f;  /**< 最大箭头 */
static CGFloat const kSBRefreshArrowMinSize = 1.5f;  /**< 最小箭头 */
static CGFloat const kSBRefreshArrowMaxRadius = 6.0f;  /**< 最大箭头半径 */
static CGFloat const kSBRefreshArrowMinRadius = 5.0f;  /**< 最小箭头半径 */
static CGFloat const kSBRefreshMaxDistnce = 43.0f;  /**< 拉伸回弹的距离 */
static CGFloat const kSBRefreshPulling2RefreshingHeight = kSBRefreshTopMaxPadding + kSBRefreshTopMaxRadius + kSBRefreshBottomMaxRadius + kSBRefreshBottomMaxPadding + kSBRefreshMaxDistnce; /**< 拉拽多高开始刷新 拉拽到刷新的临界点 */  //86.0f

typedef NS_ENUM(NSInteger, SBRefreshState){
    SBRefreshStateNomal,   /**< 初始状态 */                                 //透明色
    SBRefreshStatePullingNoRefreshing,  /**< 不在刷新的拉拽 */               //橙色
    SBRefreshStatePullingRefreshing,  /**< 拉拽中的刷新 仅仅是刷新动画 */      //黄色
    SBRefreshStateRefreshing,  /**< 刷新中 真的是在刷新了 */                  //绿色
    SBRefreshStateWillRefresh, /**< 即将刷新，当页面未显示的时候触发了下拉刷新 */ //蓝色
    SBRefreshStateWillBackNomal  /**< 结束刷新即将恢复到初始状态中间的过渡 */    //紫色
};

@interface SBRefreshHeader ()
@property (nonatomic, copy)   void(^refreshingBlock)(void); /**< 刷新中回调block */
@property (nonatomic, assign) SBRefreshState state;   /**< 刷新状态 */
@property (nonatomic, weak)   UIScrollView *scrollView;  /**< 父视图 */
@property (nonatomic, strong) CAShapeLayer *shapeLayer;  /**< 橡皮糖 */
@property (nonatomic, strong) CAShapeLayer *arrowLayer;  /**< 箭头 */
@property (nonatomic, strong) UIActivityIndicatorView *activityView; /**< 菊花 */
@property (nonatomic, strong) UILabel *debugLabel; /**< 调试lab */

@property (nonatomic, assign) CGFloat scrollViewOriginalInsetTop;  /**<  */
@property (nonatomic, assign) CGFloat insetTDelta;  /**< insetT的变化值 */
@property (nonatomic, strong) UIPanGestureRecognizer *pan; /**< 滑动手势 */

@property (nonatomic, assign) BOOL isRefreshBounce; /**< 标记是否开始刷新的回弹动画结束 */
@property (nonatomic, assign) BOOL isManualRefreshing; /**< 标记是否是来源自主动触发的下拉刷新 */
@property (nonatomic, assign) BOOL isWillRefresh; /**< 标记是否来源自即将刷新状态 */
@property (nonatomic, assign) BOOL isNormal; /**< 是否初始化 ，YES的话有偏移量就会触发橡皮糖 场景：刷新中，拉拽住header，然后结束刷新恢复刷新头insetT,这个时候还有有偏移量，移动的话出现橡皮糖，显得比较丑陋，所以控制一下 */
@end

@implementation SBRefreshHeader

+ (instancetype)headerWithRefreshingBlock:(void(^)(void))refreshingBlock {
    SBRefreshHeader *header = [[self alloc] init];
    header.refreshingBlock = refreshingBlock;
    return header;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //准备工作
        [self prepare];
        //默认是初始状态
        _state = SBRefreshStateNomal;
        _isNormal = YES;
    }
    return self;
}

- (void)dealloc {

}

#pragma mark - override
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.state == SBRefreshStateWillRefresh) {
        // 预防view还没显示出来就调用了beginRefreshing
        self.state = SBRefreshStateRefreshing;
        //先清除一下刷新layer
        [self clearLayer];
        // 显示菊花
        [self showActivityIndicator];
        self.isWillRefresh = YES;
    } else {
        self.isWillRefresh = NO;
    }
}

- (void)layoutSubviews {
    //设置y坐标
    self.mj_y = - self.mj_h;
    [super layoutSubviews];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    // 旧的父控件移除监听
    [self removeObservers];
    
    if (newSuperview) { // 新的父控件
        // 设置宽度
        self.mj_w = newSuperview.mj_w;
        // 设置位置
        self.mj_x = 0;
        
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 设置永远支持垂直弹簧效果
        _scrollView.alwaysBounceVertical = YES;
        // 记录UIScrollView最开始的contentInset
        _scrollViewOriginalInsetTop = _scrollView.mj_insetT;
        
        // 添加监听
        [self addObservers];
    }
}

#pragma mark - public methods
- (void)beginRefreshing {
    //如果是正在刷新的状态，则略过
    if (self.isRefreshing) {
        return;
    }
    //如果是正在恢复状态，则视为刷新中
    if (self.state == SBRefreshStateWillBackNomal) {
        return;
    }
    //标记是主动刷新的
    self.isManualRefreshing = YES;
    //只要正在刷新，就完全显示
    if (self.window) {
        self.state = SBRefreshStateRefreshing;
        //先清除一下刷新layer
        [self clearLayer];
        //显示菊花
        [self showActivityIndicator];
    } else {
        //预防正在刷新中时，调用本方法使得header inset回置失败
        if (self.state != SBRefreshStateRefreshing && self.state != SBRefreshStateWillBackNomal) {
            self.state = SBRefreshStateWillRefresh;
            // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
            [self setNeedsDisplay];
        }
    }
}

- (void)endRefreshing {
    
    if (!self.isRefreshing) {
        return;
    }
    if (self.isWillRefresh) {
        self.isWillRefresh = NO;
        //如果是即将刷新，则延迟设置刷新头的状态
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.state = SBRefreshStateWillBackNomal;
        });
    } else {
        //iOS8下需要加延时，否则会导致tableView的sectionHeaderView显示有问题
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.state = SBRefreshStateWillBackNomal;
        });
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // 遇到这些情况就直接返回
    if (!self.userInteractionEnabled) return;
    // 看不见
    if (self.hidden) return;
    
    if ([keyPath isEqualToString:kSBRefreshContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    } else if ([keyPath isEqualToString:kSBRefreshContentOffsetPanState]) {
        [self scrollViewPanStateDidChange:change];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    // 在刷新的refreshing状态
    if (self.state == SBRefreshStateRefreshing) {
        if (self.window == nil) return;
        /** sectionheader停留解决 */
        CGFloat insetT = - self.scrollView.mj_offsetY > _scrollViewOriginalInsetTop ? - self.scrollView.mj_offsetY : _scrollViewOriginalInsetTop;
        insetT = insetT > kSBRefreshOpenHeight + _scrollViewOriginalInsetTop ? kSBRefreshOpenHeight + _scrollViewOriginalInsetTop: insetT;
        
        //非回弹动画情况下才设置insetT
        if (!self.isRefreshBounce) {
            self.scrollView.mj_insetT = insetT;
        }
        
        self.insetTDelta = _scrollViewOriginalInsetTop - insetT;
        // 当前的contentOffset
        CGFloat offsetY = self.scrollView.mj_offsetY;
        // 头部控件刚好出现的offsetY
        CGFloat happenOffsetY = - _scrollViewOriginalInsetTop;
        // 如果是向上滚动到看不见头部控件，直接返回
        if (offsetY > happenOffsetY) return;
        
        //更新UI
        [self updateUIWithRealOffset:offsetY-happenOffsetY];
        return;
    }
    
    // 跳转到下一个控制器时，contentInset可能会变,系统可能会因为导航栏自动将inset上面留出64的空隙等
    _scrollViewOriginalInsetTop = self.scrollView.mj_insetT;
    
    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.mj_offsetY;
    
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = -_scrollViewOriginalInsetTop;
    // 如果是向上滚动到看不见头部控件，直接返回
    if (offsetY > happenOffsetY) return;
    //计算出真实的相对偏移量y
    CGFloat realOffsetY = offsetY-happenOffsetY;
    if (fabs(realOffsetY) <= 5 && self.state != SBRefreshStateWillBackNomal) {
        //非回弹状态且偏移量小于5则认为是恢复到初始化状态了
        self.isNormal = YES;
    }
    //更新UI位置
    [self updateUIWithRealOffset:realOffsetY];
    //拉拽到刷新的偏移临界值Y
    CGFloat pulling2refreshingOffsetY = happenOffsetY - kSBRefreshPulling2RefreshingHeight;
    //判断是否正在拉拽，这里header肯定是拉出来了，上面已经拦截了拉上去的情况了
    if (self.scrollView.isDragging) {
        //如果当前是初始状态
        if (self.state == SBRefreshStateNomal)
        {
            //当前偏移量绝对值小于临界值绝对值
            if (fabs(offsetY) < fabs(pulling2refreshingOffsetY)) {
                // 修改为不在刷新的拉拽
                self.state = SBRefreshStatePullingNoRefreshing;
                
                // 状态改变后就绘制橡皮糖，为了当极快速度下拉的时候，没有橡皮糖的效果
                [self drawAnimateWithOffset:realOffsetY];
            } else {
                //大于等于临界值证明拉拽太快，导致没有检测到前面的offset变化点，直接丢弃掉
            }
        }
        else if (self.state == SBRefreshStatePullingNoRefreshing)
        {
            //如果是还没触发刷新的正在拉拽中
            [self drawAnimateWithOffset:realOffsetY];
        }
    } else {
        if (self.state == SBRefreshStatePullingRefreshing) {
            
            if (realOffsetY >= 0) {
                /** 如果是滑动太快或者上拉到看不见刷新头，就放弃刷新，虽然刷新动画出来了。
                 *  否则会出现bounce效果导致刷新头看不见，刷新的时候不会触发insetT+33,但是刷新结束会减去33，导致页面向上偏移33。
                 */
                self.state = SBRefreshStateNomal;
            } else {
                //如果是拉拽中的刷新，一旦没有在拖拽，则进入刷新状态
                self.state = SBRefreshStateRefreshing;
            }
        } else if (self.state == SBRefreshStatePullingNoRefreshing) {
            //如果是不在刷新的拉拽，则去绘制橡皮糖
            [self drawAnimateWithOffset:realOffsetY];
            
            //如果恢复了，就设置回初始状态
            if (self.scrollView.mj_offsetY == -self.scrollView.mj_insetT) {
                self.state = SBRefreshStateNomal;
            }
        }
    }
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    
    if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        //如果是拉拽中等待刷新的状态，则松开设置为刷新
        if (self.state == SBRefreshStatePullingRefreshing) {
            //这里需要分辨当前向下偏移还是向上偏移，否则会导致刷新没有加上33的insetT,结束刷新的时候减去了33，导致页面向上偏移33
            if (self.scrollView.mj_offsetY <= -self.scrollView.mj_insetT) {
                self.state = SBRefreshStateRefreshing;
            } else {
                self.state = SBRefreshStateNomal;
            }
        }
    }
}

/** 修正Header的各控件位置 */
- (void)updateUIWithRealOffset:(CGFloat)realOffsetY {
    
    //设置header的高度
    self.mj_h = fmax(fabs(realOffsetY), kSBRefreshOpenHeight);
    //修正菊花的位置，菊花一定是处于顶部的，不管header高度有多大
    self.activityView.centerY = fmin(self.mj_h-kSBRefreshOpenHeight*0.5, self.mj_h+kSBRefreshOpenHeight*0.5+realOffsetY);
    self.activityView.centerX = self.scrollView.width/2.0f;
    //设置header的y坐标
    self.mj_y = - self.mj_h;
}

#pragma mark - private methods

/** 初始化准备 */
- (void)prepare {
    // 基本属性
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
    self.mj_h = kSBRefreshOpenHeight;
    [self addSubview:self.activityView];
    [self.layer addSublayer:self.shapeLayer];
    [self.layer addSublayer:self.arrowLayer];
}

/** 添加观察者 */
- (void)addObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:kSBRefreshContentOffset options:options context:nil];
    self.pan = self.scrollView.panGestureRecognizer;
    [self.pan addObserver:self forKeyPath:kSBRefreshContentOffsetPanState options:options context:nil];
}

/** 移除观察者 */
- (void)removeObservers {
    [self.superview removeObserver:self forKeyPath:kSBRefreshContentOffset];
    [self.pan removeObserver:self forKeyPath:kSBRefreshContentOffsetPanState];
    self.pan = nil;
}

/** 执行刷新回调 */
- (void)executeRefreshingCallback {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
    });
}

/** 计算动态改变的大小 */
CGFloat fetchLerp1(CGFloat a,CGFloat b,CGFloat p) {
    return a + (b - a) * p;
}

/** 拉拽动画 */
- (void)drawAnimateWithOffset:(CGFloat)offset {
    
    //有橡皮糖形变的时候，肯定是看不见菊花的
    [self hideActivityIndicator];
    if (!self.isNormal) {
        //不显示
        return;
    }
    
    BOOL triggered = NO; //默认是不触发刷新的
    CGMutablePathRef path = CGPathCreateMutable();
    //计算垂直方向的移动
    CGFloat verticalShift = fmaxf(0, -(kSBRefreshTopMaxRadius + kSBRefreshBottomMaxRadius + kSBRefreshTopMaxPadding + kSBRefreshBottomMaxPadding + offset));
    
    //计算间距 需要形变的间距
    CGFloat distance = fminf(kSBRefreshMaxDistnce, fabs(verticalShift));
    
    //形变百分比 在橡皮糖不需要形变的时候，为1
    CGFloat percentage = 1 - (distance / kSBRefreshMaxDistnce);
    
    //上面间隙
    CGFloat currentTopPadding = fetchLerp1(kSBRefreshTopMinPadding, kSBRefreshTopMaxPadding, percentage);
    
    //上圆的半径
    CGFloat currentTopRadius = fetchLerp1(kSBRefreshTopMinRadius, kSBRefreshTopMaxRadius, percentage);
    
    //下圆的半径
    CGFloat currentBottomRadius = fetchLerp1(kSBRefreshBottomMinRadius, kSBRefreshBottomMaxRadius, percentage);
    
    //下面的间隙
    CGFloat currentBottomPadding = fetchLerp1(kSBRefreshBottomMinPadding, kSBRefreshBottomMaxPadding, percentage);
    
    //下圆心
    CGPoint bottomOrigin = CGPointMake(self.bounds.size.width/2, self.bounds.size.height - currentBottomPadding - currentBottomRadius);
    
    //上圆心
    CGPoint topOrigin = CGPointZero;
    if (distance == 0) {
        topOrigin = CGPointMake(self.bounds.size.width*0.5, bottomOrigin.y);
    } else {
        topOrigin = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height + offset + currentTopPadding + currentTopRadius);
        if (percentage == 0) {
            //要触发刷新了
            triggered = YES;
            bottomOrigin.y -= verticalShift - kSBRefreshMaxDistnce;
        }
    }
    
    //绘上圆
    CGPathAddArc(path, NULL, topOrigin.x, topOrigin.y, currentTopRadius, 0, M_PI, YES);
    
    //左外切曲线
    CGPoint leftCp1 = CGPointMake(fetchLerp1(topOrigin.x - currentTopRadius, bottomOrigin.x - currentBottomRadius, 0.1), fetchLerp1(topOrigin.y, bottomOrigin.y, 0.2));
    CGPoint leftCp2 = CGPointMake(fetchLerp1(topOrigin.x - currentTopRadius, bottomOrigin.x - currentBottomRadius, 0.9), fetchLerp1(topOrigin.y, bottomOrigin.y, 0.2));
    CGPoint leftDestination = CGPointMake(bottomOrigin.x - currentBottomRadius, bottomOrigin.y);
    CGPathAddCurveToPoint(path, NULL, leftCp1.x, leftCp1.y, leftCp2.x, leftCp2.y, leftDestination.x, leftDestination.y);
    //绘下圆
    CGPathAddArc(path, NULL, bottomOrigin.x, bottomOrigin.y, currentBottomRadius, M_PI, 0, YES);
    
    //右外切曲线
    CGPoint rightCp1 = CGPointMake(fetchLerp1(topOrigin.x + currentTopRadius, bottomOrigin.x + currentBottomRadius, 0.9), fetchLerp1(topOrigin.y, bottomOrigin.y, 0.2));
    CGPoint rightCp2 = CGPointMake(fetchLerp1(topOrigin.x + currentTopRadius, bottomOrigin.x + currentBottomRadius, 0.1), fetchLerp1(topOrigin.y, bottomOrigin.y, 0.2));
    CGPoint rightDestination = CGPointMake(topOrigin.x + currentTopRadius, topOrigin.y);
    CGPathAddCurveToPoint(path, NULL, rightCp1.x, rightCp1.y, rightCp2.x, rightCp2.y, rightDestination.x, rightDestination.y);
    
    //闭合路径
    CGPathCloseSubpath(path);
    
    //不触发刷新
    if (!triggered) {
        //设置形变
        _shapeLayer.path = path;
        _shapeLayer.shadowPath = path;
        
        ////绘制箭头
        
        //箭头宽度
        CGFloat currentArrowSize = fetchLerp1(kSBRefreshArrowMinSize, kSBRefreshArrowMaxSize, percentage);
        //箭头半径
        CGFloat currentArrowRadius = fetchLerp1(kSBRefreshArrowMinRadius, kSBRefreshArrowMaxRadius, percentage);
        //箭头外圆
        CGFloat arrowBigRadius = currentArrowRadius + currentArrowSize*0.5;
        //箭头内圆
        CGFloat arrowSmallRadius = currentArrowRadius - currentArrowSize*0.5;
        //箭头路径
        CGMutablePathRef arrowPath = CGPathCreateMutable();
        //绘制外圆
        CGPathAddArc(arrowPath, NULL, topOrigin.x, topOrigin.y, arrowBigRadius, 0 * M_PI_2, 3 * M_PI_2, NO);
        //绘制箭头的4根线
        CGPathAddLineToPoint(arrowPath, NULL, topOrigin.x, topOrigin.y - arrowBigRadius - currentArrowSize);
        CGPathAddLineToPoint(arrowPath, NULL, topOrigin.x + (2 * currentArrowSize), topOrigin.y - arrowBigRadius + currentArrowSize/2);
        CGPathAddLineToPoint(arrowPath, NULL, topOrigin.x, topOrigin.y - arrowBigRadius + 2*currentArrowSize);
        CGPathAddLineToPoint(arrowPath, NULL, topOrigin.x, topOrigin.y - arrowBigRadius + currentArrowSize);
        //绘制内圆
        CGPathAddArc(arrowPath, NULL, topOrigin.x, topOrigin.y, arrowSmallRadius, 3 * M_PI_2, 0 * M_PI_2, YES);
        //闭合路径
        CGPathCloseSubpath(arrowPath);
        //设置箭头
        _arrowLayer.path = arrowPath;
        [_arrowLayer setFillRule:kCAFillRuleEvenOdd];
        //释放
        CGPathRelease(arrowPath);
        
        //拉拽到位，开始刷新了
    } else {
        
        //消失动画
        CGFloat radius = fetchLerp1(kSBRefreshBottomMinRadius, kSBRefreshBottomMaxRadius, 0.2);
        CABasicAnimation *pathMorph = [CABasicAnimation animationWithKeyPath:@"path"];
        pathMorph.duration = 0.15;
        pathMorph.fillMode = kCAFillModeForwards;
        pathMorph.removedOnCompletion = NO;
        
        //shape的回弹消失动画
        CGMutablePathRef toPath = CGPathCreateMutable();
        CGPathAddArc(toPath, NULL, topOrigin.x, topOrigin.y, radius, 0, M_PI, YES);
        CGPathAddCurveToPoint(toPath, NULL, topOrigin.x - radius, topOrigin.y, topOrigin.x - radius, topOrigin.y, topOrigin.x - radius, topOrigin.y);
        CGPathAddArc(toPath, NULL, topOrigin.x, topOrigin.y, radius, M_PI, 0, YES);
        CGPathAddCurveToPoint(toPath, NULL, topOrigin.x + radius, topOrigin.y, topOrigin.x + radius, topOrigin.y, topOrigin.x + radius, topOrigin.y);
        CGPathCloseSubpath(toPath);
        pathMorph.toValue = (__bridge id)toPath;
        [_shapeLayer addAnimation:pathMorph forKey:nil];
        
        //        CABasicAnimation *shadowPathMorph = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
        //        shadowPathMorph.duration = 0.15;
        //        shadowPathMorph.fillMode = kCAFillModeForwards;
        //        shadowPathMorph.removedOnCompletion = NO;
        //        shadowPathMorph.toValue = (__bridge id)toPath;
        //        [_shapeLayer addAnimation:shadowPathMorph forKey:nil];
        //        CGPathRelease(toPath);
        
        //shape的透明度动画
        CABasicAnimation *shapeAlphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        shapeAlphaAnimation.duration = 0.25;
        shapeAlphaAnimation.toValue = [NSNumber numberWithFloat:0];
        shapeAlphaAnimation.fillMode = kCAFillModeForwards;
        shapeAlphaAnimation.removedOnCompletion = NO;
        [_shapeLayer addAnimation:shapeAlphaAnimation forKey:nil];
        
        //箭头的透明度动画
        CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        alphaAnimation.duration = 0.1;
        alphaAnimation.toValue = [NSNumber numberWithFloat:0];
        alphaAnimation.fillMode = kCAFillModeForwards;
        alphaAnimation.removedOnCompletion = NO;
        [_arrowLayer addAnimation:alphaAnimation forKey:nil];
        
        //        [CATransaction begin];
        //        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        //        [self hideActivityIndicator];
        //        [CATransaction commit];
        
        //指示器渐变显示出来
        [UIView animateWithDuration:0.2f delay:0.15f options:UIViewAnimationOptionCurveLinear animations:^{
            [self showActivityIndicator];
        } completion:^(BOOL finished) {
            //清除layer
            [self clearLayer];
        }];
        
        //判断当前是否仍旧拖拽。这里拖拽情况下，开始刷新动画，但是不是真正的刷新，不会发出请求。
        if (self.scrollView.isDragging) {
            //转为开始刷新动画的拉拽
            self.state = SBRefreshStatePullingRefreshing;
        } else {
            //转为开始刷新，真正的刷新
            self.state = SBRefreshStateRefreshing;
        }
    }
    CGPathRelease(path);
}

/** 清除layer */
- (void)clearLayer {
    [self.shapeLayer removeAllAnimations];
    self.shapeLayer.path = nil;
    self.shapeLayer.shadowPath = nil;
    self.shapeLayer.position = CGPointZero;
    [self.arrowLayer removeAllAnimations];
    self.arrowLayer.path = nil;
    self.isNormal = NO;//设置为NO
}

/** 显示活动指示器 */
- (void)showActivityIndicator {
    [self.activityView startAnimating];
    self.activityView.hidden = NO;
    self.activityView.alpha = 1.0f;
    self.activityView.layer.transform = CATransform3DIdentity;
}

/** 隐藏活动指示器 */
- (void)hideActivityIndicator {
    [self.activityView startAnimating];
    self.activityView.hidden = NO;
    self.activityView.alpha = 0.0f;
    self.activityView.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
}


/**
 刷新头执行刷新
 
 @param need 是否需要弹出刷新头
 */
- (void)refreshHeaderBounce:(BOOL)need {
    
    if (need || self.isManualRefreshing) {
        self.isManualRefreshing = NO;
        self.isRefreshBounce = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25f animations:^{
                CGFloat top = _scrollViewOriginalInsetTop + kSBRefreshOpenHeight;
                // 增加滚动区域top
                self.scrollView.mj_insetT = top;
                // 设置滚动位置
                [self.scrollView setContentOffset:CGPointMake(0, -top) animated:NO];
            } completion:^(BOOL finished) {
                self.isRefreshBounce = NO;
                [self executeRefreshingCallback];
            }];
        });
    } else {
        //直接执行刷新
        [self executeRefreshingCallback];
    }
}

#pragma mark - setters

- (void)setState:(SBRefreshState)state {
    SBRefreshState oldState = _state;
    if (oldState == state) return;
    _state = state;
    
    // 加入主队列的目的是等setState:方法调用完毕、设置完文字后再去布局子控件
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsLayout];
    });
    
    if (state == SBRefreshStateRefreshing) {
        
        if (self.scrollView.mj_offsetY+_scrollViewOriginalInsetTop < -kSBRefreshOpenHeight) {
            [self refreshHeaderBounce:YES];
        } else {
            [self refreshHeaderBounce:NO];
        }
    } else if (state == SBRefreshStateWillBackNomal) {
        //如果是从normal变为backNormal的，直接修改为normal
        if (oldState == SBRefreshStateNomal) {
            self.state = SBRefreshStateNomal;
        }
        if (oldState != SBRefreshStateRefreshing && oldState != SBRefreshStateWillRefresh && oldState != SBRefreshStateWillBackNomal) return;
        if (oldState == SBRefreshStateWillRefresh && self.isWillRefresh) return;
        [self hideActivityIndicator];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.4f animations:^{
                self.scrollView.mj_insetT += self.insetTDelta;
            } completion:^(BOOL finished) {
                self.state = SBRefreshStateNomal;
            }];
        });
    } else if (state == SBRefreshStateNomal) {
        
        if (self.scrollView.mj_offsetY >= -self.scrollView.mj_insetT) {
            self.isNormal = YES;
        }
    }
}

#pragma mark - getters
- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = RGB_HEX(0xC1C1C1).CGColor;
        _shapeLayer.strokeColor = RGB_HEX(0xC1C1C1).CGColor;
        _shapeLayer.lineWidth = 0.5;
    }
    return _shapeLayer;
}

- (CAShapeLayer *)arrowLayer {
    if (!_arrowLayer) {
        _arrowLayer = [CAShapeLayer layer];
        _arrowLayer.fillColor = [UIColor whiteColor].CGColor;
        _arrowLayer.strokeColor = [UIColor whiteColor].CGColor;
        _arrowLayer.lineWidth = 0.5;
    }
    return _arrowLayer;
}

- (UIActivityIndicatorView *)activityView {
    
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.frame = CGRectMake(0, 0, 28, 28);
        _activityView.centerX = self.scrollView.width/2.0f;
        _activityView.centerY = kSBRefreshOpenHeight/2.0f;
        [self hideActivityIndicator];
    }
    return _activityView;
}

- (BOOL)isRefreshing {
    return self.state == SBRefreshStateRefreshing || self.state == SBRefreshStateWillRefresh || self.state == SBRefreshStatePullingRefreshing;
}

@end
