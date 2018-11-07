//
//  LemixNavigationController.h
//  lemix
//
//  Created by 王炜光 on 2018/10/12.
//  Copyright © 2018 lemix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LemixEngine.h"
//NS_ASSUME_NONNULL_BEGIN

@interface BaseNavigationViewController : UINavigationController
@property LemixEngine *lemixEngine;
@property NSString *instanceKey;
@end

//NS_ASSUME_NONNULL_END
