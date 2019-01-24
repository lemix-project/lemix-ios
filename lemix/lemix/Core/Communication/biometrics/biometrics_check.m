//
//  biometrics_check.m
//  lemixExample
//
//  Created by 王炜光 on 2018/12/18.
//  Copyright © 2018 lemix. All rights reserved.
//

#import "biometrics_check.h"
#import "CommunicationInfo.h"
#import "BiometricsCheck.h"
@implementation biometrics_check
- (void)start:(CommunicationInfo *)info{
    [BiometricsCheck checkTouchIDForController:info.controller params:info.params];
}
@end
