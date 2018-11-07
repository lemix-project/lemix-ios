//
//  WebViewCacheManager.m
//  lemix
//
//  Created by 王炜光 on 2018/10/16.
//  Copyright © 2018 lemix. All rights reserved.
//

#import "WebViewCacheManager.h"
static NSInteger maxCount;
@implementation WebViewCacheManager
+ (WebViewCacheManager *)shareWebViewCacheManager{
    static WebViewCacheManager *webViewCacheManager = nil;
    static dispatch_once_t takeOnce;
    
    dispatch_once(&takeOnce,^{
        webViewCacheManager = [[WebViewCacheManager alloc]init];
        
    });
    return webViewCacheManager;
}

- (void)initPool:(NSInteger)count{
    maxCount = count;
    self.webViewArr = [NSMutableArray new];
    for (NSInteger i = 0; i<count; i++) {
        [self.webViewArr addObject:[self createWebView]];
    }
}

- (WKWebView *)createWebView{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    // web内容处理池
    config.processPool = [[WKProcessPool alloc] init];
    
    // 通过JS与webview内容交互
    config.userContentController = [[WKUserContentController alloc] init];
    // 注入JS对象名称AppModel，当JS通过AppModel来调用时，
    // 我们可以在WKScriptMessageHandler代理中接收到
    [config.userContentController addScriptMessageHandler:(id)self name:@"message"];
    [config.userContentController addScriptMessageHandler:(id)self name:@"promp"];
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) configuration:config];
    [webView evaluateJavaScript:[self getMinJS] completionHandler:nil];
    [webView evaluateJavaScript:@"$__set_platform__('ios')" completionHandler:nil];
    
    return webView;
}

- (WKWebView *)getWebView{
    if (self.webViewArr.count > 0) {
        
        WKWebView *webView = [self.webViewArr firstObject];
        [self.webViewArr removeObjectAtIndex:0];
        return webView;
    }else{
        WKWebView *webView = [self createWebView];
        //        [self.webViewArr addObject:webView];
        return webView;
    }
}

- (void)putBackWebView:(WKWebView *)webView{
    if (self.webViewArr.count == maxCount) {
        return;
    }else{
        [self.webViewArr addObject:webView];
    }
}

- (NSString *)getMinJS{
    NSURL *path = [[NSBundle mainBundle] URLForResource:@"lemix.min" withExtension:@"js"];
    NSData *data = [NSData dataWithContentsOfURL:path];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
