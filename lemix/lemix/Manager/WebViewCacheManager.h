//
//  WebViewCacheManager.h
//  lemix
//
//  Created by 王炜光 on 2018/10/16.
//  Copyright © 2018 lemix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
//NS_ASSUME_NONNULL_BEGIN

@interface WebViewCacheManager : NSObject
+ (WebViewCacheManager *)shareWebViewCacheManager;
@property NSMutableArray *webViewArr;
/**
 初始化webview连接池
 
 @param count 连接池中webview数量
 */
- (void)initPool:(NSInteger)count;
/**
 获取连接池webview
 
 @return webview
 */
- (WKWebView *)getWebView;
/**
 将webview放回连接池
 
 @param webView 将要放回连接池的webview
 */
- (void)putBackWebView:(WKWebView *)webView;
- (NSString *)getMinJS;
@end

//NS_ASSUME_NONNULL_END
