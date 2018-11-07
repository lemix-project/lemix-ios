//
//  LocationInfo.h
//  lemix
//
//  Created by 王炜光 on 2018/10/17.
//  Copyright © 2018 lemix. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationInfo : NSObject
/**
 纬度
 */
@property NSString *lat;
/**
 经度
 */
@property NSString *lon;
/**
 详细地址
 */
@property NSString *formattedAddress;
/**
 地址错误信息
 */
@property NSString *locError;
@end

NS_ASSUME_NONNULL_END
