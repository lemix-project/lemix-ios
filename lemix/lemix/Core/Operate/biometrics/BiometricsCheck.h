//
//  BiometricsCheck.h
//  lemixExample
//
//  Created by 王炜光 on 2018/12/18.
//  Copyright © 2018 lemix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface BiometricsCheck : NSObject
+ (void)checkTouchIDForController:(BaseViewController *)viewController params:(NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
