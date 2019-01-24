//
//  Lemoncs.m
//  lemixExample
//
//  Created by 王炜光 on 2018/12/13.
//  Copyright © 2018 lemix. All rights reserved.
//

#import "Lemoncs.h"
#import "ScanQRCodeViewController.h"
@implementation Lemoncs
+(void)startScanQRCodeReturn:(LEMONACS_QRCODE_BLOCK)cameraReturn{
    ScanQRCodeViewController *scanQRCodeVC = [[ScanQRCodeViewController alloc] init];
    scanQRCodeVC.scanY = 150;
    scanQRCodeVC.scanSize = CGSizeMake(250, 250);
    scanQRCodeVC.title = @"lemonacs";
    scanQRCodeVC.takeBlock = ^(id item) {
        cameraReturn(item);
    };
    [[self getCurrentVC] presentViewController:scanQRCodeVC animated:YES completion:nil];
}
/**
 获取当前正在显示的viewcontroller
 
 @return 正在显示的viewcontroller
 */
+ (UIViewController *)getCurrentVC{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}
@end
