//
//  LemageUsageText.h
//  lemage
//
//  Created by 1iURI on 2018/6/21.
//  Copyright © 2018年 LemonIT.CN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LemageUsageText : NSObject

@property NSString *complete;
@property NSString *cancel;
@property NSString *back;
@property NSString *preview;
@property NSString *originalImage;
@property NSString *allImages;
@property NSString *noImages;
@property NSString *tipSelectedCount;
@property NSString *selectedType;
@property NSString *photoTip;
@property NSString *onlyVideo;
+ (LemageUsageText *)cnText;
+ (LemageUsageText *)enText;

@end

