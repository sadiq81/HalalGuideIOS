//
// Created by Privat on 29/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGBaseViewModel.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "Review.h"

@class RACSignal;

@interface CreateReviewViewModel : HGBaseViewModel

@property (nonatomic, strong, readonly) Location *location;
@property (nonatomic, strong, readonly) Review *createdReview;
@property (nonatomic, strong) NSString *reviewText;
@property (nonatomic, strong) NSNumber *rating;

- (instancetype)initWithReviewedLocation:(Location *)reviewedLocation;

+ (instancetype)modelWithReviewedLocation:(Location *)reviewedLocation;

- (void)saveReview;

@end