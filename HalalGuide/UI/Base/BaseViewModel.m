//
//  BaseViewModel.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <CTAssetsPickerController/CTAssetsPickerController.h>

#import "BaseViewModel.h"
#import "LocationService.h"
#import "ReviewService.h"
#import "PictureService.h"
#import "KeyChainService.h"
#import "ErrorReporting.h"
#import "PFUser+Extension.h"
#import "UIAlertController+Blocks.h"
#import "UIViewController+Extension.h"
#import "PFUser+Extension.h"
#import "HalalLogInViewController.h"

static CLLocation *currentLocation;

@implementation BaseViewModel {
    UIViewController *presentingViewController;
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

- (void)authenticate:(UIViewController *)viewController {

    HalalLogInViewController *logInController = [[HalalLogInViewController alloc] init];
    logInController.delegate = self;
    logInController.fields = (PFLogInFieldsFacebook | PFLogInFieldsDismissButton);
    logInController.facebookPermissions = @[@"public_profile"];
    [presentingViewController = viewController presentViewController:logInController animated:true completion:nil];
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {

    [presentingViewController dismissViewControllerAnimated:true completion:^{

        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        currentInstallation[@"user"] = user;
        [currentInstallation saveInBackground];

        if (user.isNew) {
            [PFUser storeProfileInfoForLoggedInUser:nil];
        }

        UIAlertController *error = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ok", nil) message:NSLocalizedString(@"authenticateSuccessfull", nil) preferredStyle:UIAlertControllerStyleAlert];
        [error addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleCancel handler:nil]];
        [presentingViewController presentViewController:error animated:true completion:nil];

    }];
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    [presentingViewController dismissViewControllerAnimated:true completion:^{
        UIAlertController *error = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"error", nil) message:NSLocalizedString(@"errorText", nil) preferredStyle:UIAlertControllerStyleAlert];
        [error addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleCancel handler:nil]];
        [presentingViewController presentViewController:error animated:true completion:nil];
    }];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [presentingViewController dismissViewControllerAnimated:true completion:^{
        UIAlertController *error = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"warning", nil) message:NSLocalizedString(@"authenticateText", nil) preferredStyle:UIAlertControllerStyleAlert];
        [error addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleCancel handler:nil]];
    }];
}


- (void)getPicture:(UIViewController <UINavigationControllerDelegate> *)viewController {

    if (![self isAuthenticated]) {
        [self authenticate:viewController];
        return;
    }

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"addPicture", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *takeImage = [UIAlertAction actionWithTitle:NSLocalizedString(@"newPicture", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = viewController;
        imagePickerController.showsCameraControls = true;
        [viewController presentViewController:imagePickerController animated:YES completion:nil];
    }];

    UIAlertAction *chooseImage = [UIAlertAction actionWithTitle:NSLocalizedString(@"choosePicture", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.title = NSLocalizedString(@"choosePicture", nil);
        picker.delegate = viewController;
        [viewController presentViewController:picker animated:YES completion:nil];
    }];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"regret", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];

    [alertController addAction:takeImage];
    [alertController addAction:chooseImage];
    [alertController addAction:cancel];

    [viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)savePicture:(UIImage *)image forLocation:(Location *)location {

    [[PictureService instance] savePicture:image forLocation:location];

    [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"imageSaved", nil)];

}

- (void)saveMultiplePictures:(NSArray *)images forLocation:(Location *)location {

    [[PictureService instance] saveMultiplePictures:images forLocation:location];

    [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"imagesSaved", nil)];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
