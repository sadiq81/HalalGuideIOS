//
// Created by Privat on 13/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "BaseCollectionViewController.h"
#import "FrontPageViewModel.h"


@implementation BaseCollectionViewController {

}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {

    if ([identifier isEqualToString:@"CreateDining"] || [identifier isEqualToString:@"CreateReview"]) {

        if (![[FrontPageViewModel instance] isAuthenticated]) {
            //TODO Warn user of authenticationsa
            [[FrontPageViewModel instance] authenticate:^(PFUser *user, NSError *error) {
                if (user && !error) {
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