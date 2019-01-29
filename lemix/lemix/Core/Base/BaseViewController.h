//
//  BaseViewController.h
//  lemix
//
//  Created by 王炜光 on 2018/10/15.
//  Copyright © 2018 lemix. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef void(^responce)(NSDictionary *);
#import <WebKit/WebKit.h>
typedef void(^webBlock)(WKWebView*);

//NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController
@property UINavigationBar *navigationBar;
@property UIImageView *navigationBarBGView;
@property UILabel *titleLabel;
@property UIButton *backBtn;
//@property responce responce;
@property BOOL statusBarHidden;
@property NSDictionary *configDic;
@property NSString *json;
/**
 navigationbar状态
 
 @param isHidden 是否隐藏
 */
- (void)onNavigationHiddenStatusChange:(BOOL)isHidden;
/**
 navigationbar颜色
 
 @param color 颜色
 */
- (void)onNavigationBarColorChange:(UIColor *)color;
/**
 设置title
 
 @param title title
 */
- (void)onNavigationTitleChange:(NSString *)title;
/**
 navigationitem颜色
 
 @param color 颜色
 */
- (void)onNavigationItemColorChange:(UIColor *)color;
- (void)forceOrientationChange:(NSString *)direction;

- (void)onClose;
- (void)showTip:(NSString *)title;
@property(nonatomic, copy)webBlock webOnShow;

@end

//NS_ASSUME_NONNULL_END
