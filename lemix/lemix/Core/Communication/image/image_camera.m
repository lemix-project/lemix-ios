//
//  image_camera.m
//  zwt-ios
//
//  Created by 王炜光 on 2018/8/22.
//  Copyright © 2018年 LemonIT.CN. All rights reserved.
//

#import "image_camera.h"
#import "CommunicationInfo.h"
#import "ImageCamera.h"
#import "ColorUtil.h"
#import <Lemage.h>
@implementation image_camera
- (void)open:(CommunicationInfo *)info{
    
    [Lemage startCameraWithVideoSeconds:[info.params[@"maxLength"] integerValue] themeColor:[ColorUtil colorWithHexString:info.params[@"theme"]] cameraStatus:info.params[@"mode"] cameraReturn:^(id  _Nonnull item) {
        NSLog(@"%@",item);

        NSString *callJSString = [NSString stringWithFormat:@"__load_callback('%@','%@')",info.params[@"success"],item];
        [info.controller.webView evaluateJavaScript:callJSString completionHandler:^(id resultObject, NSError * _Nullable error) {
            if (!error){
                NSLog(@"OC调 JS成功");
            }else{
                NSLog(@"OC调 JS 失败");
            }
        }];
    }];
}

- (void)album:(CommunicationInfo *)info{
    
}

@end
