//
//  MixModuleInstance.h
//  lemix
//
//  Created by 王炜光 on 2018/10/12.
//  Copyright © 2018 lemix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixModuleInfo.h"
#import "MixModuleLifeCycle.h"
//NS_ASSUME_NONNULL_BEGIN

@interface MixModuleInstance : NSObject
/**
 当前navigationController
 */
@property UINavigationController *uiStackObj;
/**
 当前mixModule的生命周期
 */
@property MixModuleLifeCycle *mixModuleLifeCycle;
/**
 当前插件的信息
 */
@property MixModuleInfo *mixModuleInfo;
@end

//NS_ASSUME_NONNULL_END
