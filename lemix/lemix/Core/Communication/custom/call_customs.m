//
//  call_custom.m
//  lemixExample
//
//  Created by 王炜光 on 2018/11/22.
//  Copyright © 2018 lemix. All rights reserved.
//

#import "call_customs.h"
#import "CommunicationInfo.h"
#import "CallCustom.h"
@implementation call_customs
- (void)callCustom:(CommunicationInfo *)info{
    [CallCustom callCustomForController:info.controller params:info.params];
}
@end
