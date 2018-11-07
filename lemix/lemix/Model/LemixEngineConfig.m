//
//  LemixEngineConfig.m
//  lemix
//
//  Created by 王炜光 on 2018/10/11.
//  Copyright © 2018 lemix. All rights reserved.
//

#import "LemixEngineConfig.h"

@implementation LemixEngineConfig

- (instancetype)initWithWorkspacePath:(NSString *)workspacePath tempPath:(NSString *)tempPath{
    if (self = [super init]) {
        _workspacePath = workspacePath;
        _tempPath = tempPath;
    };
    return self;
}

@end
