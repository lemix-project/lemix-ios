//
//  ViewController.m
//  lemixExample
//
//  Created by 王炜光 on 2018/10/25.
//  Copyright © 2018 lemix. All rights reserved.
//

#import "ViewController.h"
#import "Lemix.h"
#import "WaitingPage.h"
#import "Lemoncs.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:tempBtn];
    [tempBtn addTarget:self action:@selector(presentView:) forControlEvents:UIControlEventTouchUpInside];
    tempBtn.backgroundColor = [UIColor blueColor];
    
    MixModuleInfo *moduleInfo = [[MixModuleInfo alloc] init];
    moduleInfo.mixModuleURL = @"http://static.lemonit.vip/zwt-ext-attendance.zip";
    moduleInfo.moduleName = @"考勤打卡";
    moduleInfo.imageURL = @"http://static.lemonit.vip/zwt-ext-attendance.png";
    moduleInfo.mixModuleIdentifier = @"com.zhongwang.zwt.ext.attendance";
    moduleInfo.packageTime = @"1536127267";
    [[Lemix defaultEngine] registerRemoteMixModule:@[moduleInfo]];
    NSLog(@"%@",moduleInfo);
    
}
- (void)presentView:(id)btn{
//    StartUpMixModuleParameter *moduleParameter = [[StartUpMixModuleParameter alloc]init];
//    moduleParameter.moduleKey = @"com.zhongwang.zwt.ext.attendance";
//    moduleParameter.packageTime = @"1536127267";
//    ////    moduleParameter.startPage = @"attendance";
//    //    moduleParameter.nativePageKey = @"123";
//    MixModuleLifeCycle *lifeCycle = [[MixModuleLifeCycle alloc]init];
    [[Lemix defaultEngine] startUpMixModule:moduleParameter mixModuleLifeCycle:lifeCycle];
//    lifeCycle.onShow = ^{
//        NSLog(@"zhanshi");
//    };
//    //    lifeCycle.onShow = ^{
//    //        NSLog(@"zhansh1");
//    //    };
//    //    lifeCycle.onShow = ^{
//    //        NSLog(@"zhanshi2");
//    //    };
//    //
//    //    lifeCycle.onHide = ^{
//    //        NSLog(@"隐藏");
//    //    };
//    //    NativePageInfo *info = [[NativePageInfo alloc] init];
//    //    info.nativePageKey = @"123";
//    //    info.nativePage = NSClassFromString(@"555");
//    //    [[Lemix defaultEngine] registerNativePage:@[info]];
//    [[Lemix defaultEngine] startUpNativePage:moduleParameter];
    [Lemoncs startScanQRCodeReturn:^(id item) {
        
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    
}


@end
