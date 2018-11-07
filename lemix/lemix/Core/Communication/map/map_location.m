//
//  map_location.m
//  zwt-ios
//
//  Created by 王炜光 on 2018/8/28.
//  Copyright © 2018年 LemonIT.CN. All rights reserved.
//

#import "map_location.h"
#import "CommunicationInfo.h"
#import "MapLocation.h"
@implementation map_location

- (void)getPosition:(CommunicationInfo *)info{
    [MapLocation getPositonForController:info.controller success:info.params[@"success"] failed:info.params[@"failed"]];
}

- (void)onInstantPosition:(CommunicationInfo *)info{
    [MapLocation startUpdatingLocation:info.controller distanceFilter:[info.params[@"success"] integerValue] success:info.params[@"success"] failed:info.params[@"failed"]];
}

- (void)offInstantPosition:(CommunicationInfo *)info{
    [MapLocation stopUpdatingLocation:info.controller];
}


@end
