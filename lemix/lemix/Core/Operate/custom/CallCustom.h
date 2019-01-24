//
//  CallCustom.h
//  lemixExample
//
//  Created by 王炜光 on 2018/11/22.
//  Copyright © 2018 lemix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface CallCustom : NSObject
+(void)callCustomForController:(BaseViewController *)viewController params:(NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
