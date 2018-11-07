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
@interface LemixWebViewController ()<WKNavigationDelegate, UIWebViewDelegate, WKUIDelegate>
@property UIStatusBarStyle statusBarStyle;
@property NSURL *url;

@end

@implementation LemixWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadWebView];
    _statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    self.statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)viewDidDisappear:(BOOL)animated{
    
}

- (void)initSubviews{
    
}

- (void)loadWebView{
   
    
    self.webView = [[WebViewCacheManager shareWebViewCacheManager] getWebView];
    self.webView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
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
//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"__onload(%@)",self.json] completionHandler:nil];
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
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[prompt dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers
                                                          error:nil];
    
    NSArray *components = [dic[@"type"] componentsSeparatedByString:@"."];
    if (components.count > 2) {
        
        Class class = NSClassFromString([NSString stringWithFormat:@"%@_%@",components[0],components[1]]);
        SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:",components[2]]);
        NSObject *instance =  [class new];
        CommunicationInfo *info = [[CommunicationInfo alloc] initWithCurrentController:self data:dic completionHandler:dic[@"sync"]?completionHandler:nil];
        IMP imp = [instance methodForSelector:selector];
        void(*func)(id, SEL, CommunicationInfo*) = (void *)imp;
        func(self, selector,info);
        if (!dic[@"sync"]) {
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
        func(self, selector,info);
        
    }
    
}

- (void)onNavigationHiddenStatusChange:(BOOL)isHidden{
    [super onNavigationHiddenStatusChange:isHidden];
    CGFloat topFloat = [self iPhoneNotchScreen]?-44:-20;
    self.webView.frame = CGRectMake(0, isHidden?topFloat:64,self.webView.frame.size.width, self.view.frame.size.height-topFloat);
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGFloat topFloat = [self iPhoneNotchScreen]?-44:-20;
    
    self.webView.frame = CGRectMake(0,self.navigationBar.hidden?topFloat:64,self.view.frame.size.width, self.view.frame.size.height-topFloat);
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


@end
