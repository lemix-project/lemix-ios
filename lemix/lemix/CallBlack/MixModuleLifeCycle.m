//
//  MixModelLifeCycle.m
//  lemix
//
//  Created by 王炜光 on 2018/10/11.
//  Copyright © 2018 lemix. All rights reserved.
//

#import "MixModuleLifeCycle.h"
#import <UIKit/UIKit.h>

@interface MixModuleLifeCycle()
@property LemixEngineConfig *config;

@end
@implementation MixModuleLifeCycle

- (instancetype)initWithEngineConfig:(LemixEngineConfig *)config{
    if (self = [super init]) {
        _config = config;
    }
    return self;
}
- (void)jieshou:(NSNotification *)notification{
    NSLog(@"%@",notification.userInfo);
}



@end
