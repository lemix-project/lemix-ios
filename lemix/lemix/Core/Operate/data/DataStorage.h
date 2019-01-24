//
//  CustomStorage.h
//  lemixExample
//
//  Created by 王炜光 on 2018/12/14.
//  Copyright © 2018 lemix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface DataStorage : NSObject
+ (void)setDataForController:(BaseViewController *)viewController params:(NSDictionary *)params;
+ (NSString *)getDataForController:(BaseViewController *)viewController params:(NSDictionary *)params;
+ (void)removeDataForController:(BaseViewController *)viewController params:(NSDictionary *)params;
+ (void)removeAllDataForController:(BaseViewController *)viewController params:(NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
