//
//  CallCustomFuncStandard.h
//  lemixExample
//
//  Created by 王炜光 on 2018/11/22.
//  Copyright © 2018 lemix. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CallCustomFuncStandard <NSObject>

- (void)callCustomFuncForData:(NSDictionary *)data success:(void (^)(id responce))success failed:(void (^)(id responce))failed;

@end

NS_ASSUME_NONNULL_END
