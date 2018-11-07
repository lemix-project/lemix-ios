//
//  MixModelLifeCycle.h
//  lemix
//
//  Created by 王炜光 on 2018/10/11.
//  Copyright © 2018 lemix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LemixEngineConfig.h"
#import "WaitingPageStandard.h"
//NS_ASSUME_NONNULL_BEGIN
typedef void(^myBlock)(void);
@interface MixModuleLifeCycle : NSObject
- (instancetype)initWithEngineConfig:(LemixEngineConfig *)config;

@property(nonatomic, copy)myBlock onShow;
@property(nonatomic, copy)myBlock onHide;
@end

//NS_ASSUME_NONNULL_END
