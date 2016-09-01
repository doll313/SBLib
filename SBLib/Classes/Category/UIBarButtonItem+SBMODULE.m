/*
 #####################################################################
 # File    : UIBarButtonItemCategory.m
 # Project : 
 # Created : 2012-01-21
 # DevTeam : 
 # Author  : thomas (roronoa@foxmail.com)
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

#import "UIBarButtonItem+SBMODULE.h"

#define __FLOAT_FONT_ITEM           15.0f

@implementation UIBarButtonItem (sbmodule)

//空
+ (UIBarButtonItem *)sb_flexItem {
    UIBarButtonItem *_item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                         target:nil
                                                         action:nil];
    
    return  _item;
}

@end
