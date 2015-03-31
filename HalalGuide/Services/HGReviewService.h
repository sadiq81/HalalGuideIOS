//
// Created by Privat on 15/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
#import "Location.h"
#import "HGSettings.h"
#import "Review.h"

@interface HGReviewService : NSObject
+ (HGReviewService *)instance;

- (void)saveReview:(Review *)review onCompletion:(PFBooleanResultBlock)completion;

- (void)reviewsForLocation:(Location *)location onCompletion:(PFArrayResultBlock)completion;

@end