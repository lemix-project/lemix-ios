//
//  LemixWebViewController.m
//  lemix
//
//  Created by 王炜光 on 2018/10/16.
//  Copyright © 2018 lemix. All rights reserved.
//

#import "LemixWebViewController.h"
#import "ColorUtil.h"
#import "CommunicationInfo.h"
#import "WebViewCacheManager.h"
#define KIsiPhoneX ([[UIDevice currentDevice].systemVersion integerValue] >= 11 ?([UIApplication sharedApplication].windows[0].safeAreaInsets.bottom>0) : NO)
@interface LemixWebViewController ()<WKNavigationDelegate, UIWebViewDelegate, WKUIDelegate>
@property UIStatusBarStyle statusBarStyle;
@property NSURL *url;
@property BOOL hasFinished;
@end

@implementation LemixWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadWebView];
    _statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    self.statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self.navigationController.viewControllers[0] isKindOfClass:[self class]]) {
        self.backBtn.alpha = 1;
    }else{
        self.backBtn.alpha = 0;
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    
}

- (void)initSubviews{
    
}

- (void)loadWebView{
    
    
    self.webView = [[WebViewCacheManager shareWebViewCacheManager] getWebView];
    self.webView.frame = CGRectMake(0, KIsiPhoneX?88:64, self.view.frame.size.width, self.view.frame.size.height-KIsiPhoneX?88:64);
    // 导航代理
    self.webView.navigationDelegate = self;
    // 与webview UI交互代理
    self.webView.UIDelegate = self;
    
    [self.view addSubview:self.webView];
    if (self.urlStr) {
        _url = [NSURL URLWithString:self.urlStr];
    }
    if (self.webProgram) {
        _url = [NSURL fileURLWithPath:self.webProgram[self.webProgram[@"config"][@"identifier"]][[NSString stringWithFormat:@"%@.%@",self.webProgram[@"config"][@"identifier"],self.aimStr]]];
    }
    
    NSLog(@"%@",_url);
    [self.webView loadRequest:[NSURLRequest requestWithURL:_url]];
    
    self.webView.scrollView.bounces = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString *)getMinJS{
    NSURL *path = [[NSBundle mainBundle] URLForResource:@"lemix.min" withExtension:@"js"];
    NSData *data = [NSData dataWithContentsOfURL:path];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    [webView evaluateJavaScript:[self getMinJS] completionHandler:nil];
    [webView evaluateJavaScript:@"$__set_platform__('ios')" completionHandler:nil];
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"__onload(%@)",self.json] completionHandler:nil];
    _hasFinished = YES;
    [self.webView evaluateJavaScript:@"__onshow()" completionHandler:nil];
    if (self.webOnShow) {
        self.webOnShow(self.webView);
    }
}
#pragma mark - WKScriptMessageHandler
// 通过这个方法获取 JS传来的json字符串
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    NSLog(@"promtp:%@",prompt);
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[prompt dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *components = [dic[@"type"] componentsSeparatedByString:@"."];
    if (components.count > 2) {
        
        Class class = NSClassFromString([NSString stringWithFormat:@"%@_%@",components[0],components[1]]);
        if (class) {
            SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:",components[2]]);
            NSObject *instance =  [class new];
            CommunicationInfo *info = [[CommunicationInfo alloc] initWithCurrentController:self data:dic completionHandler:dic[@"sync"]?completionHandler:nil];
            //            IMP imp = [instance methodForSelector:selector];
            //            void(*func)(id, SEL, CommunicationInfo*) = (void *)imp;
            //            id returnData = func(self, selector,info);
            if (!dic[@"sync"]) {
                [instance performSelector:selector withObject:info];
                completionHandler(@"");
            }else{
                id returnData = [instance performSelector:selector withObject:info];
                completionHandler(returnData);
            }
        }else{
            completionHandler(@"");
        }
        
    }
    
    
    
}

