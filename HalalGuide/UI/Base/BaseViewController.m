//
// Created by Privat on 06/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import "BaseViewController.h"
#import "BaseViewModel.h"
#import "FrontPageViewModel.h"


@implementation BaseViewController {

}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {


    if ([identifier isEqualToString:@"CreateDining"] || [identifier isEqualToString:@"CreateReview"]) {

        if (![[FrontPageViewModel instance] isAuthenticated]) {
            [SVProgressHUD showWithStatus:NSLocalizedString(@"loggingIn", nil) maskType:SVProgressHUDMaskTypeGradient];
            //TODO Warn user of authentication windows
            [[FrontPageViewModel instance] authenticate:^(BOOL succeeded, NSError *error) {
                [SVProgressHUD dismiss];
                if (!error) {
                    [self performSegueWithIdentifier:identifier sender:self];
                }
            }];
            return false;
        } else {
            return true;
        }
    } else {
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    }
}

@end