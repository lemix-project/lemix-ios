//
//  webCallCustom.m
//  lemixExample
//
//  Created by 王炜光 on 2018/11/22.
//  Copyright © 2018 lemix. All rights reserved.
//

#import "webCallCustom.h"

@implementation webCallCustom
+ (void)getCode:(NSDictionary *)data responce:(void (^)(id callback))responce{
    responce?responce(@{@"1":@"2"}):nil;
}
@end
