//
//  LocolMixModuleInfo.h
//  lemix
//
//  Created by 王炜光 on 2018/10/15.
//  Copyright © 2018 lemix. All rights reserved.
//

#import <Foundation/Foundation.h>

//NS_ASSUME_NONNULL_BEGIN

@interface NativePageInfo : NSObject
/**
 nativePageKey
 */
@property NSString *nativePageKey;
/**
 nativePage Class
 */
@property Class nativePage;
@end

//NS_ASSUME_NONNULL_END
