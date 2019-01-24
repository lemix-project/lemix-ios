//
//  AppDelegate.m
//  lemixExample
//
//  Created by 王炜光 on 2018/10/25.
//  Copyright © 2018 lemix. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "Lemix.h"
#import "WaitingPage.h"
#import "WebViewCacheManager.h"
#import "NSUrlProtocol+Lemage.h"
#import "LemageURLProtocol.h"
#import "webCallCustom.h"

@interface AppDelegate ()<AMapLocationManagerDelegate>

@end

@implementation AppDelegate
@synthesize updateLocation;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[WebViewCacheManager shareWebViewCacheManager] initPool:5];
    LemixEngineConfig *newConfig = [[LemixEngineConfig alloc] init];
    newConfig.waitingPage = [[WaitingPage alloc] init];
    newConfig.workspacePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    newConfig.tempPath = NSTemporaryDirectory();
    newConfig.mapLocationOBJ = self;
    newConfig.callCustomFuncOBJ = self;
    [Lemix startWork:newConfig];
    [Lemix defaultEngine];
    [self.window makeKeyWindow];
    self.window.rootViewController = [[ViewController alloc] init];
    
    [NSURLProtocol registerClass:[LemageURLProtocol class]];
    [NSURLProtocol registerToWKWebviewWithScheme:@"lemage"];
    
    
    [AMapServices sharedServices].apiKey = @"c6393a342305ac21277b1ceb707ce6df";
    self.locationManager = [[AMapLocationManager alloc] init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    //   定位超时时间，最低2s，此处设置为10s
    self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为10s
    self.locationManager.reGeocodeTimeout = 2;
    self.locationManager.delegate = self;
    NSLog(@"%@",[NSString stringWithFormat:@"%@",@{@"1":@"2"}]);
    return YES;
}


- (void)fixPostion:(void (^)(LocationInfo *responce))responce{
    
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        LocationInfo *locationInfo = [[LocationInfo alloc] init];
        if (error)
        {

            if (error.code == AMapLocationErrorLocateFailed)
            {
                locationInfo.locError = [NSString stringWithFormat:@"locError:{%ld - %@};", (long)error.code, error.localizedDescription];
                responce(locationInfo);

                return;
            }
        }

        locationInfo.lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
        locationInfo.lon = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
        locationInfo.formattedAddress = regeocode.formattedAddress;
        responce(locationInfo);
    }];
}

- (void)startUpdatingLocationDistanceFilter:(NSInteger)distanceFilter{
    if (distanceFilter > 0) {

        self.locationManager.distanceFilter = distanceFilter;
    }
    [self.locationManager setLocatingWithReGeocode:YES];
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation{
    [self.locationManager stopUpdatingLocation];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    
    
    LocationInfo *locationInfo = [[LocationInfo alloc] init];
    locationInfo.lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    locationInfo.lon = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    if (reGeocode) {
        locationInfo.formattedAddress = reGeocode.formattedAddress;
    }
    self.updateLocation?self.updateLocation(locationInfo):nil;
    
    
}

- (void)callCustomFuncForData:(NSDictionary *)data responce:(void (^)(id _Nonnull))responce{
    if ([data[@"type"] isEqualToString:@"getCode"]) {
        [webCallCustom getCode:data responce:^(id  _Nonnull callback) {
            responce(callback);
        }];
    }
}

// window支持的屏幕显示方向
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    
    return _interfaceOrientationMask;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
