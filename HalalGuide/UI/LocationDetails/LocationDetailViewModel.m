//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "LocationDetailViewModel.h"
#import "LocationPicture.h"
#import "HGPictureService.h"
#import "HGErrorReporting.h"
#import "LocationViewModel.h"
#import "HGReviewService.h"
#import "HGAddressService.h"
#import "HGNumberFormatter.h"
#import "PFUser+Extension.h"


@import MessageUI;

@interface LocationDetailViewModel () {

}
@property(nonatomic, retain) Location *location;
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

@end

@implementation LocationDetailViewModel {

}

- (instancetype)initWithLocation:(Location *)location {
    self = [super init];
    if (self) {
        self.location = location;
        [self setup];
    }

    return self;
}

+ (instancetype)modelWithLocation:(Location *)location {
    return [[self alloc] initWithLocation:location];
}

- (void)setup {
    self.locationPictures = [NSArray new];
    self.reviews = [NSArray new];

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
            LocationPicture *picture = [objects firstObject];
            self.thumbnail = [[NSURL alloc] initWithString:picture.thumbnail.url];
        }
    }];

    CLLocationDistance distanceM = [HGAddressService distanceInMetersToPoint:self.location.location];
    self.distance = [[HGNumberFormatter instance] stringFromNumber:@(distanceM / 1000)];
    self.address = [[NSString alloc] initWithFormat:@"%@ %@\n%@ %@", self.location.addressRoad, self.location.addressRoadNumber, self.location.addressPostalCode, self.location.addressCity];
    self.postalCode = [NSString stringWithFormat:@"%@ %@", self.location.addressPostalCode, self.location.addressCity];
    self.category = [self.location categoriesString];

    if (self.location.locationType.intValue == LocationTypeDining) {
        self.porkImage = [UIImage imageNamed:self.location.pork.boolValue ? @"DiningCell.pork.true" : @"DiningCell.pork.false"];
        self.alcoholImage = [UIImage imageNamed:self.location.alcohol.boolValue ? @"DiningCell.alcohol.true" : @"DiningCell.alcohol.false"];
        self.halalImage = [UIImage imageNamed:self.location.nonHalal.boolValue ? @"DiningCell.non.halal.true" : @"DiningCell.non.halal.false"];

        self.porkString = [self stringForBool:self.location.pork.boolValue];
        self.alcoholString = [self stringForBool:self.location.alcohol.boolValue];
        self.halalString = [self stringForBool:self.location.nonHalal.boolValue];

    } else if (self.location.locationType.intValue == LocationTypeMosque) {
        self.languageImage = [UIImage imageNamed:LanguageString([self.location.language integerValue])];
        self.languageString = [self.location.language integerValue] != 0 ? NSLocalizedString(LanguageString([self.location.language integerValue]), nil) : @"";
    }

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


}

- (NSMutableAttributedString *)stringForBool:(BOOL)value {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:value ? NSLocalizedString(@"yes", nil) : NSLocalizedString(@"no", nil)];
    [string addAttribute:NSForegroundColorAttributeName value:value ? [UIColor redColor] : [UIColor greenColor] range:NSMakeRange(0, [string.mutableString length])];
    return string;
}

- (void)report:(UIViewController <MFMailComposeViewControllerDelegate> *)viewController {

    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    [mailController setToRecipients:@[@"tommy@eazyit.dk"]];
    [mailController setSubject:[NSString stringWithFormat:@"%@", self.location.objectId]];
    [mailController setMessageBody:NSLocalizedString(@"errorMailText", nil) isHTML:false];
    mailController.mailComposeDelegate = viewController;
    [viewController presentViewController:mailController animated:true completion:nil];

}

- (void)saveMultiplePictures:(NSArray *)images {
    self.saving = true;
    self.progress = 1;

    @weakify(self)
    [[HGPictureService instance] saveMultiplePictures:images forLocation:self.location completion:^(BOOL completed, NSError *error, NSNumber *progress) {
        @strongify(self)

        self.progress = progress.intValue;
        self.error = error;
        if (completed) {
            self.saving = false;
        }
    }];
}


- (void)calculateAverageRating {
    if (self.reviews && [self.reviews count] > 0) {
        float average = 0;
        for (Review *review in self.reviews) {
            average += [review.rating floatValue];
        }
        self.rating = average / [self.reviews count];
    }
}

- (ReviewDetailViewModel *)getReviewDetailViewModel:(NSUInteger)index {
    return [[ReviewDetailViewModel alloc] initWithReview:[self.reviews objectAtIndex:index]];
}


@end