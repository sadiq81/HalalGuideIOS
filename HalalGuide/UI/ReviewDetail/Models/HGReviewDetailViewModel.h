//
// Created by Privat on 15/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGReview.h"

@interface HGReviewDetailViewModel : NSObject

@property(strong, nonatomic, readonly) HGReview *review;
@property(strong, nonatomic, readonly) NSURL *submitterImage;
@property(strong, nonatomic, readonly) NSURL *submitterImageLarge;
@property(strong, nonatomic, readonly) NSString *submitterName;
@property(strong, nonatomic, readonly) NSNumber *rating;
@property(strong, nonatomic, readonly) NSString *reviewText;
@property(strong, nonatomic, readonly) NSString *date;

@property(strong, nonatomic, readonly) NSArray *reviewImages;

- (instancetype)initWithReview:(HGReview *)review;

+ (instancetype)modelWithReview:(HGReview *)review;


@end