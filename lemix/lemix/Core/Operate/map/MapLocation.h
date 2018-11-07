//
//  MapLocation.h
//  zwt-ios
//
//  Created by 王炜光 on 2018/8/28.
//  Copyright © 2018年 LemonIT.CN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
@interface MapLocation : NSObject
+(void)getPositonForController:(BaseViewController *)viewController success:(NSString *)success failed:(NSString *)failed;
+(void)startUpdatingLocation:(BaseViewController *)viewController distanceFilter:(NSInteger)distanceFilter success:(NSString *)success failed:(NSString *)failed;
+(void)stopUpdatingLocation:(BaseViewController *)viewController;
@end
