//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "HGLocationDetailViewModel.h"
#import "HGPictureService.h"
#import "HGErrorReporting.h"
#import "HGLocationViewModel.h"
#import "HGReviewService.h"
#import "HGAddressService.h"
#import "HGNumberFormatter.h"
#import "HGSmileyScraper.h"
#import "HGUser.h"
#import "HGUserService.h"
#import "NSString+Extensions.h"
#import "HGGeoLocationService.h"

@interface HGLocationDetailViewModel () {

}
@property(nonatomic, retain) HGLocation *location;
@property(nonatomic, copy) NSArray *locationPictures;
@property(nonatomic, copy) NSArray *reviews;
@property(nonatomic, retain) HGUser *user;

@property(nonatomic, copy) NSURL *thumbnail;
@property(nonatomic, copy) NSString *distance;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *postalCode;

@property(nonatomic) float rating;
@property(nonatomic, copy) NSString *category;

@property(nonatomic, copy) UIImage *porkImage;
@property(nonatomic, copy) UIImage *alcoholImage;
@property(nonatomic, copy) UIImage *halalImage;

@property(nonatomic, copy) UIImage *languageImage;
@property(nonatomic, copy) NSString *languageString;

@property(nonatomic, copy) NSURL *submitterImage;
@property(nonatomic, copy) NSString *submitterName;

@property(nonatomic, copy) NSArray *smileys;

@property(nonatomic, copy) NSNumber *favorite;

@end

@implementation HGLocationDetailViewModel {

}

- (instancetype)initWithLocation:(HGLocation *)location {
    self = [super init];
    if (self) {
        self.location = location;

        [self setup];
    }

    return self;
}

+ (instancetype)modelWithLocation:(HGLocation *)location {
    return [[self alloc] initWithLocation:location];
}

- (void)setup {
    self.locationPictures = [NSArray new];
    self.reviews = [NSArray new];

    self.smileys = [NSArray new];

    @weakify(self)
    [[HGUserService instance] getUserInBackGround:self.location.submitterId onCompletion:^(PFObject *object, NSError *error) {
        @strongify(self)
        self.user = (HGUser *) object;
        self.submitterName = self.user.facebookName;
        self.submitterImage = self.user.facebookProfileUrlSmall;
    }];

    [[HGPictureService instance] thumbnailForLocation:self.location onCompletion:^(NSArray *objects, NSError *error) {
        @strongify(self)
        if (objects != nil && [objects count] == 1) {
            HGLocationPicture *picture = [objects firstObject];
            self.thumbnail = [picture.thumbnail.url toURL];
        }
    }];

    [self updateDistance];

    self.address = [[NSString alloc] initWithFormat:@"%@ %@\n%@ %@", self.location.addressRoad, self.location.addressRoadNumber, self.location.addressPostalCode, self.location.addressCity];
    self.postalCode = [NSString stringWithFormat:@"%@ %@", self.location.addressPostalCode, self.location.addressCity];
    self.category = [self.location categoriesString];

    if (self.location.locationType.intValue == LocationTypeDining) {
        self.porkImage = self.location.pork.boolValue ? [[UIImage imageNamed:@"HGLocationDetailViewModel.pork.true"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] : nil;
        self.alcoholImage = self.location.alcohol.boolValue ? [[UIImage imageNamed:@"HGLocationDetailViewModel.alcohol.true"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] : nil;
        self.halalImage = self.location.nonHalal.boolValue ? [[UIImage imageNamed:@"HGLocationDetailViewModel.non.halal.true"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] : nil;
    } else if (self.location.locationType.intValue == LocationTypeMosque) {
        self.languageImage = [UIImage imageNamed:LanguageString([self.location.language integerValue])];
        self.languageString = [self.location.language integerValue] != 0 ? NSLocalizedString(LanguageString([self.location.language integerValue]), nil) : @"";
    }

    self.favorite = @([[HGSettings instance].favorites containsObject:self.location.objectId]);

    self.locationPictures = [NSArray new];
    self.reviews = [NSArray new];

    self.fetchCount++;
    [[HGPictureService instance] locationPicturesForLocation:self.location onCompletion:^(NSArray *objects, NSError *error) {
        @strongify(self)
        self.fetchCount--;

        if ((self.error = error)) {
            [[HGErrorReporting instance] reportError:error];
        } else {
            self.locationPictures = objects;
        }
    }];

    self.fetchCount++;
    [[HGReviewService instance] reviewsForLocation:self.location onCompletion:^(NSArray *objects, NSError *error) {
        @strongify(self)
        self.fetchCount--;

        if ((self.error = error)) {
            [[HGErrorReporting instance] reportError:error];
        } else {
            self.reviews = objects;
            [self calculateAverageRating];
        }
    }];

    self.fetchCount++;

    [HGSmileyScraper smileyLinksForLocation:self.location onCompletion:^(NSArray *smileys) {
        @strongify(self)
        self.fetchCount--;
        self.smileys = smileys;
    }];

    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:locationManagerDidUpdateLocationsNotification object:nil] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(id x) {
        @strongify(self)
        [self updateDistance];
    }];
}

- (void)updateDistance {
    CLLocationDistance distanceM = [[HGGeoLocationService instance].currentLocation distanceFromLocation:self.location.location];
    self.distance = [[HGNumberFormatter instance] stringFromNumber:@(distanceM / 1000)];
}

- (void)saveMultiplePictures:(NSArray *)images {

    self.progress = 1;
    @weakify(self)
    [[HGPictureService instance] saveMultiplePictures:images forLocation:self.location completion:^(BOOL completed, NSError *error, NSNumber *progress) {
        @strongify(self)

        self.progress = progress.intValue;
        self.error = error;
        if (completed) {
            self.progress = 100;
        }
    }];
}


- (void)calculateAverageRating {
    if (self.reviews && [self.reviews count] > 0) {
        float average = 0;
        for (HGReview *review in self.reviews) {
            average += [review.rating floatValue];
        }
        self.rating = average / [self.reviews count];
    }
}

- (void)setFavorised:(BOOL)favorized {

    [PFAnalytics trackEvent:@"Favorised" dimensions:@{@"favorized" : @(favorized).stringValue, @"Location" : self.location.objectId}];

    if (favorized) {
        NSMutableArray *favorites = [HGSettings instance].favorites;
        [favorites addObject:self.location.objectId];
        [HGSettings instance].favorites = favorites;

        [self.location pinInBackgroundWithName:kFavoritesPin];

    } else {
        NSMutableArray *favorites = [HGSettings instance].favorites;
        [favorites removeObject:self.location.objectId];
        [HGSettings instance].favorites = favorites;

        [self.location unpinInBackgroundWithName:kFavoritesPin];

    }
}

- (HGReviewDetailViewModel *)getReviewDetailViewModel:(NSUInteger)index {
    return [[HGReviewDetailViewModel alloc] initWithReview:self.reviews[index]];
}


@end