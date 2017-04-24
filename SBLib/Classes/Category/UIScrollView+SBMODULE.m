//
//  UIScrollView+SBMODULE.m
//  Pods
//
//  Created by roronoa on 2017/4/21.
//
//

#import "UIScrollView+SBMODULE.h"
#import <objc/runtime.h>


static char SBScrollViewSpringHeadView;

@implementation UIScrollView(sbmodule)

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)setSb_topView:(UIView *)sb_topView {
    [self willChangeValueForKey:@"SBSpringHeadView"];
    objc_setAssociatedObject(self, &SBScrollViewSpringHeadView,
                             sb_topView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"SBSpringHeadView"];
}

- (UIView *)sb_topView{
    return objc_getAssociatedObject(self, &SBScrollViewSpringHeadView);
}


- (void)sb_addSpringHeadView:(UIView *)view{
    self.contentInset = UIEdgeInsetsMake(view.bounds.size.height, 0, 0, 0);
    [self addSubview:view];
    view.frame = CGRectMake(0, -view.bounds.size.height, view.bounds.size.width, view.bounds.size.height);
    self.sb_topView = view;
    //使用kvo监听scrollView的滚动
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self sb_springHearder:self];
}

- (void)sb_springHearder:(UIScrollView *)scrollView{
    CGFloat offy = scrollView.contentOffset.y;

    if (offy < 0) {
        self.sb_topView.frame = CGRectMake(0, offy, self.sb_topView.bounds.size.width, -offy);
    }
}



@end
