//
//  UiNavigation.m
//  zwt-ios
//
//  Created by 王炜光 on 2018/8/23.
//  Copyright © 2018年 LemonIT.CN. All rights reserved.
//

#import "UiNavigation.h"
#import "ViewControllerTypeEnum.h"
#import "LemixWebViewController.h"
#import "ColorUtil.h"
#import "BaseNavigationViewController.h"
#import "NativePageInfo.h"
@implementation UiNavigation


+ (void)popViewController:(BaseViewController *)baseViewController layer:(NSInteger)layer{
    if (baseViewController.navigationController.viewControllers.count > 1) {
        UIViewController *popViewController = baseViewController.navigationController.viewControllers[baseViewController.navigationController.viewControllers.count-1-(layer>1?layer:1)];
        [baseViewController.navigationController popToViewController:popViewController animated:YES];
    }
}

+ (void)pushOrPresent:(NSInteger)status baseViewController:(BaseViewController *)baseViewController  aimInfo:(AimViewControllerInfo *)aimInfo defaultStyle:(NSDictionary *)styleDic{

    BaseViewController *aimViewController = [[BaseViewController alloc] init];
    if ([aimInfo.type isEqualToString:TYPE_NATIVE]) {
        if (!((BaseNavigationViewController *)baseViewController.navigationController).lemixEngine.nativePagePool[aimInfo.aim].nativePage) {
            NSLog(@"NOT FIND CLASS!");
            return;
        }
        [((BaseNavigationViewController *)baseViewController.navigationController).lemixEngine.nativePagePool[aimInfo.aim].nativePage new];
        styleDic = aimInfo.webProgram;
    }else if([aimInfo.type isEqualToString:TYPE_ABSOLUTE]){
        aimViewController = [[LemixWebViewController alloc] init];
        ((LemixWebViewController *)aimViewController).urlStr = aimInfo.aim;
    }else if([aimInfo.type isEqualToString:TYPE_RELATIVE]){
        if ([baseViewController isKindOfClass:[LemixWebViewController class]]) {
            LemixWebViewController *currentController =(LemixWebViewController *)baseViewController;
            
            aimViewController = [[LemixWebViewController alloc] init];
            NSMutableArray *urlArr = [NSMutableArray arrayWithArray:[currentController.webView.URL.absoluteString componentsSeparatedByString:@"/"]];
            
            if (urlArr.count >3) {
                [urlArr removeLastObject];
            }

            if ([[urlArr lastObject] isEqualToString:@""]&&urlArr.count >3) {
                [urlArr removeLastObject];
            }
            
            NSArray *releativeArr = [aimInfo.aim componentsSeparatedByString:@"/"];
            NSString *releativeUrlStr = @"";
            for (NSInteger i =0 ; i<releativeArr.count; i++) {
                if ([releativeArr[i] isEqualToString:@".."]){
                    if (urlArr.count > 2) {
                        [urlArr removeLastObject];
                    }
                    
                }else if (![releativeArr[i] isEqualToString:@"."]){
                    if (releativeUrlStr.length == 0) {
                        releativeUrlStr = releativeArr[i];
                    }else{
                        releativeUrlStr = [NSString stringWithFormat:@"%@/%@",releativeUrlStr,releativeArr[i]];
                    }
                }
            }
            
            
            ((LemixWebViewController *)aimViewController).urlStr = [NSString stringWithFormat:@"%@/%@",[urlArr componentsJoinedByString:@"/"],releativeUrlStr];
        }
        
    }else if([aimInfo.type isEqualToString:TYPE_EXT]){
        aimViewController = [[LemixWebViewController alloc] init];
        NSDictionary *webProgramDic = aimInfo.webProgram?aimInfo.webProgram:((LemixWebViewController *)baseViewController).webProgram;
        ((LemixWebViewController *)aimViewController).webProgram = webProgramDic;
        ((LemixWebViewController *)aimViewController).aimStr = aimInfo.aim;
        
        NSString *configJSONPath = webProgramDic[webProgramDic[@"config"][@"identifier"]][[NSString stringWithFormat:@"%@.%@",webProgramDic[@"config"][@"identifier"],aimInfo.aim]];
        
        configJSONPath = [configJSONPath stringByReplacingOccurrencesOfString:@"index.html" withString:@"config.json"];
        
        if (configJSONPath) {
            NSData *jsonData = [NSData dataWithContentsOfFile:configJSONPath options:NSDataReadingMappedIfSafe error:nil];
            NSMutableDictionary *configDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            styleDic = configDic;
        }
    }else{
        
    }
    aimViewController.configDic = styleDic;
    aimViewController.json = aimInfo.json;
    if (status == 1) {
        
        BaseNavigationViewController *naVC = [[BaseNavigationViewController alloc] initWithRootViewController:aimViewController];
        
        [baseViewController presentViewController:naVC animated:YES completion:nil];
    }else{
        
        [baseViewController.navigationController pushViewController:aimViewController animated:YES];
    }
    
    
}

+ (void)popOrCloseStatus:(NSInteger)status viewController:(BaseViewController *)baseViewController layer:(NSInteger)layer{
    if (status == 1) {
        UIViewController *parentVC = baseViewController.presentingViewController;
        UIViewController *bottomVC;
        
        for (NSInteger i = 0; i<(layer>1?layer:1); i++) {
            bottomVC = parentVC;
            parentVC = parentVC.presentingViewController;
            if (!parentVC) {
                break;
            }
        }
        [bottomVC dismissViewControllerAnimated:YES completion:nil];
    }else{
        if (baseViewController.navigationController.viewControllers.count > 1) {
            UIViewController *popViewController = baseViewController.navigationController.viewControllers[baseViewController.navigationController.viewControllers.count-1-(layer>1?layer:1)];
            [baseViewController.navigationController popToViewController:popViewController animated:YES];
        }
    }
    
}

@end
