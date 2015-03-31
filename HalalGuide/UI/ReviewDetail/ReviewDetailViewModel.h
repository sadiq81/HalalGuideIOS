//
// Created by Privat on 15/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Review.h"

@interface ReviewDetailViewModel : NSObject

@property(strong, nonatomic, readonly) UIImage *submitterImage;
@property(strong, nonatomic, readonly) UIImage *submitterImageLarge;
@property(strong, nonatomic, readonly) NSString *submitterName;
@property(strong, nonatomic, readonly) NSNumber *rating;
@property(strong, nonatomic, readonly) NSString *reviewText;
@property(strong, nonatomic, readonly) NSString *date;

- (instancetype)initWithReview:(Review *)review;

+ (instancetype)modelWithReview:(Review *)review;


@end