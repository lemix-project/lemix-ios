//
//  Lemix.h
//  lemix
//
//  Created by 王炜光 on 2018/10/11.
//  Copyright © 2018 lemix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LemixEngine.h"
#import "LemixEngineConfig.h"
//NS_ASSUME_NONNULL_BEGIN

@interface Lemix : NSObject

/**
 Lemix启动器，在此完成Lemix的初始化相关工作。必须在使用Lemix任意功能前调用。建议放到App启动时调用。

 @param config 配置选项
 */
+ (void)startWork:(LemixEngineConfig *)config;
/**
 默认的引擎，无特殊情况，APP生命周期内使用默认引擎即可(默认engineName为defaultEngine)

 @return 返回引擎
 */
+ (LemixEngine *)defaultEngine;
/**
 创建一个新的引擎

 @param config 引擎配置
 @param engineName 引擎名称
 @return 返回引擎
 */
+ (LemixEngine *)createLemixEngine:(LemixEngineConfig *)config engineName:(NSString *)engineName;
@end

//NS_ASSUME_NONNULL_END
