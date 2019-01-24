//
//  CommunicationInfo.h
//  lemix
//
//  Created by 王炜光 on 2018/10/16.
//  Copyright © 2018 lemix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import "LemixWebViewController.h"
//NS_ASSUME_NONNULL_BEGIN

typedef void(^completionHandler)(NSString *);
@interface CommunicationInfo : NSObject

/**
 当前操作页面
 */
@property LemixWebViewController *controller;

/**
 设置参数
 */
@property NSDictionary *params;

/**
 同步类型
 */
@property NSString *sync;

/**
 跳转类型
 */
@property NSString *type;

/**
 回调函数
 */
@property completionHandler completionHandler;

/**
 初始化方法

 @param controller 当前界面VC
 @param data json传递参数
 @param completionHandler 回调函数
 @return communicationInfo实例
 */
- (instancetype) initWithCurrentController:(LemixWebViewController *)controller
                                      data:(NSDictionary *)data
                         completionHandler:(completionHandler)completionHandler;
@end

//NS_ASSUME_NONNULL_END
