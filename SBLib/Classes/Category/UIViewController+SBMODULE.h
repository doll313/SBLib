//
//  UIViewController+SBMODULE.h
//  SBLib
//
//  Created by roronoa on 2018/1/19.
//

#import <UIKit/UIKit.h>

//为SDK自带的 UIViewController 类添加一些实用方法
@interface UIViewController (sbmodule)

/** 分享沙盒地址 **/
- (void)sb_shareDocumentPath:(NSString *_Nonnull)path;

@end