#pragma mark - WKScriptMessageHandler
// 通过这个方法获取 JS传来的json字符串
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"%@",message.body);
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[message.body dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers
                                                          error:nil];
    NSArray *components = [dic[@"type"] componentsSeparatedByString:@"."];
    if (components.count > 2) {
        
        Class class = NSClassFromString([NSString stringWithFormat:@"%@_%@",components[0],components[1]]);
        SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:",components[2]]);
        NSObject *instance =  [class new];
        CommunicationInfo *info = [[CommunicationInfo alloc] initWithCurrentController:self data:dic completionHandler:nil];
        IMP imp = [instance methodForSelector:selector];
        void(*func)(id, SEL, CommunicationInfo*) = (void *)imp;
        if (func) {
            func(self, selector,info);
        }
    }
    
}

- (void)onNavigationHiddenStatusChange:(BOOL)isHidden{
    [super onNavigationHiddenStatusChange:isHidden];
    CGFloat statusBarHeight = 0;
    if (@available(iOS 9.0, *)) {
        statusBarHeight = -20;
    }
    CGFloat topFloat = [self iPhoneNotchScreen]?-44:statusBarHeight;
    self.webView.frame = CGRectMake(0, isHidden?topFloat:64,self.webView.frame.size.width, self.view.frame.size.height-topFloat);
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGFloat statusBarHeight = 0;
    if (@available(iOS 9.0, *)) {
        statusBarHeight = -20;
    }
    CGFloat topFloat = [self iPhoneNotchScreen]?-44:statusBarHeight;
    
    self.webView.frame = CGRectMake(0,self.navigationBar.hidden?topFloat:(KIsiPhoneX?88:64),self.view.frame.size.width, self.view.frame.size.height-(self.navigationBar.hidden?topFloat:KIsiPhoneX?88:64));
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
        
        
        //        self.webView.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
    }
}



- (BOOL)iPhoneNotchScreen{
    if (__IPHONE_OS_VERSION_MAX_ALLOWED< __IPHONE_11_0) {
        return NO;
    }
    CGFloat iPhoneNotchDirectionSafeAreaInsets = 0;
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeAreaInsets = [UIApplication sharedApplication].windows[0].safeAreaInsets;
        switch ([UIApplication sharedApplication].statusBarOrientation) {
            case UIInterfaceOrientationPortrait:{
                iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.top;
            }
                break;
            case UIInterfaceOrientationLandscapeLeft:{
                iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.left;
            }
                break;
            case UIInterfaceOrientationLandscapeRight:{
                iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.right;
            }
                break;
            case UIInterfaceOrientationPortraitUpsideDown:{
                iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.bottom;
            }
                break;
            default:
                iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.top;
                break;
        }
    } else {
        // Fallback on earlier versions
    }
    return iPhoneNotchDirectionSafeAreaInsets > 20;
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //reload fangfa
    if (_hasFinished) {
        
        [self.webView evaluateJavaScript:@"__onshow()" completionHandler:nil];
        if (self.webOnShow) {
            self.webOnShow(self.webView);
        }
    }
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(self.view.frame.size.width-57, 7, 50, 30);
    [closeBtn setImage:[self imageChangeColor:self.backBtn.currentTitleColor image:[UIImage imageNamed:@"closeBtnImage"]] forState:UIControlStateNormal];
    [closeBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    closeBtn.imageEdgeInsets=UIEdgeInsetsMake(7, 17, 7, 17);
    closeBtn.layer.cornerRadius = 8;
    [closeBtn addTarget:self action:@selector(closePlugin:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (self.navigationBar.hidden) {
        closeBtn.frame = CGRectMake(self.view.frame.size.width-57, KIsiPhoneX?51:27, 50, 30);
        [self.view addSubview:closeBtn];
    }else{
        [self.navigationBar addSubview:closeBtn];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (@available(iOS 11.0,*)) {
        
        [[UIApplication sharedApplication] setStatusBarStyle:_statusBarStyle animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:self.statusBarHidden];
    }
}

- (void)onClose{
    [super onClose];
    [[WebViewCacheManager shareWebViewCacheManager] putBackWebView:self.webView];
}

- (UIImage*)imageChangeColor:(UIColor*)color image:(UIImage *)image{
    //获取画布
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    //画笔沾取颜色
    [color setFill];
    
    CGRect bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    UIRectFill(bounds);
    //绘制一次
    [image drawInRect:bounds blendMode:kCGBlendModeOverlay alpha:1.0f];
    //再绘制一次
    [image drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    //获取图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)closePlugin:(UIButton *)btn{
    UIViewController *vc = self;
    while(vc.presentingViewController !=nil) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}


@end
