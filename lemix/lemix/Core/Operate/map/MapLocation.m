//
//  MapLocation.m
//  zwt-ios
//
//  Created by 王炜光 on 2018/8/28.
//  Copyright © 2018年 LemonIT.CN. All rights reserved.
//

#import "MapLocation.h"
#import "LemixWebViewController.h"
#import "BaseNavigationViewController.h"
@implementation MapLocation
+(void)getPositonForController:(BaseViewController *)viewController success:(NSString *)success failed:(NSString *)failed{
    BaseNavigationViewController *baseNaVC = (BaseNavigationViewController*)viewController.navigationController;
    if (!baseNaVC.lemixEngine.config.mapLocationOBJ) {
        NSLog(@"未找到定位执行方法是咧");
        return;
    }
    
    [baseNaVC.lemixEngine.config.mapLocationOBJ fixPostion:^(LocationInfo * locationInfo) {
                NSLog(@"%@",locationInfo);
                NSString *callJSString;
                if (!locationInfo.locError) {
                    callJSString = [NSString stringWithFormat:@"__load_callback('%@','%@','%@','%@')",success,locationInfo.lon,locationInfo.lat,locationInfo.formattedAddress];
                }else{
                    callJSString = [NSString stringWithFormat:@"__load_callback('%@','%@')",failed,locationInfo.locError];
                }
        
                [((LemixWebViewController *)viewController).webView evaluateJavaScript:callJSString completionHandler:^(id resultObject, NSError * _Nullable error) {
                    if (!error){
                        NSLog(@"OC调 JS成功");
                    }else{
                        NSLog(@"OC调 JS 失败");
                    }
                }];
    }];
}

+(void)startUpdatingLocation:(BaseViewController *)viewController distanceFilter:(NSInteger)distanceFilter success:(NSString *)success failed:(NSString *)failed{
    __block LemixWebViewController *lemixViewController = ((LemixWebViewController *)viewController);
    
    BaseNavigationViewController *baseNaVC = (BaseNavigationViewController*)viewController.navigationController;
    if (!baseNaVC.lemixEngine.config.mapLocationOBJ) {
        return;
    }
    [baseNaVC.lemixEngine.config.mapLocationOBJ startUpdatingLocationDistanceFilter:distanceFilter];
    baseNaVC.lemixEngine.config.mapLocationOBJ.updateLocation = ^(LocationInfo * locationInfo) {
        
        NSString *callJSString;
        if (!locationInfo.locError) {
            callJSString = [NSString stringWithFormat:@"__load_callback('%@','%@','%@','%@')",success,locationInfo.lon,locationInfo.lat,locationInfo.formattedAddress];
        }else{
            callJSString = [NSString stringWithFormat:@"__load_callback('%@','%@')",failed,locationInfo.locError];
        }
        
        [lemixViewController.webView evaluateJavaScript:callJSString completionHandler:^(id resultObject, NSError * _Nullable error) {
            if (!error){
                NSLog(@"OC调 JS成功");
            }else{
                NSLog(@"OC调 JS 失败");
            }
        }];
    };
}

+(void)stopUpdatingLocation:(BaseViewController *)viewController{

    BaseNavigationViewController *baseNaVC = (BaseNavigationViewController*)viewController.navigationController;
    if (!baseNaVC.lemixEngine.config.mapLocationOBJ) {
        return;
    }
    [baseNaVC.lemixEngine.config.mapLocationOBJ stopUpdatingLocation];
}
@end
