//
//  UiNavigation.h
//  zwt-ios
//
//  Created by 王炜光 on 2018/8/23.
//  Copyright © 2018年 LemonIT.CN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "AimViewControllerInfo.h"
@interface UiNavigation : NSObject



+ (void)pushOrPresent:(NSInteger)status baseViewController:(BaseViewController *)baseViewController aimInfo:(AimViewControllerInfo *)aimInfo defaultStyle:(NSDictionary *)styleDic;
+ (void)popOrCloseStatus:(NSInteger)status viewController:(BaseViewController *)baseViewController layer:(NSInteger)layer;
@end
