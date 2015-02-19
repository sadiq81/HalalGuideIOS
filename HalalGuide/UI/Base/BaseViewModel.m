//
//  BaseViewModel.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import <Crashlytics/Crashlytics.h>

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
#import "AppDelegate.h"

static CLLocation *currentLocation;

@implementation BaseViewModel {
    UIViewController *presentingViewController;
}


@synthesize saving, progress, fetchCount, userLocation, error;

- (instancetype)init {
    self = [super init];
    if (self) {
        userLocation = ((AppDelegate *) [UIApplication sharedApplication].delegate).locationManager.location;
        fetchCount = 0;
    }
    return self;
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
        [Crashlytics setUserIdentifier:user.objectId];
        [Crashlytics setUserName:user.facebookName];

        if (user.isNew) {
            [PFUser storeProfileInfoForLoggedInUser:nil];
        }

        UIAlertController *errorController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ok", nil) message:NSLocalizedString(@"authenticateSuccessfull", nil) preferredStyle:UIAlertControllerStyleAlert];
        [errorController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleCancel handler:nil]];
        [presentingViewController presentViewController:errorController animated:true completion:nil];

    }];
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    [presentingViewController dismissViewControllerAnimated:true completion:^{
        UIAlertController *errorController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"error", nil) message:NSLocalizedString(@"errorText", nil) preferredStyle:UIAlertControllerStyleAlert];
        [errorController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleCancel handler:nil]];
        [presentingViewController presentViewController:errorController animated:true completion:nil];
    }];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [presentingViewController dismissViewControllerAnimated:true completion:^{
        UIAlertController *errorController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"warning", nil) message:NSLocalizedString(@"authenticateText", nil) preferredStyle:UIAlertControllerStyleAlert];
        [errorController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleCancel handler:nil]];
    }];
}


- (void)getPictures:(UIViewController <UINavigationControllerDelegate> *)viewController {

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


@end
