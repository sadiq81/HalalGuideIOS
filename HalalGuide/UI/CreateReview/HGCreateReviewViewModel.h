//
// Created by Privat on 29/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGBaseViewModel.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "HGReview.h"

@class RACSignal;

@interface HGCreateReviewViewModel : HGBaseViewModel

@property (nonatomic, strong, readonly) HGLocation *location;
@property (nonatomic, strong, readonly) HGReview *createdReview;
@property (nonatomic, strong) NSString *reviewText;
@property (nonatomic, strong) NSNumber *rating;

- (instancetype)initWithReviewedLocation:(HGLocation *)reviewedLocation;

+ (instancetype)modelWithReviewedLocation:(HGLocation *)reviewedLocation;

- (void)saveReview;

@end