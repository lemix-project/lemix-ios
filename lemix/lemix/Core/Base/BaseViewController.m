//
//  BaseViewController.m
//  lemix
//
//  Created by 王炜光 on 2018/10/15.
//  Copyright © 2018 lemix. All rights reserved.
//

#import "BaseViewController.h"
#import "ColorUtil.h"
#define KIsiPhoneX ([[UIDevice currentDevice].systemVersion integerValue] >= 11 ?([UIApplication sharedApplication].windows[0].safeAreaInsets.bottom>0) : NO)
@interface BaseViewController ()
@property UIInterfaceOrientationMask interfaceOrientationMask;

@property UILabel *tipLabel;
@end

@implementation BaseViewController



- (void)backAction:(UIButton *)btn{
    
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    
    
    self.navigationBarBGView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, KIsiPhoneX?88:64)];
    [self.view addSubview:self.navigationBarBGView];
    
    
    self.navigationBar= [[UINavigationBar alloc] initWithFrame:CGRectMake(0, KIsiPhoneX?40:20, self.view.frame.size.width, 44)];
    self.navigationBar.translucent = true;
    [self.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:self.navigationBar];
    //    self.view.backgroundColor = [UIColor whiteColor];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setImage:[UIImage imageNamed:@"backBtnImage"] forState:UIControlStateNormal];
    
    self.backBtn.frame = CGRectMake(16, 0, 64, 44);
    self.backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.backBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.navigationBar addSubview:self.backBtn];
    
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, self.view.frame.size.width-160, 44)];
    self.titleLabel.text = @"webview";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navigationBar addSubview:self.titleLabel];
    //    [self onNavigationHiddenStatusChange:YES];
    self.tipLabel = [[UILabel alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onNavigationHiddenStatusChange:(BOOL)isHidden{
    self.navigationBar.hidden = isHidden;
    self.navigationBarBGView.hidden = isHidden;
}

- (void)onNavigationBarColorChange:(UIColor *)color{
    self.navigationBarBGView.backgroundColor = color;
    self.navigationController.navigationBar.tintColor = color;
}

- (void)onNavigationTitleChange:(NSString *)title{
    self.titleLabel.text = title;
}

- (BOOL)prefersStatusBarHidden{
    [super prefersStatusBarHidden];
    return _statusBarHidden;
}

- (void)onNavigationItemColorChange:(UIColor *)color{
    self.titleLabel.textColor = color;
    [self.backBtn setTitleColor:color forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
//
//    self.interfaceOrientationMask = appdelegate.interfaceOrientationMask;
    
    
    
    for (NSString *key in self.configDic) {
        
        switch ([@[@"navigationBackgroundColor",@"navigationItemColor",@"statusBarHidden",@"navigationTitle",@"statusBarStyle",@"navigationHidden"] indexOfObject:key]) {
            case 0:
                [self onNavigationBarColorChange:[ColorUtil colorWithHexString:self.configDic[key]]];
                break;
            case 1:
                [self onNavigationItemColorChange:[ColorUtil colorWithHexString:self.configDic[key]]];
                break;
            case 2:
                if (@available(iOS 11.0,*)) {
                    
                    [[UIApplication sharedApplication] setStatusBarHidden:[self.configDic[key] boolValue]];
                }
                break;
            case 3:
                [self onNavigationTitleChange:self.configDic[key]];
                break;
            case 4:
                if (@available(iOS 11.0,*)) {
                [[UIApplication sharedApplication] setStatusBarStyle:[@[@"dark",@"light"] indexOfObject:self.configDic[key]] animated:YES];
                }
                break;
            case 5:
                [self onNavigationHiddenStatusChange:[self.configDic[key] boolValue]];
                break;
                
            default:
                break;
        }
    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    //强制旋转为竖屏
    //    [self forceOrientationReturn];
    
}
// 还原
- (void)forceOrientationReturn{
    
    
//    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
//    if (self.interfaceOrientationMask != appdelegate.interfaceOrientationMask) {
//        [appdelegate setInterfaceOrientationMask:self.interfaceOrientationMask];
//        [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
//        UIInterfaceOrientation interfaceOrientation = UIInterfaceOrientationPortrait;
//        switch (self.interfaceOrientationMask) {
//            case UIInterfaceOrientationMaskPortrait:
//                interfaceOrientation = UIInterfaceOrientationPortrait;
//                break;
//            case UIInterfaceOrientationMaskLandscapeLeft:
//                interfaceOrientation = UIInterfaceOrientationLandscapeLeft;
//                break;
//            case UIInterfaceOrientationMaskLandscapeRight:
//                interfaceOrientation = UIInterfaceOrientationLandscapeRight;
//                break;
//
//            default:
//                break;
//        }
//        //强制翻转屏幕为竖屏
//        [[UIDevice currentDevice] setValue:@(interfaceOrientation) forKey:@"orientation"];
//        //刷新
//        [UIViewController attemptRotationToDeviceOrientation];
//    }
    
}
// 强制横屏
- (void)forceOrientationChange:(NSString *)direction{
//    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
//    UIInterfaceOrientationMask interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
//    UIInterfaceOrientation interfaceOrientation = UIInterfaceOrientationPortrait;
//    switch ([@[@"left",@"right",@"bottom"] indexOfObject:direction]) {
//        case 0:
//            interfaceOrientationMask = UIInterfaceOrientationMaskLandscapeLeft;
//            interfaceOrientation = UIInterfaceOrientationLandscapeLeft;
//            break;
//        case 1:
//            interfaceOrientationMask = UIInterfaceOrientationMaskLandscapeRight;
//            interfaceOrientation = UIInterfaceOrientationLandscapeRight;
//            break;
//        case 2:
//            interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
//            interfaceOrientation = UIInterfaceOrientationPortrait;
//            break;
//            
//        default:
//            break;
//    }
//    
//    
//    [appdelegate setInterfaceOrientationMask:interfaceOrientationMask];
//    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
//    
//    
//    //强制翻转屏幕
//    [[UIDevice currentDevice] setValue:@(interfaceOrientation) forKey:@"orientation"];
//    //刷新
//    [UIViewController attemptRotationToDeviceOrientation];
}


- (void)onClose{
    
}

- (void)viewDidDisappear:(BOOL)animated{
    if (self.navigationController.viewControllers.count == 0) {
        [self onClose];
    }
}
- (void)showTip:(NSString *)title{
    if (self.tipLabel.superview) {
        return;
    }
    //如果宽度超过xx 折行
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil];
    CGRect rect = [title boundingRectWithSize:CGSizeMake(self.view.frame.size.width-32-20, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    if (rect.size.height > 20) {
    }else{
        rect = [title boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    }
    self.tipLabel.frame = CGRectMake(0, 0, rect.size.width+20, rect.size.height+10);
    
    self.tipLabel.numberOfLines = 0;
    self.tipLabel.font = [UIFont systemFontOfSize:14];
    self.tipLabel.center = CGPointMake(self.view.frame.size.width/2, 64+(rect.size.height+10)/2+10);
    self.tipLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.tipLabel.textColor = [UIColor whiteColor];
    self.tipLabel.layer.cornerRadius = 5;
    self.tipLabel.layer.masksToBounds = YES;
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.text = title;
    [self.view addSubview:self.tipLabel];
    [self.view bringSubviewToFront:self.tipLabel];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tipLabel removeFromSuperview];
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
