//
//  Lemix.m
//  lemix
//
//  Created by 王炜光 on 2018/10/11.
//  Copyright © 2018 lemix. All rights reserved.
//

#import "Lemix.h"
#define DEFAULT_ENGINE_NAME @"defaultEngine"
@interface Lemix ()
//@property LemixEngine *lemixEngine;
@end
static LemixEngine *_defaultEngine;
static LemixEngineConfig *_defaultConfig;
@implementation Lemix
+ (void)startWork:(LemixEngineConfig *)config{
    _defaultConfig = config;
}

+ (LemixEngine *)defaultEngine{
    if (_defaultEngine) {
        return _defaultEngine;
    }else{
        return [self createLemixEngine:_defaultConfig engineName:DEFAULT_ENGINE_NAME];
    }
}

+ (LemixEngine *)createLemixEngine:(LemixEngineConfig *)config engineName:(NSString *)engineName{
   _defaultEngine = [[LemixEngine alloc] initWithConfig:config engineName:engineName];
    return _defaultEngine;
}

@end
