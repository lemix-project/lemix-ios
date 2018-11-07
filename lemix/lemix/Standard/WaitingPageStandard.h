//
//  WatingPageStandard.h
//  lemix
//
//  Created by 王炜光 on 2018/10/12.
//  Copyright © 2018 lemix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixModuleInfo.h"
//NS_ASSUME_NONNULL_BEGIN

@protocol WaitingPageStandard <NSObject>
- (void)onWaiting:(MixModuleInfo *)moduleInfo;
@end

//NS_ASSUME_NONNULL_END
