//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "HGLocationDetailViewModel.h"
#import "HGLocationPicture.h"
#import "HGPictureService.h"
#import "HGErrorReporting.h"
#import "HGLocationViewModel.h"
#import "HGReviewService.h"
#import "HGAddressService.h"
#import "HGNumberFormatter.h"
#import "PFUser+Extension.h"
#import "HGReviewDetailViewModel.h"
#import "HGSmileyScraper.h"

@interface HGLocationDetailViewModel () {

}
@property(nonatomic, retain) HGLocation *location;
@property(nonatomic) NSArray *locationPictures;
@property(nonatomic) NSArray *reviews;
@property(nonatomic) PFUser *user;

@property(nonatomic, strong) NSURL *thumbnail;
@property(nonatomic, strong) NSString *distance;
@property(nonatomic, strong) NSString *address;
@property(nonatomic, strong) NSString *postalCode;

@property(nonatomic) float rating;
@property(nonatomic, strong) NSString *category;

@property(nonatomic, strong) UIImage *porkImage;
@property(nonatomic, strong) NSAttributedString *porkString;
@property(nonatomic, strong) UIImage *alcoholImage;
@property(nonatomic, strong) NSAttributedString *alcoholString;
@property(nonatomic, strong) UIImage *halalImage;
@property(nonatomic, strong) NSAttributedString *halalString;

@property(nonatomic, strong) UIImage *languageImage;
@property(nonatomic, strong) NSString *languageString;

@property(nonatomic, strong) NSURL *submitterImage;
@property(nonatomic, strong) NSString *submitterName;

@property(nonatomic, strong) NSArray *smileys;

@property(nonatomic, strong) NSNumber *favorite;

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
    [[PFUser query] getObjectInBackgroundWithId:self.location.submitterId block:^(PFObject *object, NSError *error) {
        @strongify(self)
        self.user = (PFUser *) object;
        self.submitterName = self.user.facebookName;
        self.submitterImage = self.user.facebookProfileUrlSmall;
    }];

    [[HGPictureService instance] thumbnailForLocation:self.location onCompletion:^(NSArray *objects, NSError *error) {
        @strongify(self)
        if (objects != nil && [objects count] == 1) {
            HGLocationPicture *picture = [objects firstObject];
            self.thumbnail = [[NSURL alloc] initWithString:picture.thumbnail.url];
        }
    }];

    CLLocationDistance distanceM = [HGAddressService distanceInMetersToPoint:self.location.location];
    self.distance = [[HGNumberFormatter instance] stringFromNumber:@(distanceM / 1000)];
    self.address = [[NSString alloc] initWithFormat:@"%@ %@\n%@ %@", self.location.addressRoad, self.location.addressRoadNumber, self.location.addressPostalCode, self.location.addressCity];
    self.postalCode = [NSString stringWithFormat:@"%@ %@", self.location.addressPostalCode, self.location.addressCity];
    self.category = [self.location categoriesString];

    if (self.location.locationType.intValue == LocationTypeDining) {
        self.porkImage = [UIImage imageNamed:self.location.pork.boolValue ? @"HGLocationDetailViewModel.pork.true" : @"HGLocationDetailViewModel.pork.false"];
        self.alcoholImage = [UIImage imageNamed:self.location.alcohol.boolValue ? @"HGLocationDetailViewModel.alcohol.true" : @"HGLocationDetailViewModel.alcohol.false"];
        self.halalImage = [UIImage imageNamed:self.location.nonHalal.boolValue ? @"HGLocationDetailViewModel.non.halal.true" : @"HGLocationDetailViewModel.non.halal.false"];

        self.porkString = [self stringForBool:self.location.pork.boolValue];
        self.alcoholString = [self stringForBool:self.location.alcohol.boolValue];
        self.halalString = [self stringForBool:self.location.nonHalal.boolValue];

    } else if (self.location.locationType.intValue == LocationTypeMosque) {
        self.languageImage = [UIImage imageNamed:LanguageString([self.location.language integerValue])];
        self.languageString = [self.location.language integerValue] != 0 ? NSLocalizedString(LanguageString([self.location.language integerValue]), nil) : @"";
    }

        self.favorite = @([[HGSettings instance].favorites containsObject:self.location.objectId]);

    self.locationPictures = [NSArray new];
    self.reviews = [NSArray new];

    self.fetchCount++;
    [[HGPictureService instance] locationPicturesForLocation:self.location onCompletion:^(NSArray *objects, NSError *error) {
        self.fetchCount--;

        if ((self.error = error)) {
            [[HGErrorReporting instance] reportError:error];
        } else {
            self.locationPictures = objects;
        }
    }];

    self.fetchCount++;
    [[HGReviewService instance] reviewsForLocation:self.location onCompletion:^(NSArray *objects, NSError *error) {
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
        self.fetchCount--;
        self.smileys = smileys;
    }];
}

//TODO Graphical elements should not be in view model

- (NSMutableAttributedString *)stringForBool:(BOOL)value {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:value ? NSLocalizedString(@"HGLocationDetailViewModel.yes", nil) : NSLocalizedString(@"HGLocationDetailViewModel.no", nil)];
    [string addAttribute:NSForegroundColorAttributeName value:value ? [UIColor redColor] : [UIColor greenColor] range:NSMakeRange(0, [string.mutableString length])];
    return string;
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

-(void) setFavorised:(BOOL) favorized{

    [PFAnalytics trackEvent:@"Favorised" dimensions:@{@"favorized":@(favorized).stringValue, @"Location":self.location.objectId}];

    if (favorized){
        NSMutableArray *favorites = [HGSettings instance].favorites;
        [favorites addObject:self.location.objectId];
        [HGSettings instance].favorites = favorites;

        [self.location pinInBackgroundWithName:kFavoritesPin];

    } else{
        NSMutableArray *favorites = [HGSettings instance].favorites;
        [favorites removeObject:self.location.objectId];
        [HGSettings instance].favorites = favorites;

        [self.location unpinInBackgroundWithName:kFavoritesPin];

    }
}

- (HGReviewDetailViewModel *)getReviewDetailViewModel:(NSUInteger)index {
    return [[HGReviewDetailViewModel alloc] initWithReview:[self.reviews objectAtIndex:index]];
}


@end