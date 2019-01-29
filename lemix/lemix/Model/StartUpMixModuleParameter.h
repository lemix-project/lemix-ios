//
//  StartUpMixModuleParameter.h
//  lemix
//
//  Created by 王炜光 on 2018/10/12.
//  Copyright © 2018 lemix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
typedef void(^webBlock)(WKWebView*);
//NS_ASSUME_NONNULL_BEGIN

@interface StartUpMixModuleParameter : NSObject

/**
 mixModuile发布时间
 */
@property NSString *packageTime;
/**
 起始页默认为zip包中设置
 */
@property NSString *startPage;
/**
 传递json数据
 */
@property NSString *json;
@property NSString *moduleKey;
@property NSString *nativePageKey;

@property(nonatomic, copy)webBlock webOnShow;

@end

//NS_ASSUME_NONNULL_END
