//
//  webCallCustom.h
//  lemixExample
//
//  Created by 王炜光 on 2018/11/22.
//  Copyright © 2018 lemix. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface webCallCustom : NSObject

+ (void)getCode:(NSDictionary *)data responce:(void (^)(id callback))responce;

@end

NS_ASSUME_NONNULL_END
