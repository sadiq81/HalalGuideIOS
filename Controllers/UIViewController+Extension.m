//
// Created by Privat on 12/01/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "UIViewController+Extension.h"
#import "HGCreateReviewViewController.h"
#import <ClusterPrePermissions/ClusterPrePermissions.h>


@implementation UIViewController (Extension)

- (NSString *)percentageString:(float)progress {
    NSString *localised = NSLocalizedString(@"UIViewController.extension.hud.percentage", nil);
    NSString *text = [NSString stringWithFormat:@"%i%% %@", (int) progress, localised];
    return text;
}

- (void)authenticate:(void (^)(void))loginHandler {

    self.loginHandler = loginHandler;

    HGLogInViewController *logInController = [[HGLogInViewController alloc] init];
    logInController.delegate = self;
    logInController.fields = (PFLogInFieldsFacebook | PFLogInFieldsDismissButton);
    logInController.facebookPermissions = @[@"public_profile"];
    [self presentViewController:logInController animated:true completion:nil];
}

- (void (^)(void))loginHandler {
    return objc_getAssociatedObject(self, @selector(loginHandler));
}

- (void)setLoginHandler:(void (^)(void))loginHandler {
    objc_setAssociatedObject(self, @selector(loginHandler), loginHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)createReviewForLocation:(HGLocation *)location viewModel:(HGBaseViewModel *)viewModel {

    void (^completion)(void) = ^void(void) {
        HGCreateReviewViewModel *reviewViewModel = [[HGCreateReviewViewModel alloc] initWithReviewedLocation:location];
        HGCreateReviewViewController *controller = [HGCreateReviewViewController controllerWithViewModel:reviewViewModel];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:navigationController animated:true completion:nil];
    };

    if ([viewModel isAuthenticated]) {
        completion();
    } else {
        [self authenticate:completion];
    }
}

- (void)getPicturesWithDelegate:(id <HGImagePickerControllerDelegate>)delegate viewModel:(HGBaseViewModel *)viewModel {

    @weakify(self)
    void (^completion)(void) = ^void(void) {
        @strongify(self)
        HGImagePickerController *imagePickerController = [HGImagePickerController controllerWithDelegate:delegate];
        imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
        imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:imagePickerController animated:true completion:nil];
    };


    ClusterPrePermissions *permissions = [ClusterPrePermissions sharedPermissions];
    [permissions showPhotoPermissionsWithTitle:NSLocalizedString(@"ClusterPrePermissions.photo.title", nil) message:NSLocalizedString(@"ClusterPrePermissions.photo.message", nil) denyButtonTitle:NSLocalizedString(@"ClusterPrePermissions.photo.deny", nil) grantButtonTitle:NSLocalizedString(@"ClusterPrePermissions.photo.grant", nil) completionHandler:^(BOOL hasPermission, ClusterDialogResult userDialogResult, ClusterDialogResult systemDialogResult) {
        if (hasPermission) {
            if ([viewModel isAuthenticated]) {
                completion();
            } else {
                [self authenticate:completion];
            }
        } else {
            UIAlertController *errorController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ClusterPrePermissions.access.denied.title", nil) message:NSLocalizedString(@"ClusterPrePermissions.access.denied.message", nil) preferredStyle:UIAlertControllerStyleAlert];
            [errorController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"ClusterPrePermissions.access.denied.ok", nil) style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:errorController animated:true completion:nil];
        }
    }];

}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {

    [self dismissViewControllerAnimated:true completion:^{

        //TODO Move to viewmodel
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        currentInstallation[@"user"] = user;
        [currentInstallation saveInBackground];
        [Crashlytics setUserIdentifier:user.objectId];
        [Crashlytics setUserName:user.facebookName];

        if (user.isNew) {
            [PFUser storeProfileInfoForLoggedInUser:nil];
        }

        self.loginHandler();

    }];
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    [self dismissViewControllerAnimated:true completion:^{
        UIAlertController *errorController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"UIViewController.extension.alert.error.title", nil) message:NSLocalizedString(@"UIViewController.extension.alert.error.message", nil) preferredStyle:UIAlertControllerStyleAlert];
        [errorController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"UIViewController.extension.alert.error.ok", nil) style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:errorController animated:true completion:nil];
    }];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self dismissViewControllerAnimated:true completion:^{
        UIAlertController *errorController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"UIViewController.extension.alert.warning.title", nil) message:NSLocalizedString(@"UIViewController.extension.alert.warning.message", nil) preferredStyle:UIAlertControllerStyleAlert];
        [errorController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"UIViewController.extension.alert.warning.ok", nil) style:UIAlertActionStyleCancel handler:nil]];
    }];
}


