//
//  AimViewControllerInfo.h
//  lemix
//
//  Created by 王炜光 on 2018/10/16.
//  Copyright © 2018 lemix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
typedef void(^webBlock)(WKWebView*);
//NS_ASSUME_NONNULL_BEGIN

@interface AimViewControllerInfo : NSObject
/**
 条状类型
 */
@property NSString *type;
/**
 目标路径
 */
@property NSString *aim;
/**
 web配置选项清单
 */
@property NSDictionary *webProgram;
/**
 需要传递的json
 */
@property NSString *json;
@property(nonatomic, copy)webBlock webOnShow;
@end

//NS_ASSUME_NONNULL_END
