//
//  MapLocaltionStandard.h
//  lemixExample
//
//  Created by 王炜光 on 2018/10/29.
//  Copyright © 2018 lemix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationInfo.h"
//NS_ASSUME_NONNULL_BEGIN
typedef void(^UpdateLocation)(LocationInfo *);
@protocol MapLocationStandard <NSObject>
/**
 定位
 
 @param responce    返回的经纬度
 */
- (void)fixPostion:(void (^)(LocationInfo *responce))responce;
/**
 开始持续定位
 
 @param distanceFilter 返回的经纬度
 */
- (void)startUpdatingLocationDistanceFilter:(NSInteger)distanceFilter;
/**
 停止持续定位
 */
- (void)stopUpdatingLocation;

@property UpdateLocation updateLocation;
@end

//NS_ASSUME_NONNULL_END
