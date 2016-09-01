/*
 #####################################################################
 # File    : STORE.h
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

#pragma mark -
#pragma mark 数据库类型名
/** 数据库版本信息 */
#define STORE_DB_VERSION_INFO                 @"STORE_DB_VERSION_INFO"

/** 异常信息 */
#define STORE_EXCEPTION_INFO                  @"STORE_EXCEPTION_INFO"

/** 应用程序非核心信息(清空缓存时，可以清除的数据) */
#define STORE_CACHE_IMAGES                    @"STORE_CACHE_IMAGES"                   // 图片缓存
#define STORE_CACHE_TABLEDATA                 @"STORE_CACHE_TABLEDATA"        // 列表最后一次访问的数据缓存
#define STORE_CACHE_ARTICLE                @"STORE_CACHE_ARTICLE"                    // 帖子数据缓存

/** 应用程序核心设置信息 */
#define STORE_CORE_CLIENT_VERSION_INFO        @"STORE_CORE_CLIENT_VERSION_INFO"       // 存放客户端当前版本信息
#define STORE_CORE_APP_UPGRADE                @"STORE_CORE_APP_UPGRADE"               // 应用程序版本检测和升级信息
#define STORE_CORE_USER_LOGIN                 @"STORE_CORE_USER_LOGIN"                // 用于记录当前用户上次登录情况
#define STORE_CORE_APP_SETTINGS               @"STORE_CORE_APP_SETTINGS"              // 当前应用的一些设置信息，如默认皮肤名等
#define STORE_CORE_APP_SKIN                   @"STORE_CORE_APP_SKIN"                  // 系统皮肤缓存类
#define STORE_CORE_USER_INFO                  @"STORE_CORE_USER_INFO"                 // 当前手机登录用户的信息
#define STORE_CORE_CONTENT_SHARE              @"STORE_CORE_CONTENT_SHARE"             // 微博授权信息
#define STORE_CORE_LOCATION                   @"STORE_CORE_LOCATION"                  // 定位的结果
#define STORE_CORE_TIP_MESSAGE                @"STORE_CORE_TIP_MESSAGE"               // 各种图片帮助界面的显示时间等
#define STORE_CORE_DEVICE_TOKEN               @"STORE_CORE_DEVICE_TOKEN"              // 推送的devicetoken

/** 应用程序数据字典信息(清空缓存时，可以清除的数据) */
#pragma mark -
#pragma mark 数据库键名
#define STORE_KEY_SHOW_COMMENT_ALERT        @"STORE_KEY_SHOW_COMMENT_ALERT"   // 是否已经弹出过评分提醒
#define STORE_KEY_LAST_SHOW_ALERT_TIME      @"STORE_KEY_LAST_SHOW_ALERT_TIME" // 上次显示警告窗的时间
#define STORE_KEY_LAST_LOGIN_TIME           @"STORE_KEY_LAST_LOGIN_TIME"      // 用户上次登陆时间
#define STORE_KEY_APP_VERSION_FLAG          @"STORE_KEY_APP_VERSION_FLAG"     // 当前版本唯一标识key名
#define STORE_KEY_DEVICE_UUID             @"STORE_KEY_DEVICE_UUID"        // uuid
#define STORE_KEY_DEVICE_CFUDID             @"STORE_KEY_DEVICE_CFUDID"        // cfudid
#define STORE_KEY_APP_VERSION             @"STORE_KEY_APP_VERSION"        // 应用版本号
#define STORE_KEY_APP_NAME                  @"STORE_KEY_APP_NAME"        // 应用名
#define STORE_KEY_APP_PRODUCT             @"STORE_KEY_APP_PRODUCT"        // 工程名
#define STORE_KEY_IS_APP_UPDATED            @"STORE_KEY_IS_APP_UPDATED"       // 标识位：判断当前客户端是否由旧版升级而来
#define STORE_KEY_IS_NEWER_SHOWED           @"STORE_KEY_IS_NEWER_SHOWED"      // 启动的时候，新手帮助是否显示过
#define STORE_KEY_SB_ACCOUNT                @"STORE_KEY_SB_ACCOUNT"                // 股吧用户信息
#define STORE_KEY_TABLE_REFRESH_IMAGE       @"STORE_KEY_TABLE_REFRESH_IMAGE"                //下拉刷新的图片


#pragma mark -
#pragma mark 一些默认的UI键名
#define STORE_COLOR_SBTABLE_BACKGROUND        @"STORE_COLOR_SBTABLE_BACKGROUND"   //sbtableview 背景色
#define STORE_COLOR_SBTABLE_SEPLINE        @"STORE_COLOR_SBTABLE_SEPLINE"   //sbtableview 分割线
#define STORE_COLOR_SBTABLE_TABLEHEADER        @"STORE_COLOR_SBTABLE_TABLEHEADER"   //sbtableview 表头
#define STORE_COLOR_SBTABLE_TABLEFOOTER       @"STORE_COLOR_SBTABLE_TABLEFOOTER"   //sbtableview 表尾

#define STORE_COLOR_SBCELL_BACKGROUND        @"STORE_COLOR_SBCELL_BACKGROUND"   //sbdatatablecell 背景色
#define STORE_COLOR_SBCELL_SELECTED        @"STORE_COLOR_SBCELL_SELECTED"   //sbdatatablecell 点击色
