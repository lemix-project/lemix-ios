//
//  Style.m
//  zwt-ios
//
//  Created by 王炜光 on 2018/8/22.
//  Copyright © 2018年 LemonIT.CN. All rights reserved.
//

#import "ui_style.h"
#import "CommunicationInfo.h"
#import "ColorUtil.h"
#import "UiStyle.h"
@implementation ui_style

- (void)setNavigationBarHidden:(CommunicationInfo *)info{
    [UiStyle setNavigationBarHiddenForController:info.controller hidden:[info.params[@"isHidden"] boolValue]];
}

- (void)setNavigationBackgroundColor:(CommunicationInfo *)info{
    [UiStyle setNavigationBackgroundColorForController:info.controller color:[ColorUtil colorWithHexString:info.params[@"color"]]];
}

- (void)setNavigationTitle:(CommunicationInfo *)info{
    [UiStyle setNavigationTitleForController:info.controller title:info.params[@"title"]];
}

- (void)setStatusBarHidden:(CommunicationInfo *)info{
    [UiStyle setStatusBarHiddenForController:info.controller hidden:[info.params[@"isHidden"] boolValue]];
}
- (void)setNavigationItemColor:(CommunicationInfo *)info{
    [UiStyle setNavigationItemColorForController:info.controller color:[ColorUtil colorWithHexString:info.params[@"color"]]];
}
- (void)setStatusBarStyle:(CommunicationInfo *)info{
    [UiStyle setStatusBarStyle:info.params[@"style"]];
}
- (void)getNavigationBarHeight:(CommunicationInfo *)info{
    NSString *callJSString = [NSString stringWithFormat:@"__load_callback('%@','%f')",info.params[@"success"],[[UIApplication sharedApplication] statusBarFrame].size.height];
    [info.controller.webView evaluateJavaScript:callJSString completionHandler:^(id resultObject, NSError * _Nullable error) {
        if (!error){
            NSLog(@"OC调 JS成功");
        }else{
            NSLog(@"OC调 JS 失败");
        }
    }];
}
@end
