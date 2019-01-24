//
//  custom_storage.m
//  lemixExample
//
//  Created by 王炜光 on 2018/12/14.
//  Copyright © 2018 lemix. All rights reserved.
//

#import "data_storage.h"
#import "CommunicationInfo.h"
#import "DataStorage.h"
@implementation data_storage
- (void)set:(CommunicationInfo *)info{
    [DataStorage setDataForController:info.controller params:info.params];
}
- (NSString *)get:(CommunicationInfo *)info{
    return [DataStorage getDataForController:info.controller params:info.params];
}
- (void)remove:(CommunicationInfo *)info{
    [DataStorage removeDataForController:info.controller params:info.params];
}
- (void)clear:(CommunicationInfo *)info{
    [DataStorage removeAllDataForController:info.controller params:info.params];
}
@end
