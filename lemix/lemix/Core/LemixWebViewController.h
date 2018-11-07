//
//  LemixWebViewController.h
//  lemix
//
//  Created by 王炜光 on 2018/10/16.
//  Copyright © 2018 lemix. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>
//NS_ASSUME_NONNULL_BEGIN

@interface LemixWebViewController : BaseViewController
@property WKWebView *webView;
@property NSString *urlStr;
@property NSDictionary *webProgram;
@property NSString *aimStr;
@end

//NS_ASSUME_NONNULL_END
