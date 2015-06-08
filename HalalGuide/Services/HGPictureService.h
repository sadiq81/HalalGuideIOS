//
// Created by Privat on 15/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
#import "HGLocation.h"
#import "HGSettings.h"
#import "HGReview.h"

@class HGLocationPicture;
@class BFTask;

@interface HGPictureService : NSObject

+ (HGPictureService *)instance;

- (void)saveMultiplePictures:(NSArray *)images forLocation:(HGLocation *)location completion:(void (^)(BOOL completed, NSError *error, NSNumber *progress))completion;

- (void)saveMultiplePictures:(NSArray *)images forReview:(HGReview *)review completion:(void (^)(BOOL completed, NSError *error, NSNumber *progress))completion;

//- (void)locationPicturesByQuery:(PFQuery *)query onCompletion:(PFArrayResultBlock)completion;

- (void)locationPicturesForLocation:(HGLocation *)location onCompletion:(PFArrayResultBlock)completion;

- (void)locationPicturesForReview:(HGReview *)review onCompletion:(PFArrayResultBlock)completion;

- (void)thumbnailForLocation:(HGLocation *)location onCompletion:(PFArrayResultBlock)completion;


@end