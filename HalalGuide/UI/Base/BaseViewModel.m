//
//  BaseViewModel.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "BaseViewModel.h"
#import "LocationService.h"
#import "ReviewService.h"
#import "PictureService.h"
#import "KeyChainService.h"
#import "ErrorReporting.h"
#import "PFUser+Extension.h"

static CLLocation *currentLocation;

@implementation BaseViewModel {
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChanged:) name:kCLLocationManagerDidUpdateLocations object:nil];
#if (TARGET_IPHONE_SIMULATOR)
        [BaseViewModel setLocation:[[CLLocation alloc] initWithLatitude:55.690500f longitude: 12.542347f]];
#endif
    }
    return self;
}

+ (CLLocation *)currentLocation {
    return currentLocation;
}

+ (void)setLocation:(CLLocation *)location {
    currentLocation = location;
}

- (void)locationChanged:(NSNotification *)notification {
    CLLocation *location = [notification.userInfo objectForKey:kCurrentLocation];
    [BaseViewModel setLocation:location];
}


- (NSArray *)calculateDistances:(NSArray *)locations sortByDistance:(BOOL)sort {

    if ([BaseViewModel currentLocation]) {
        for (Location *loc in locations) {

            double latitude = loc.point.latitude;
            double longitude = loc.point.longitude;

            CLLocation *locLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];

            if (locLocation) {
                double distance = [locLocation distanceFromLocation:[BaseViewModel currentLocation]] / 1000;
                loc.distance = @(distance);
            }
        }

        if (sort) {
            NSArray *sorted = [locations linq_sort:^id(Location *loc) {
                return loc.distance;
            }];
            return sorted;
        }
    }
    return locations;
}

- (BOOL)isAuthenticated {
    return [[KeyChainService instance] isAuthenticated];
}

- (void)authenticate:(PFBooleanResultBlock)completion {

    [PFFacebookUtils logInWithPermissions:nil block:^(PFUser *user, NSError *error) {
        if (user.isNew && !error) {
            [PFUser storeProfileInfoForLoggedInUser:completion];
        } else {
            completion(true, error);
        }
    }];
}

- (void)getPicture:(UIViewController *)viewController withDelegate:(id <UIImagePickerControllerDelegate>)delegate {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"addPicture", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *takeImage = [UIAlertAction actionWithTitle:NSLocalizedString(@"newPicture", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        pickImageBlock(delegate, viewController, UIImagePickerControllerSourceTypeCamera);
    }];
    UIAlertAction *chooseImage = [UIAlertAction actionWithTitle:NSLocalizedString(@"choosePicture", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        pickImageBlock(delegate, viewController, UIImagePickerControllerSourceTypePhotoLibrary);
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"regret", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];

    [alertController addAction:takeImage];
    [alertController addAction:chooseImage];
    [alertController addAction:cancel];

    [viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
