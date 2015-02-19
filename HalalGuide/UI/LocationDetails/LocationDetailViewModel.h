//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"
#import "LocationPicture.h"
#import "ReviewDetailViewModel.h"

@interface LocationDetailViewModel : BaseViewModel

@property(nonatomic, retain) Location *location;
@property(nonatomic, readonly) NSArray *locationPictures;
@property(nonatomic, readonly) NSArray *reviews;
@property (nonatomic, readonly) PFUser *user;

@property(nonatomic) NSInteger indexOfSelectedImage;

- (instancetype)initWithLocation:(Location *)aLocation;

+ (instancetype)modelWithLocation:(Location *)location;

- (NSNumber *)averageRating;

- (ReviewDetailViewModel *)getReviewDetailViewModel:(NSUInteger)index;

- (void)report:(UIViewController *)viewController;

- (void)saveMultiplePictures:(NSArray *)images;

@end