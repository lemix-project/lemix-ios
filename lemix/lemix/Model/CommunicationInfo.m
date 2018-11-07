//
//  CommunicationInfo.m
//  lemix
//
//  Created by 王炜光 on 2018/10/16.
//  Copyright © 2018 lemix. All rights reserved.
//

#import "CommunicationInfo.h"

@implementation CommunicationInfo
- (instancetype) initWithCurrentController:(LemixWebViewController *)controller
                                      data:(NSDictionary *)data
                         completionHandler:(completionHandler)completionHandler{
    if (self = [super init]) {
        self.controller = controller;
        self.params = data[@"params"];
        self.type = data[@"type"];
        self.completionHandler = completionHandler;
        self.sync = data[@"sync"];
    }
    
    return self;
}
@end
