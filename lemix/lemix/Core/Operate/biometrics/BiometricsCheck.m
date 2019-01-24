//
//  BiometricsCheck.m
//  lemixExample
//
//  Created by 王炜光 on 2018/12/18.
//  Copyright © 2018 lemix. All rights reserved.
//

#import "BiometricsCheck.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "LemixWebViewController.h"
@implementation BiometricsCheck
+ (void)checkTouchIDForController:(BaseViewController *)viewController params:(NSDictionary *)params{
    //1.判断iOS8及以后的版本
    if([UIDevice currentDevice].systemVersion.doubleValue >= 8.0){
        //从iPhone5S开始,出现指纹识别技术,所以说在此处可以进一步判断是否是5S以后机型
        //2.创建本地验证上下文对象-->这里导入框架LocalAuthentication
        LAContext *context = [LAContext new];
        context.localizedFallbackTitle = @"";
        // 3.判断能否使用指纹识别
        //Evaluate: 评估
        //Policy: 策略
        //LAPolicyDeviceOwnerAuthenticationWithBiometrics: 设备拥有者授权 用 生物识别技术
        if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]){
            
            //4.在可以使用的前提下就会调用
            //localizedReason本地原因alert显示
            NSString *localizedReason = @"指纹验证";
            if (@available(iOS 11.0, *)) {
                if (context.biometryType == LABiometryTypeTouchID) {
                    
                }else if (context.biometryType == LABiometryTypeFaceID){
                    localizedReason = @"人脸识别";
                }
            } else {
                // Fallback on earlier version
            }
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:localizedReason reply:^(BOOL success, NSError * _Nullable error) {
                NSLog(@"%@",error);
                NSString *callJSString;
                if (success) {
                    callJSString = [NSString stringWithFormat:@"__load_callback('%@','验证成功')",params[@"success"]];
                }else {
                    NSDictionary *errorDic;
                    switch (error.code) {
                        case LAErrorAuthenticationFailed:
                            errorDic = @{@"code":@"0",@"message":@"指纹验证失败"};
                            break;
                        case LAErrorUserCancel:
                            break;
                        case LAErrorUserFallback:
                            break;
                        case LAErrorSystemCancel:
                            break;
                        case LAErrorPasscodeNotSet:
                            errorDic = @{@"code":@"1",@"message":@"无法启动,用户没有设置密码"};
                        case LAErrorBiometryNotEnrolled:
                            errorDic = @{@"code":@"1",@"message":@"无法启动,用户没有设置密码"};
                        case LAErrorTouchIDNotAvailable:
                            errorDic = @{@"code":@"2",@"message":@"无效"};
                            break;
                        case LAErrorTouchIDLockout:
                            errorDic = @{@"code":@"2",@"message":@"TouchID被锁定"};
                            break;
                        case LAErrorAppCancel:
                            break;
                        case LAErrorInvalidContext:
                            break;
                        default:
                            break;
                    }
                    if (!errorDic) {
                        return ;
                    }
                    callJSString = [NSString stringWithFormat:@"__load_callback('%@','%@')",params[@"failed"],[self dicToJson:errorDic]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [((LemixWebViewController *)viewController).webView evaluateJavaScript:callJSString completionHandler:^(id resultObject, NSError * _Nullable error) {
                        if (!error){
                            NSLog(@"OC调 JS成功");
                        }else{
                            NSLog(@"OC调 JS 失败");
                        }
                    }];
                });
            }];
        }else{
            
            
            [((LemixWebViewController *)viewController).webView evaluateJavaScript:[NSString stringWithFormat:@"__load_callback('%@','%@')",params[@"failed"],[self dicToJson:@{@"code":@"2",@"message":@"请确保(5S以上机型),TouchID已打开"}]] completionHandler:^(id resultObject, NSError * _Nullable error) {
                if (!error){
                    NSLog(@"OC调 JS成功");
                }else{
                    NSLog(@"OC调 JS 失败");
                }
            }];
        }
    }else{
        [((LemixWebViewController *)viewController).webView evaluateJavaScript:[NSString stringWithFormat:@"__load_callback('%@','%@')",params[@"failed"],[self dicToJson:@{@"code":@"3",@"message":@"此设备不支持生物认证"}]] completionHandler:^(id resultObject, NSError * _Nullable error) {
            if (!error){
                NSLog(@"OC调 JS成功");
            }else{
                NSLog(@"OC调 JS 失败");
            }
        }];
        
    }
}
+ (NSString *)dicToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *responce = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSMutableString *mutStr = [NSMutableString stringWithString:responce];
    
    
    NSRange range = {0,((NSString *)responce).length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}
@end
