//
// Created by Privat on 15/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Review.h"

@interface ReviewDetailViewModel : NSObject

@property (nonatomic, readonly) Review *review;

- (instancetype)initWithReview:(Review *)review;

+ (instancetype)modelWithReview:(Review *)review;


@end