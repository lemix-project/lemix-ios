//
//  Lemoncs.h
//  lemixExample
//
//  Created by 王炜光 on 2018/12/13.
//  Copyright © 2018 lemix. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^ LEMONACS_QRCODE_BLOCK)(id item);
NS_ASSUME_NONNULL_BEGIN

@interface Lemoncs : NSObject
/**
 开启二维码扫描
 
 @param cameraReturn 返回的扫描结果
 */
+(void)startScanQRCodeReturn:(LEMONACS_QRCODE_BLOCK)cameraReturn;
@end

NS_ASSUME_NONNULL_END
