//
//  LemixEngine.h
//  lemix
//
//  Created by 王炜光 on 2018/10/11.
//  Copyright © 2018 lemix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LemixEngineConfig.h"
#import "MixModuleInfo.h"
#import "MixModuleLifeCycle.h"
#import "StartUpMixModuleParameter.h"
#import "MixModuleInstance.h"
#import "NativePageInfo.h"
//NS_ASSUME_NONNULL_BEGIN

@interface LemixEngine : NSObject

/**
 通过配置对象进行初始化
 
 @param config LemixEngine引擎配置对象
 @param engineName 引擎名称
 @return LemixMixEngine实例
 */
- (instancetype)initWithConfig:(LemixEngineConfig *)config engineName:(NSString *)engineName;
/**
 注册远程MixModule，当MixModule的zip数据包存储在基于HTTP的服务器上需要动态下载时使用。
 注册远程MixModule后不会立即将MixModule数据包下载到本地，而是在真正使用的时候才动态下载。
 MixModule数据包被下载完毕时需要将其以moduleKey+packageTime为标识进行缓存，再次需要使用该包时，若缓存中存在，则直接使用缓存中的数据包

 @param moduleInfoArr 远程数据数组
 */
- (void)registerRemoteMixModule:(NSArray <MixModuleInfo *>*)moduleInfoArr;
/**
 注册本地MixModule，本地MixModule不存在缓存机制。

 @param moduleInfoArr 本地数据数组
 */
- (void)registerLocalMixModule:(NSArray <MixModuleInfo *>*)moduleInfoArr;
/**
 注册原生页面，将原生页面注册到LemixEngine时，需要指定这个原生页面的nativePageKey，之后无论是原生还是JS，均可以通过nativePageKey找到这个原生页面，并打开它。

 @param moduleInfoArr 原生界面key数组
 */
- (void)registerNativePage:(NSArray <NativePageInfo *>*)moduleInfoArr;
/**
 启动原生页面，同时允许向该页面中传入JSON数据作为执行参数。
 该原生界面实例会被入栈到当前调用者所在UI栈中。

 @param moduleParameter 原生界面Key
 */
- (void)startUpNativePage:(StartUpMixModuleParameter *)moduleParameter;
/**
 注销已经注册的MixModule，通过moduleKey+packageTime来定位要注销的MixModule包

 @param moduleKey moduleKey
 @param packageTime packageTime
 */
- (void)logoutMixModule:(NSString *)moduleKey packageTime:(NSString *)packageTime;
/**
 注销已经注册的NativePage，通过nativePageKey来定位要注销的NativePage

 @param nativePageKey nativePageKey
 */
- (void)logoutNativePage:(NSString *)nativePageKey;
/**
 查询当前LemixEngine中已注册的所有MixModule信息（包括本地和远程）

 @return 所有MixModule信息数组
 */
- (NSArray <MixModuleInfo *>*)getAllMixModuleInfo;
/**
 查询当前LemixEngine中已注册的所有NativePage信息

 @return 所有NativePage信息数组
 */
- (NSArray <NativePageInfo *>*)getAllNativePageInfo;
/**
 创建工作区间路径文件夹
 */
- (void)createWorkSpaceAndTempPath;
/**
 启动MixModule，如果不传默认启动页面，那么会引导至MixModule中的entrace页面。启动时允许向页面中传入JSON数据作为执行参数。
 开启的MixModule中的界面会被入栈到新创建的UI栈中。

 @param moduleParameter 启动参数
 @param moduleLifeCycle 生命周期
 */
- (void)startUpMixModule:(StartUpMixModuleParameter *)moduleParameter mixModuleLifeCycle:(MixModuleLifeCycle*)moduleLifeCycle;
/**
 引擎配置信息
 */
@property LemixEngineConfig *config;
/**
 引擎名称
 */
@property NSString *engineName;
/**
 MixModule字典
 */
@property NSMutableDictionary <NSString *, MixModuleInfo *>*mixModulePool;
/**
 原生界面字典
 */
@property NSMutableDictionary <NSString *, NativePageInfo *>*nativePagePool;
/**
 mMixModule实例字典
 */
//@property NSMutableDictionary <NSString *, MixModuleInstance *>*moduleInstanceDic;
@property NSMutableArray <MixModuleInstance *>*instanceList;
@end

//NS_ASSUME_NONNULL_END
