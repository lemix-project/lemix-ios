//
//  LemixEngine.m
//  lemix
//
//  Created by 王炜光 on 2018/10/11.
//  Copyright © 2018 lemix. All rights reserved.
//

#import "LemixEngine.h"
#import <UIKit/UIKit.h>
#import "BaseNavigationViewController.h"
#import "HttpUtil.h"
#import "UiNavigation.h"
#import "AimViewControllerInfo.h"
@interface LemixEngine()
@property HttpUtil *httpManager;
@property NSDictionary *webProgramDic;
@property NSString *unZipPath;
@end
@implementation LemixEngine


/**
 通过配置对象进行初始化
 
 @param config LemixEngine引擎配置对象
 @param engineName 引擎名称
 @return LemixMixEngine实例
 */
- (instancetype)initWithConfig:(LemixEngineConfig *)config engineName:(NSString *)engineName{
    if (self = [super init]) {
        _config = config;
        // 创建文件夹方法(拼接engineName)
        _engineName = engineName;
        _httpManager = [[HttpUtil alloc] init];
        [self createWorkSpaceAndTempPath];
    }
    return self;
}



/**
 创建工作区间与临时区间目录
 */
- (void)createWorkSpaceAndTempPath{
    [_httpManager createFile:[NSString stringWithFormat:@"%@/%@/MixModules",_config.workspacePath,_engineName]];
    [_httpManager createFile:[NSString stringWithFormat:@"%@/%@/MixModules",_config.tempPath,_engineName]];
}

/**
 注册远程MixModule，当MixModule的zip数据包存储在基于HTTP的服务器上需要动态下载时使用。
 注册远程MixModule后不会立即将MixModule数据包下载到本地，而是在真正使用的时候才动态下载。
 MixModule数据包被下载完毕时需要将其以moduleKey+packageTime为标识进行缓存，再次需要使用该包时，若缓存中存在，则直接使用缓存中的数据包
 
 @param moduleInfoArr 远程数据数组
 */
- (void)registerRemoteMixModule:(NSArray <MixModuleInfo *>*)moduleInfoArr{
    if (!_mixModulePool) {
        _mixModulePool = [[NSMutableDictionary alloc] init];
    }
    for (MixModuleInfo *moduleInfo in moduleInfoArr) {
        [_mixModulePool setObject:moduleInfo forKey:[NSString stringWithFormat:@"%@-%@",moduleInfo.mixModuleIdentifier,moduleInfo.packageTime]];
        
        NSString *mixModelLocalPath = [NSString stringWithFormat:@"%@/%@/MixModules/%@-%@.zip",_config.workspacePath,_engineName,moduleInfo.mixModuleIdentifier,moduleInfo.packageTime];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir = NO;
        // fileExistsAtPath 判断一个文件或目录是否有效
        BOOL existed = [fileManager fileExistsAtPath:mixModelLocalPath isDirectory:&isDir];
        if (!existed) { //不存在
            [self.httpManager deleteMixModuleCache:[NSString stringWithFormat:@"%@/%@/MixModules",_config.workspacePath,_engineName]  mixModuleIdentifier:moduleInfo.mixModuleIdentifier];
        }
    }
}
/**
 注册本地MixModule，本地MixModule不存在缓存机制。
 
 @param moduleInfoArr 本地数据数组
 */
- (void)registerLocalMixModule:(NSArray <MixModuleInfo *>*)moduleInfoArr{
    if (!_mixModulePool) {
        _mixModulePool = [[NSMutableDictionary alloc] init];
    }
    for (MixModuleInfo *moduleInfo in moduleInfoArr) {
        [_mixModulePool setObject:moduleInfo forKey:[NSString stringWithFormat:@"%@-%@",moduleInfo.mixModuleIdentifier,moduleInfo.packageTime]];
    }
}
/**
 注册原生页面，将原生页面注册到LemixEngine时，需要指定这个原生页面的nativePageKey，之后无论是原生还是JS，均可以通过nativePageKey找到这个原生页面，并打开它。
 
 @param moduleInfoArr 原生界面key数组
 */
