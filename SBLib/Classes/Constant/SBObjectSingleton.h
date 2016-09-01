/*
 #####################################################################
 # File    : GTMObjectSingleton.h
 # Project : 
 # Created : 2013-03-30
 # DevTeam : 
 # Author  : Hokuang
 # Notes   : 单例实现（基于ARC）
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


//是arc
/** 单例模式：声明 */
#define SB_ARC_SINGLETON_DEFINE(_class_name_)  \
+ (_class_name_ *)shared##_class_name_;          \

/** 单例模式：实现 */
#define SB_ARC_SINGLETON_IMPLEMENT(_class_name) SB_ARC_SINGLETON_BOILERPLATE(_class_name, shared##_class_name)

#define SB_ARC_SINGLETON_BOILERPLATE(_object_name_, _shared_obj_name_) \
static _object_name_ *z##_shared_obj_name_ = nil;  \
+ (_object_name_ *)_shared_obj_name_ {             \
static dispatch_once_t onceToken;              \
dispatch_once(&onceToken, ^{                   \
z##_shared_obj_name_ = [[self alloc] init];\
});                                            \
return z##_shared_obj_name_;                   \
}



//非arc
/** 单例模式：声明 */
#define SB_NOARC_SINGLETON_DEFINE(_class_name_) \
+ (_class_name_ *)shared##_class_name_;          \
+ (void)destroy##_class_name_;

/** 单例模式：实现 */
#define SB_NOARC_SINGLETON_IMPLEMENT(_class_name) SB_NOARC_SINGLETON_BOILERPLATE(_class_name, shared##_class_name)

#define SB_NOARC_SINGLETON_BOILERPLATE(_object_name_, _shared_obj_name_) \
static _object_name_ *z##_shared_obj_name_ = nil;  \
+ (_object_name_ *)_shared_obj_name_ {             \
    @synchronized(self) {                            \
        if (z##_shared_obj_name_ == nil) {             \
            /** Note that 'self' may not be the same as _object_name_ */                               \
            /** first assignment done in allocWithZone but we must reassign in case init fails */      \
            z##_shared_obj_name_ = [[self alloc] init];                                               \
        }                                              \
    }                                                \
    return z##_shared_obj_name_;                     \
}                                                  \
+ (id)allocWithZone:(NSZone *)zone {               \
@synchronized(self) {                            \
    if (z##_shared_obj_name_ == nil) {             \
        z##_shared_obj_name_ = [super allocWithZone:zone]; \
        return z##_shared_obj_name_;                 \
    }                                              \
}                                                \
\
return nil;                                      \
}                                                  \
- (id)retain {                                     \
    return self;                                     \
}                                                  \
- (NSUInteger)retainCount {                        \
    return NSUIntegerMax;                            \
}                                                  \
- (oneway void)release {                           \
}                                                  \
- (id)autorelease {                                \
    return self;                                     \
}                                                  \
- (id)copyWithZone:(NSZone *)zone {                \
    return self;                                     \
}                                                  \
+ (void)destroy##_object_name_ {                   \
    _object_name_ *tmp_var = z##_shared_obj_name_;   \
    z##_shared_obj_name_ = nil;                      \
    if(nil != tmp_var){                              \
    [tmp_var dealloc];                             \
    }                                                \
}                                                  \




