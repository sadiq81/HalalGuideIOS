//
// Created by Privat on 15/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HalalGuideSettings : NSObject

@property NSUserDefaults *defaults;

+ (HalalGuideSettings *)instance;

- (NSUInteger)distanceFilter;

- (void)setAlcoholFilter:(BOOL)alcohol;

- (BOOL)porkFilter;

- (void)setPorkFilter:(BOOL)pork;

- (NSMutableArray *)categoriesFilter;

- (void)setCategoriesFilter:(NSArray *)categories;

- (NSDate *)locationLastUpdatedAt;

- (void)setLocationsLastUpdatedAt;

- (NSDate *)picturesLastUpdatedAt;

- (void)setPicturesLastUpdatedAt;

- (NSDate *)reviewsLastUpdatedAt;

- (void)setReviewsLastUpdatedAt;

- (void)setDistanceFilter:(NSUInteger)distance;

- (BOOL)halalFilter;

- (void)setHalalFilter:(BOOL)halal;

- (BOOL)alcoholFilter;
@end