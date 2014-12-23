//
// Created by Privat on 15/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Review;
@class UIImage;
@class ProfileInfo;


@interface ReviewDetailViewModel : NSObject

@property (nonatomic) Review *review;

+ (ReviewDetailViewModel *)instance;

@end