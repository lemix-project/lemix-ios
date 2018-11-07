//
//  ColorUtil.h
//  zwt-ios
//
//  Created by 王炜光 on 2018/8/22.
//  Copyright © 2018年 LemonIT.CN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ColorUtil : NSObject
/**
 十六进制的颜色转换为UIColor(RGB)
 
 @param color 十六进制的颜色(#开头)
 @return 转换后的UIColor
 */
+ (UIColor *) colorWithHexString: (NSString *)color;
@end
