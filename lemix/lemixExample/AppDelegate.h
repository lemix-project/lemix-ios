//
//  AppDelegate.h
//  lemixExample
//
//  Created by 王炜光 on 2018/10/25.
//  Copyright © 2018 lemix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "MapLocationStandard.h"
#import "CallCustomFuncStandard.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,MapLocationStandard,CallCustomFuncStandard>
@property AMapLocationManager *locationManager;
@property (strong, nonatomic) UIWindow *window;
@property UIInterfaceOrientationMask interfaceOrientationMask;



@end