- (void)registerNativePage:(NSArray <NativePageInfo *>*)moduleInfoArr{
    if (!_nativePagePool) {
        _nativePagePool = [[NSMutableDictionary alloc] init];
    }
    for (NativePageInfo *moduleInfo in moduleInfoArr) {
        [_nativePagePool setObject:moduleInfo forKey:[NSString stringWithFormat:@"%@",moduleInfo.nativePageKey]];
    }
}
- (void)startUpMixModule:(StartUpMixModuleParameter *)moduleParameter mixModuleLifeCycle:(MixModuleLifeCycle*)moduleLifeCycle{

    
    if (!_instanceList) {
        _instanceList = [NSMutableArray new];
    }else{
        for (NSInteger i = 0;i<_instanceList.count;i++) {
            MixModuleInstance *instance = _instanceList[i];
            if ([instance.mixModuleInfo.mixModuleIdentifier isEqualToString:moduleParameter.moduleKey]&&[instance.mixModuleInfo.packageTime isEqualToString:moduleParameter.packageTime]) {
                [_instanceList exchangeObjectAtIndex:i withObjectAtIndex:_instanceList.count-1];
                BaseNavigationViewController *lemixNavi = [[BaseNavigationViewController alloc] initWithRootViewController:self.config.waitingPage];
                lemixNavi.lemixEngine = self;
                lemixNavi.instanceKey = [NSString stringWithFormat:@"%@-%@",moduleParameter.moduleKey,moduleParameter.packageTime];
                
                [self.config.waitingPage onWaiting:instance.mixModuleInfo];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:lemixNavi animated:YES completion:^{
                    
                    [self.httpManager StartupMixModule:self.config mixModuleInfo:instance.mixModuleInfo engineName:self.engineName startUpMixModuleParameter:moduleParameter];
                    moduleLifeCycle.onShow();
                }];
                return;
                
            }
        }
    }
    MixModuleInfo *moduleInfo = [self.mixModulePool objectForKey:[NSString stringWithFormat:@"%@-%@",moduleParameter.moduleKey,moduleParameter.packageTime]];
    if (moduleInfo) {
        BaseNavigationViewController *lemixNavi = [[BaseNavigationViewController alloc] initWithRootViewController:self.config.waitingPage];
        lemixNavi.lemixEngine = self;
        lemixNavi.instanceKey = [NSString stringWithFormat:@"%@-%@",moduleParameter.moduleKey,moduleParameter.packageTime];
        [self.config.waitingPage onWaiting:moduleInfo];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:lemixNavi animated:YES completion:^{
            
            [self.httpManager StartupMixModule:self.config mixModuleInfo:moduleInfo engineName:self.engineName startUpMixModuleParameter:moduleParameter];
            moduleLifeCycle.onShow();
        }];
        MixModuleInstance *moduleInstance = [[MixModuleInstance alloc] init];
        moduleInstance.uiStackObj = lemixNavi;
        moduleInstance.mixModuleInfo = moduleInfo;
        moduleInstance.mixModuleLifeCycle = moduleLifeCycle;
//        [_moduleInstanceDic setObject:moduleInstance forKey:[NSString stringWithFormat:@"%@-%@",moduleParameter.moduleKey,moduleParameter.packageTime]];
        [_instanceList addObject:moduleInstance];
    }else{
        NSLog(@"未找到注册Module!");
        return;
    }
    
}
/**
 启动原生页面，同时允许向该页面中传入JSON数据作为执行参数。
 该原生界面实例会被入栈到当前调用者所在UI栈中。
 
 @param moduleParameter 原生界面Key
 */
- (void)startUpNativePage:(StartUpMixModuleParameter *)moduleParameter{
    
    
    NativePageInfo *pageInfo = [_nativePagePool objectForKey:moduleParameter.nativePageKey];
    if (!pageInfo.nativePage) {
        NSLog(@"NOT FIND CLASS!");
        return;
    }
    UIViewController *nativePage = [pageInfo.nativePage new];
    [nativePage setValue:moduleParameter.json forKey:@"json"];
    BaseNavigationViewController *lemixNavi = [[BaseNavigationViewController alloc] initWithRootViewController:nativePage];
    lemixNavi.lemixEngine = self;
    lemixNavi.instanceKey = [NSString stringWithFormat:@"%@",moduleParameter.nativePageKey];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:lemixNavi animated:YES completion:^{
        
    }];
}
/**
 注销已经注册的MixModule，通过moduleKey+packageTime来定位要注销的MixModule包
 
 @param moduleKey moduleKey
 @param packageTime packageTime
 */
- (void)logoutMixModule:(NSString *)moduleKey packageTime:(NSString *)packageTime{
    [_mixModulePool removeObjectForKey:[NSString stringWithFormat:@"%@%@",moduleKey,packageTime]];
}
/**
 注销已经注册的NativePage，通过nativePageKey来定位要注销的NativePage
 
 @param nativePageKey nativePageKey
 */
- (void)logoutNativePage:(NSString *)nativePageKey{
    [_nativePagePool removeObjectForKey:nativePageKey];
}
/**
 查询当前LemixEngine中已注册的所有MixModule信息（包括本地和远程）
 
 @return 所有MixModule信息数组
 */
- (NSArray <MixModuleInfo *>*)getAllMixModuleInfo{
    NSMutableArray *moduleInfoArr = [NSMutableArray new];
    for (NSString *key in _mixModulePool) {
        [moduleInfoArr addObject:_mixModulePool[key]];
    }
    return moduleInfoArr;
}
/**
 查询当前LemixEngine中已注册的所有NativePage信息
 
 @return 所有NativePage信息数组
 */
- (NSArray <NativePageInfo *>*)getAllNativePageInfo{
    NSMutableArray *moduleInfoArr = [NSMutableArray new];
    for (NSString *key in _nativePagePool) {
        [moduleInfoArr addObject:_nativePagePool[key]];
    }
    return moduleInfoArr;
}

@end
