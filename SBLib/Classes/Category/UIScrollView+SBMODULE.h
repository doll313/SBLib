//
//  UIScrollView+SBMODULE.h
//  Pods
//
//  Created by roronoa on 2017/4/21.
//
//

#import <UIKit/UIKit.h>

/** UIScrollView 扩展 **/
@interface UIScrollView (sbmodule)


@property (nonatomic, weak) UIView *sb_topView;        //顶部 View

/** 添加头部拉伸 **/
- (void)sb_addSpringHeadView:(UIView *)view;
@end
