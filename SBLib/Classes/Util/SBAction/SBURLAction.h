/*
 #####################################################################
 # File    : SBURLAction.h
 # Project :
 # Created : 2015-01-12
 # DevTeam : Thomas Develop
 # Author  : Thomas
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//
@interface SBURLAction : NSObject

/**
 需要导航到的url地址
 */
@property (nonatomic, strong, readonly) NSURL *url;

/**
 所有的参数构建成query
 */
@property (nonatomic, readonly) NSString* query;

/**
 如果url为http url，则会询问是否在外部打开
 默认为NO
 */
@property (nonatomic) BOOL openExternal;

/**
 ctrl的属性字典
 */
@property (strong, nonatomic) NSMutableDictionary *params; // setParams:forKey:


//////////////////////////////

+ (id)actionWithClassName:(NSString *)className;
+ (id)actionWithURL:(NSURL *)url;
+ (id)actionWithURLString:(NSString *)urlString;
- (id)initWithURL:(NSURL *)url;
- (id)initWithURLString:(NSString *)urlString;

/** 通过配置 生成一个界面控制器 */
+ (UIViewController *)sb_initCtrl:(SBURLAction *)urlAction;

- (void)setInteger:(NSInteger)intValue forKey:(NSString *)key;
- (void)setDouble:(double)doubleValue forKey:(NSString *)key;
- (void)setString:(NSString *)string forKey:(NSString *)key;
- (void)setObject:(NSObject *)object forKey:(NSString *)key;
- (void)setAnyObject:(id)object forKey:(NSString *)key;

/**
 一次性写入多个参数
 使用场景：
 拷贝另一个SBURLAction的参数值到新的SBURLAction中
 */
- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary;
/**
 使用场景：
 从另一个SBURLAction拷贝参数
 */
- (void)addParamsFromURLAction:(SBURLAction *)otherURLAction;

- (NSInteger)integerForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;
- (NSObject *)objectForKey:(NSString *)key;
- (id)anyObjectForKey:(NSString *)key;

/**
 *  parameters for navigator
 *
 *  @return
 */
- (NSDictionary *)queryDictionary;

@end


/** url跳转 会猜测根nav来跳转 c方法 */
UIViewController *sb_openCtrl(SBURLAction *urlAction);
void sb_colseCtrl();

@interface UIViewController (urlAction)
@property (nonatomic, strong) SBURLAction *urlAction;

/**
 在当前的 栈中打开新的URL
 
 可以向SBURLAction中传入制定的参数，参数可以为integer, double, string3种类型
 bool的参数可以用0和1表示
 
 URL中附带的参数和setXXX:forKey:所设置的参数等价，
 例如下面两种写法是等价的：
 SBURLAction *a = [SBURLAction actionWithURL:@"stockbar://shop?id=1"];
 和
 SBURLAction *a = [SBURLAction actionWithURL:@"stockbar://shop"];
 [a setInteger:1 forKey:@"id"]
 
 在获取参数时，调用[a integerForKey:@"id"]，返回值均为1
 */
- (UIViewController *)sb_openCtrl:(SBURLAction *)urlAction;
- (UIViewController *)sb_modalCtrl:(SBURLAction *)urlAction;
/** 跳转到root 再推出界面 */
- (UIViewController *)sb_popRootAndOpenCtrl:(SBURLAction *)urlAction;

/** 在当前的 栈中关闭新的URL */
- (void)sb_colseCtrl;
- (void)sb_dismissCtrl:(void (^)(void))completion;
/** 仅仅推出只需要 init 就可以实现功能的界面 */
- (UIViewController *)sb_quickOpenCtrl:(NSString *)ctrlName;

/** 赋值ctrl的属性值 */
- (void)sb_setPropertyForController:(SBURLAction *)action;
@end

/** url跳转 根据当前nav来跳转 */
@interface UINavigationController (urlAction)
- (UIViewController *)sb_openCtrl:(SBURLAction *)urlAction;
- (UIViewController *)sb_modalCtrl:(SBURLAction *)urlAction;
- (UIViewController *)sb_popRootAndOpenCtrl:(SBURLAction *)urlAction;
- (void)sb_colseCtrl;
- (UIViewController *)sb_quickOpenCtrl:(NSString *)ctrlName;
@end

@interface NSURL (urlAction)

/**
 将query解析为NSDictionary
 
 @return 返回参数字典对象，参数的值已经进行了decode.
 (stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding)
 */
- (NSDictionary *)parseQuery;

@end



