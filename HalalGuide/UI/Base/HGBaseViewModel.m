//
//  HGBaseViewModel.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import <Crashlytics/Crashlytics.h>

#import "HGBaseViewModel.h"
#import "HGLocationService.h"
#import "HGReviewService.h"
#import "HGPictureService.h"
#import "HGKeyChainService.h"
#import "HGErrorReporting.h"
#import "PFUser+Extension.h"
#import "UIAlertController+Blocks.h"
#import "UIViewController+Extension.h"
#import "PFUser+Extension.h"
#import "HGLogInViewController.h"
#import "AppDelegate.h"

@implementation HGBaseViewModel {
    UIViewController *presentingViewController;
}


@synthesize saving, progress, fetchCount, error;

- (instancetype)init {
    self = [super init];
    if (self) {
        fetchCount = 0;
    }
    return self;
}

- (BOOL)isAuthenticated {
    return [[HGKeyChainService instance] isAuthenticated];
}

- (void)authenticate:(UIViewController *)viewController {

    HGLogInViewController *logInController = [[HGLogInViewController alloc] init];
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

@end
