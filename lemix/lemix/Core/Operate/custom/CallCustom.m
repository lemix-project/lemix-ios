//
//  CallCustom.m
//  lemixExample
//
//  Created by 王炜光 on 2018/11/22.
//  Copyright © 2018 lemix. All rights reserved.
//

#import "CallCustom.h"
#import "LemixWebViewController.h"
#import "BaseNavigationViewController.h"
@implementation CallCustom
+(void)callCustomForController:(BaseViewController *)viewController params:(NSDictionary *)params{
    BaseNavigationViewController *baseNaVC = (BaseNavigationViewController*)viewController.navigationController;
    if (!baseNaVC.lemixEngine.config.callCustomFuncOBJ) {
        NSLog(@"未找到自定义方法实例");
        return;
    }
    
    [baseNaVC.lemixEngine.config.callCustomFuncOBJ callCustomFuncForData:params success:^(__autoreleasing id responce) {
        
        if ([responce isKindOfClass:[NSDictionary class]]) {
            NSError *parseError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responce options:NSJSONWritingPrettyPrinted error:&parseError];
            responce = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSMutableString *mutStr = [NSMutableString stringWithString:responce];
            
            
            NSRange range = {0,((NSString *)responce).length};
            
            //去掉字符串中的空格
            
            [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
            
            NSRange range2 = {0,mutStr.length};
            
            //去掉字符串中的换行符
            
            [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
            responce = mutStr;
        }
        
        NSString *callJSString = [NSString stringWithFormat:@"__load_callback('%@','%@')",params[@"success"],responce];
        
        [((LemixWebViewController *)viewController).webView evaluateJavaScript:callJSString completionHandler:^(id resultObject, NSError * _Nullable error) {
            if (!error){
                NSLog(@"OC调 JS成功");
            }else{
                NSLog(@"OC调 JS 失败");
            }
        }];
    } failed:^(id  _Nonnull responce) {
        BaseNavigationViewController *baseNaVC = (BaseNavigationViewController*)viewController.navigationController;
        if (!baseNaVC.lemixEngine.config.callCustomFuncOBJ) {
            NSLog(@"未找到自定义方法实例");
            return;
        }
        if ([responce isKindOfClass:[NSDictionary class]]) {
            NSError *parseError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responce options:NSJSONWritingPrettyPrinted error:&parseError];
            responce = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSMutableString *mutStr = [NSMutableString stringWithString:responce];
            
            
            NSRange range = {0,((NSString *)responce).length};
            //去掉字符串中的空格
            [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
            NSRange range2 = {0,mutStr.length};
            //去掉字符串中的换行符
            [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
            responce = mutStr;
        }
        
        NSString *callJSString = [NSString stringWithFormat:@"__load_callback('%@','%@')",params[@"failed"],responce];
        
        [((LemixWebViewController *)viewController).webView evaluateJavaScript:callJSString completionHandler:^(id resultObject, NSError * _Nullable error) {
            if (!error){
                NSLog(@"OC调 JS成功");
            }else{
                NSLog(@"OC调 JS 失败");
            }
        }];
    }];
}
@end
