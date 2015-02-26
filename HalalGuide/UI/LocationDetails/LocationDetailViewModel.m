//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "LocationDetailViewModel.h"
#import "LocationPicture.h"
#import "PictureService.h"
#import "ErrorReporting.h"
#import "LocationViewModel.h"
#import "ReviewService.h"
#import "AddressService.h"
#import "HalalGuideNumberFormatter.h"


@import MessageUI;

@interface LocationDetailViewModel () {

}
@property(nonatomic, retain) Location *location;
@property(nonatomic) NSArray *locationPictures;
@property(nonatomic) NSArray *reviews;
@property(nonatomic) PFUser *user;

@property(nonatomic, strong) UIImage *thumbnail;
@property(nonatomic, strong) NSString *distance;
@property(nonatomic, strong) NSString *address;
@property(nonatomic, strong) NSString *postalCode;

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
    }];

    [[PictureService instance] thumbnailForLocation:self.location onCompletion:^(NSArray *objects, NSError *error) {
        @strongify(self)
        if (objects != nil && [objects count] == 1) {
            LocationPicture *picture = [objects firstObject];
            [picture.thumbnail getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                self.thumbnail = [[UIImage alloc] initWithData:data];
            }];
        }
    }];

    CLLocationDistance distanceM = [AddressService distanceInMetersToPoint:self.location.location];
    self.distance = [[HalalGuideNumberFormatter instance] stringFromNumber:@(distanceM / 1000)];
    self.address = [NSString stringWithFormat:@"%@ %@", self.location.addressRoad, self.location.addressRoadNumber];
    self.postalCode = [NSString stringWithFormat:@"%@ %@", self.location.addressPostalCode, self.location.addressCity];

    self.locationPictures = [NSArray new];
    self.reviews = [NSArray new];

    self.fetchCount++;
    [[PictureService instance] locationPicturesForLocation:self.location onCompletion:^(NSArray *objects, NSError *error) {
        self.fetchCount--;

        if ((self.error = error)) {
            [[ErrorReporting instance] reportError:error];
        } else {
            self.locationPictures = objects;
        }
    }];

    self.fetchCount++   ;
    [[ReviewService instance] reviewsForLocation:self.location onCompletion:^(NSArray *objects, NSError *error) {
        self.fetchCount--;

        if ((self.error = error)) {
            [[ErrorReporting instance] reportError:error];
        } else {
            self.reviews = objects;
        }
    }];
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
    [[PictureService instance] saveMultiplePictures:images forLocation:self.location completion:^(BOOL completed, NSError *error, NSNumber *progress) {
        @strongify(self)

        self.progress = progress.intValue;
        self.error = error;
        if (completed) {
            self.saving = false;
        }
    }];
}


- (NSNumber *)averageRating {
    if (self.reviews && [self.reviews count] > 0) {

        float average = 0;
        for (Review *review in self.reviews) {
            average += [review.rating floatValue];
        }
        average /= [self.reviews count];
        return @(average);

    } else {
        return nil;
    }
}

- (ReviewDetailViewModel *)getReviewDetailViewModel:(NSUInteger)index {
    return [[ReviewDetailViewModel alloc] initWithReview:[self.reviews objectAtIndex:index]];
}


@end