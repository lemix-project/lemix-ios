//
//  ScanQRCodeViewController.h
//  lemixExample
//
//  Created by 王炜光 on 2018/12/13.
//  Copyright © 2018 lemix. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^TakeQRCodeInfo)(id item);
NS_ASSUME_NONNULL_BEGIN

@interface ScanQRCodeViewController : BaseViewController
/**
 @brief 扫描区域高度
 */
@property (nonatomic, assign)CGFloat scanY;
/**
 @brief 扫描范围
 */
@property (nonatomic, assign)CGSize scanSize;
/**
 @brief 获取二维码信息回调
 */
@property (copy, nonatomic) TakeQRCodeInfo takeBlock;
@end

NS_ASSUME_NONNULL_END
