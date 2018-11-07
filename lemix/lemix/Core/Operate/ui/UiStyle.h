//
//  UiStyle.h
//  zwt-ios
//
//  Created by 王炜光 on 2018/8/23.
//  Copyright © 2018年 LemonIT.CN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
@interface UiStyle : NSObject

+ (void)setNavigationBarHiddenForController:(BaseViewController *)viewController hidden:(BOOL)isHidden;
+ (void)setNavigationBackgroundColorForController:(BaseViewController *)viewController color:(UIColor *)color;
+ (void)setNavigationTitleForController:(BaseViewController *)viewController title:(NSString *)title;
+ (void)setStatusBarHiddenForController:(BaseViewController *)viewController hidden:(BOOL)isHidden;
+ (void)setNavigationItemColorForController:(BaseViewController *)viewController color:(UIColor *)color;
+ (void)setStatusBarStyle:(NSString *)style;
@end
