//
//  image_code.m
//  lemixExample
//
//  Created by 王炜光 on 2018/12/13.
//  Copyright © 2018 lemix. All rights reserved.
//

#import "image_code.h"
#import "Lemoncs.h"
#import "CommunicationInfo.h"
@implementation image_code
- (void)scanQRCode:(CommunicationInfo *)info{
    [Lemoncs startScanQRCodeReturn:^(id item) {
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
@end
