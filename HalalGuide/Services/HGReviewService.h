//
// Created by Privat on 15/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
#import "HGLocation.h"
#import "HGSettings.h"
#import "HGReview.h"

@interface HGReviewService : NSObject
+ (HGReviewService *)instance;

- (void)reviewById:(NSString *)objectId onCompletion:(PFIdResultBlock)completion;

- (void)saveReview:(HGReview *)review onCompletion:(PFBooleanResultBlock)completion;

- (void)reviewsForLocation:(HGLocation *)location onCompletion:(PFArrayResultBlock)completion;

@end