//
// Created by Privat on 15/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
#import "Location.h"
#import "HalalGuideSettings.h"
#import "Review.h"

@class ProfileInfo;

@interface ProfileInfoService : NSObject

+ (ProfileInfoService *)instance;

- (void)saveProfileInfo:(ProfileInfo *)info onCompletion:(PFBooleanResultBlock)completion;

- (void)profileInfoForSubmitter:(NSString *)submitter onCompletion:(void (^)(ProfileInfo *info))completion;

@end