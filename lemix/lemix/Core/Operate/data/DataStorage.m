//
//  CustomStorage.m
//  lemixExample
//
//  Created by 王炜光 on 2018/12/14.
//  Copyright © 2018 lemix. All rights reserved.
//

#import "DataStorage.h"
#import "LemixWebViewController.h"
#import "BaseNavigationViewController.h"
@implementation DataStorage
//callCustomForController:(BaseViewController *)viewController params:(NSDictionary *)params
+ (void)setDataForController:(BaseViewController *)viewController params:(NSDictionary *)params{
    BaseNavigationViewController *baseNaVC = (BaseNavigationViewController*)viewController.navigationController;
    NSString *instanceKey = [baseNaVC.instanceKey componentsSeparatedByString:@"-"][0];
    NSDictionary *tempDic = [[NSUserDefaults standardUserDefaults] objectForKey:instanceKey];
    NSMutableDictionary *mulDic = [NSMutableDictionary dictionaryWithDictionary:tempDic];
    [mulDic setObject:params[@"data"] forKey:params[@"key"]];
    [[NSUserDefaults standardUserDefaults] setObject:mulDic forKey:instanceKey];
}
+ (NSString *)getDataForController:(BaseViewController *)viewController params:(NSDictionary *)params{
    BaseNavigationViewController *baseNaVC = (BaseNavigationViewController*)viewController.navigationController;
    NSString *instanceKey = [baseNaVC.instanceKey componentsSeparatedByString:@"-"][0];
    //    NSString *callJSString = [NSString stringWithFormat:@"__load_callback('%@','%@')",params[@"success"],[[[NSUserDefaults standardUserDefaults] objectForKey:instanceKey] objectForKey:params[@"key"]]];
    //
    ////    [((LemixWebViewController *)viewController).webView evaluateJavaScript:callJSString completionHandler:^(id resultObject, NSError * _Nullable error) {
    ////        if (!error){
    ////            NSLog(@"OC调 JS成功");
    ////        }else{
    ////            NSLog(@"OC调 JS 失败");
    ////        }
    ////    }];
    return [[[NSUserDefaults standardUserDefaults] objectForKey:instanceKey] objectForKey:params[@"key"]];
}
+ (void)removeDataForController:(BaseViewController *)viewController params:(NSDictionary *)params{
    BaseNavigationViewController *baseNaVC = (BaseNavigationViewController*)viewController.navigationController;
    NSString *instanceKey = [baseNaVC.instanceKey componentsSeparatedByString:@"-"][0];
    NSDictionary *tempDic = [[NSUserDefaults standardUserDefaults] objectForKey:instanceKey];
    NSMutableDictionary *mulDic = [NSMutableDictionary dictionaryWithDictionary:tempDic];
    [mulDic removeObjectForKey:params[@"key"]];
    [[NSUserDefaults standardUserDefaults] setObject:mulDic forKey:instanceKey];
}
+ (void)removeAllDataForController:(BaseViewController *)viewController params:(NSDictionary *)params{
    BaseNavigationViewController *baseNaVC = (BaseNavigationViewController*)viewController.navigationController;
    NSString *instanceKey = [baseNaVC.instanceKey componentsSeparatedByString:@"-"][0];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:instanceKey];
}
@end
