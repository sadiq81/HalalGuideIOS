//
// Created by Privat on 15/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#define kLocationsLastUpdatedKey @"locationsLastupdated"
#define kPicturesLastUpdatedKey @"picturesLastupdated"
#define kReviewsLastUpdatedKey @"reviewsLastupdated"

#define kDistanceFilterKey @"distanceFilter"
#define kHalalFilterKey @"halalFilter"
#define kAlcoholFilterKey @"alcoholFilter"
#define kPorkFilterKey @"porkFilter"
#define kCategoriesFilterKey @"categoriesFilter"
#define kShopCategoriesFilterKey @"shopCategoriesFilter"

#import "HGSettings.h"

@implementation HGSettings {

}

@synthesize defaults;

+ (HGSettings *)instance {
    static HGSettings *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
            _instance.defaults = [NSUserDefaults standardUserDefaults];
        }
    }

    return _instance;
}

- (NSUInteger)distanceFilter {
    NSUInteger distance = [self.defaults integerForKey:kDistanceFilterKey];

    if (distance == 0){
        distance = 5;
        [self setDistanceFilter:distance];
    }

    return distance;
}

- (void)setDistanceFilter:(NSUInteger)distance {
    [self.defaults setInteger:distance forKey:kDistanceFilterKey];
}

- (BOOL)halalFilter {
    BOOL halal = [self.defaults boolForKey:kHalalFilterKey];
    return halal;
}

- (void)setHalalFilter:(BOOL)halal {
    [self.defaults setBool:halal forKey:kHalalFilterKey];
}

- (BOOL)alcoholFilter {
    BOOL alcohol = [self.defaults boolForKey:kAlcoholFilterKey];
    return alcohol;
}

- (void)setAlcoholFilter:(BOOL)alcohol {
    [self.defaults setBool:alcohol forKey:kAlcoholFilterKey];
}

- (BOOL)porkFilter {
    BOOL pork = [self.defaults boolForKey:kPorkFilterKey];
    return pork;
}

- (void)setPorkFilter:(BOOL)pork {
    [self.defaults setBool:pork forKey:kPorkFilterKey];
}

- (NSMutableArray *)categoriesFilter {
    NSArray *categories = [self.defaults arrayForKey:kCategoriesFilterKey];
    NSMutableArray *mutableCategories = [[NSMutableArray alloc] initWithArray:categories];
    return mutableCategories;
}

- (void)setCategoriesFilter:(NSArray *)categories {
    [self.defaults setObject:categories forKey:kCategoriesFilterKey];
}

- (NSMutableArray *)shopCategoriesFilter {
    NSArray *categories = [self.defaults arrayForKey:kCategoriesFilterKey];
    NSMutableArray *mutableCategories = [[NSMutableArray alloc] initWithArray:categories];
    return mutableCategories;
}

- (void)setShopCategoriesFilter:(NSArray *)shopCategories {
    [self.defaults setObject:shopCategories forKey:kShopCategoriesFilterKey];
}

- (NSDate *)locationLastUpdatedAt {
    NSDate *lastUpdatedAt = [self.defaults valueForKey:kLocationsLastUpdatedKey];
    if (!lastUpdatedAt) {
        lastUpdatedAt = [NSDate dateWithTimeIntervalSince1970:0];
    }
    return lastUpdatedAt;
}

- (void)setLocationsLastUpdatedAt {
    [self.defaults setValue:[NSDate dateWithTimeIntervalSinceNow:0] forKey:kLocationsLastUpdatedKey];
}

- (NSDate *)picturesLastUpdatedAt {
    NSDate *lastUpdatedAt = [self.defaults valueForKey:kPicturesLastUpdatedKey];
    if (!lastUpdatedAt) {
        lastUpdatedAt = [NSDate dateWithTimeIntervalSince1970:0];
    }
    return lastUpdatedAt;
}

- (void)setPicturesLastUpdatedAt {
    [self.defaults setValue:[NSDate dateWithTimeIntervalSinceNow:0] forKey:kPicturesLastUpdatedKey];
}

- (NSDate *)reviewsLastUpdatedAt {
    NSDate *lastUpdatedAt = [self.defaults valueForKey:kReviewsLastUpdatedKey];
    if (!lastUpdatedAt) {
        lastUpdatedAt = [NSDate dateWithTimeIntervalSince1970:0];
    }
    return lastUpdatedAt;
}

- (void)setReviewsLastUpdatedAt {
    [self.defaults setValue:[NSDate dateWithTimeIntervalSinceNow:0] forKey:kReviewsLastUpdatedKey];
}
@end