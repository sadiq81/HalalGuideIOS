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

- (void)authenticate:(UIViewController *)viewController onCompletion:(PFBooleanResultBlock)completion {

    [UIAlertController showAlertInViewController:viewController
                                       withTitle:NSLocalizedString(@"authenticate", nil)
                                         message:NSLocalizedString(@"authenticateText", nil)
                               cancelButtonTitle:NSLocalizedString(@"regret", nil)
                          destructiveButtonTitle:nil
                               otherButtonTitles:@[NSLocalizedString(@"ok", nil)]
                                        tapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex) {

                                            if (buttonIndex == controller.firstOtherButtonIndex) {

                                                [SVProgressHUD showWithStatus:NSLocalizedString(@"loggingIn", nil) maskType:SVProgressHUDMaskTypeGradient];

                                                NSArray *permissionsArray = @[@"public_profile"];
                                                [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {

                                                    [SVProgressHUD dismiss];

                                                    if (!error) {

                                                        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                                                        currentInstallation[@"user"] = [PFUser currentUser];
                                                        [currentInstallation saveEventually];

                                                        completion(true, error);

                                                    }
                                                    else if (error && [[error.userInfo objectForKey:@"com.facebook.sdk:HTTPStatusCode"] isEqual:@"400"]) {
                                                        [PFUser logOut];
                                                        completion(false, error);
                                                    } else {
                                                        completion(false, error);
                                                    }
                                                }];
                                            }
                                        }];
}

- (void)getPicture:(UIViewController <UINavigationControllerDelegate> *)viewController {

    if (![self isAuthenticated]) {
        [self authenticate:viewController onCompletion:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [self getPicture:viewController];
            } else {
                [[UIAlertController alertControllerWithTitle:NSLocalizedString(@"error", error.localizedDescription) message:nil preferredStyle:UIAlertControllerStyleAlert] showViewController:viewController sender:self];
            }
        }];
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

- (void)savePicture:(UIImage *)image forLocation:(Location *)location showFeedback:(BOOL)show onCompletion:(void (^)(CreateEntityResult result))completion {

    [SVProgressHUD showWithStatus:NSLocalizedString(@"savingToTheCloud", nil) maskType:SVProgressHUDMaskTypeGradient];

    [[PictureService instance] savePicture:image forLocation:location onCompletion:^(BOOL succeeded, NSError *error) {

        [SVProgressHUD dismiss];

        if (error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(CreateEntityResultString(CreateEntityResultCouldNotUploadFile), nil) maskType:SVProgressHUDMaskTypeGradient];
            [[ErrorReporting instance] reportError:error];
            completion(CreateEntityResultCouldNotUploadFile);
        } else {

            if (show) {
                [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"imageSaved", nil)];
            }
            completion(CreateEntityResultOk);
        }
    }];
}

- (void)saveMultiplePictures:(NSArray *)images forLocation:(Location *)location showFeedback:(BOOL)show onCompletion:(void (^)(CreateEntityResult result))completion {

    [SVProgressHUD showWithStatus:NSLocalizedString(@"savingToTheCloud", nil) maskType:SVProgressHUDMaskTypeGradient];

    [[PictureService instance] saveMultiplePictures:images forLocation:location onCompletion:^(BOOL succeeded, NSError *error) {

        [SVProgressHUD dismiss];

        if (error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(CreateEntityResultString(CreateEntityResultCouldNotUploadFile), nil) maskType:SVProgressHUDMaskTypeGradient];
            [[ErrorReporting instance] reportError:error];

            if (completion) {
                completion(CreateEntityResultCouldNotUploadFile);
            }

        } else {
            if (show) {
                [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"imageSaved", nil)];
            }
            if (completion) {
                completion(CreateEntityResultOk);
            }
        }
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
