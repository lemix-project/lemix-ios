//
//  ui_navigation.m
//  zwt-ios
//
//  Created by 王炜光 on 2018/8/23.
//  Copyright © 2018年 LemonIT.CN. All rights reserved.
//

#import "ui_navigation.h"


@implementation ui_navigation
- (void)push:(CommunicationInfo *)info{
    [UiNavigation pushOrPresent:2 baseViewController:info.controller aimInfo:[ui_navigation getAimControllerInfoFor:info] defaultStyle:info.params[@"config"]];
}
- (void)present:(CommunicationInfo *)info{
    
    [UiNavigation pushOrPresent:1 baseViewController:info.controller aimInfo:[ui_navigation getAimControllerInfoFor:info] defaultStyle:info.params[@"config"]];
}
+ (AimViewControllerInfo *)getAimControllerInfoFor:(CommunicationInfo *)info{
    AimViewControllerInfo *aimViewControllerInfo  = [[AimViewControllerInfo alloc] init];
    aimViewControllerInfo.aim = info.params[@"aim"];
    aimViewControllerInfo.type = info.params[@"type"];
    return aimViewControllerInfo;
}

- (void)pop:(CommunicationInfo *)info{
    [UiNavigation popOrCloseStatus:2 viewController:info.controller layer:[info.params[@"layer"] integerValue]];
}

- (void)close:(CommunicationInfo *)info{
    [UiNavigation popOrCloseStatus:1 viewController:info.controller layer:[info.params[@"layer"] integerValue]];
}
@end
