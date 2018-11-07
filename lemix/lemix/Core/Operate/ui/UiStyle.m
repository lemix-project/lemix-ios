//
//  UiStyle.m
//  zwt-ios
//
//  Created by 王炜光 on 2018/8/23.
//  Copyright © 2018年 LemonIT.CN. All rights reserved.
//

#import "UiStyle.h"

@implementation UiStyle
+ (void)setNavigationBarHiddenForController:(BaseViewController *)viewController hidden:(BOOL)isHidden{
    [viewController onNavigationHiddenStatusChange:isHidden];
}
+ (void)setNavigationBackgroundColorForController:(BaseViewController *)viewController color:(UIColor *)color{
    [viewController onNavigationBarColorChange:color];
}
+ (void)setNavigationTitleForController:(BaseViewController *)viewController title:(NSString *)title{
    [viewController onNavigationTitleChange:title];
}
+ (void)setStatusBarHiddenForController:(BaseViewController *)viewController hidden:(BOOL)isHidden{
//    [viewController setStatusBarHidden:isHidden];
    if (@available(iOS 9.0,*)) {
        [[UIApplication sharedApplication] setStatusBarHidden:isHidden];
    }
}
+ (void)setNavigationItemColorForController:(BaseViewController *)viewController color:(UIColor *)color{
    [viewController onNavigationItemColorChange:color];
}
+ (void)setStatusBarStyle:(NSString *)style{
    if (@available(iOS 9.0,*)) {
       [[UIApplication sharedApplication] setStatusBarStyle:[@[@"dark",@"light"] indexOfObject:style] animated:YES];
    }
    
}
@end
