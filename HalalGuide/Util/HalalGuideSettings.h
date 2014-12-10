//
// Created by Privat on 15/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HalalGuideSettings : NSObject

@property NSUserDefaults *defaults;

+ (HalalGuideSettings *)instance;

- (NSDate *)locationLastUpdatedAt;

- (void)setLocationsLastUpdatedAt;

- (NSDate *)picturesLastUpdatedAt;

- (void)setPicturesLastUpdatedAt;

- (NSDate *)reviewsLastUpdatedAt;

- (void)setReviewsLastUpdatedAt;

@end