- (void)dismissHintView:(NSString *)hintKey {

    [[HGOnboarding instance] setOnBoardingShown:hintKey];
    [UIView animateWithDuration:0.5 animations:^{
        self.hintView.alpha = 0;
    }                completion:^(BOOL finished) {
        [self.hintView removeFromSuperview];
        [self hintWasDismissedByUser:hintKey];
    }];
}

- (void)hintWasDismissedByUser:(NSString *)hintKey {

}

- (void)displayHintForView:(UIView *)viewWithHint withHintKey:(NSString *)hintKey preferedPositionOfText:(HintPosition)position {

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.hintView = [[UIView alloc] initWithFrame:screenRect];
    self.hintView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    self.hintView.autoresizingMask = 0;
    self.hintView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self.hintView];


    CGRect bounds = self.hintView.bounds;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;

    const float radius = 25;
    CGRect absolutePosition = [viewWithHint convertRect:viewWithHint.bounds toView:nil];
    CGRect circleRect = CGRectInset(CGRectMake(CGRectGetMidX(absolutePosition), CGRectGetMidY(absolutePosition), 0, 0), -radius, -radius);

    //Draw ma
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:circleRect];
    [path appendPath:[UIBezierPath bezierPathWithRect:bounds]];
    maskLayer.path = path.CGPath;
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    self.hintView.layer.mask = maskLayer;

    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    hintLabel.textColor = [UIColor whiteColor];
    hintLabel.text = NSLocalizedString(hintKey, nil);
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintLabel.numberOfLines = 0;
    //TODO align text start according with element

    float maxWidth = CGRectGetWidth(screenRect) - 20;
    float paddingToOtherElements = 18;
    CGSize size = [hintLabel getSizeForText:hintLabel.text maxWidth:maxWidth];
    switch (position) {
        case HintPositionAbove: {
            float preferredY = CGRectGetMinY(absolutePosition) - size.height - paddingToOtherElements;
            if (preferredY < 0) { //View is above visible screen, move it below viewWithHint
                hintLabel.frame = CGRectMake(10, CGRectGetMinY(absolutePosition) + CGRectGetHeight(absolutePosition) + paddingToOtherElements, maxWidth, ceilf(size.height));
            } else {
                hintLabel.frame = CGRectMake(10, preferredY, maxWidth, ceilf(size.height));
            }
            break;
        };
        case HintPositionLeft: { //TODO
        };
        case HintPositionRight: { //TODO
        };
        case HintPositionBelow: {
            float preferredY = absolutePosition.origin.y + absolutePosition.size.height + size.height + paddingToOtherElements;
            if (preferredY > screenRect.size.height) { //View is below visible screen, move it above viewWithHint
                hintLabel.frame = CGRectMake(10, absolutePosition.origin.y - size.height - paddingToOtherElements, maxWidth, ceilf(size.height));
            } else {
                hintLabel.frame = CGRectMake(10, preferredY, maxWidth, ceilf(size.height));
            }
            break;
        };
    }

    [self.hintView addSubview:hintLabel];

    [UIView animateWithDuration:0.7 animations:^{
        self.hintView.alpha = 1;
    }];

    @weakify(self)
    @weakify(hintKey)
    [self.hintView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithBlock:^(id weakSender) {
        @strongify(self)
        @strongify(hintKey)
        [self dismissHintView:hintKey];
    }]];
}

- (UIView *)hintView {
    return objc_getAssociatedObject(self, @selector(hintView));
}

- (void)setHintView:(UIView *)hintView {
    objc_setAssociatedObject(self, @selector(hintView), hintView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end