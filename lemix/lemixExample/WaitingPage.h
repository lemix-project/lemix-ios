//
//  WaitingPage.h
//  lemixExample
//
//  Created by 王炜光 on 2018/10/12.
//  Copyright © 2018 lemix. All rights reserved.
//

#import "BaseViewController.h"
#import "WaitingPageStandard.h"
#import "BaseNavigationViewController.h"
//NS_ASSUME_NONNULL_BEGIN

@interface WaitingPage: BaseViewController<WaitingPageStandard>
@property BaseNavigationViewController *navi;
@end

//NS_ASSUME_NONNULL_END
