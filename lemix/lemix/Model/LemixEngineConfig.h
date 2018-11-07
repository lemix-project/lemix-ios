//
//  LemixEngineConfig.h
//  lemix
//
//  Created by 王炜光 on 2018/10/11.
//  Copyright © 2018 lemix. All rights reserved.
//

#import "WaitingPageStandard.h"
#import "MapLocationStandard.h"
#import <UIKit/UIKit.h>
//NS_ASSUME_NONNULL_BEGIN

@interface LemixEngineConfig : NSObject
- (instancetype)initWithWorkspacePath:(NSString *)workspacePath tempPath:(NSString *)tempPath;
/**
 存放mixModulezip的文件夹路径
 */
@property NSString *workspacePath;
/**
 解压mixModulezip包的文件夹路径
 */
@property NSString *tempPath;
/**
 等待页面
 */
@property UIViewController<WaitingPageStandard> *waitingPage;
/**
 实现定位方法
 */
@property id<MapLocationStandard>mapLocationOBJ;
@end

//NS_ASSUME_NONNULL_END
