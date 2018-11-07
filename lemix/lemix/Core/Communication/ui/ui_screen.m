//
//  ui_screen.m
//  zwt-ios
//
//  Created by 王炜光 on 2018/8/22.
//  Copyright © 2018年 LemonIT.CN. All rights reserved.
//

#import "ui_screen.h"
#import "CommunicationInfo.h"
@implementation ui_screen
- (CGFloat)getWidth:(CommunicationInfo *)info{
    return info.controller.view.frame.size.width;
}
- (CGFloat)getHeight:(CommunicationInfo *)info{
    return info.controller.view.frame.size.height;
}
- (void)rotate:(CommunicationInfo *)info{
    [info.controller forceOrientationChange:info.params[@"direction"]];
}
@end
