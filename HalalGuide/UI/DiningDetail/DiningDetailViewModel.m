//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "DiningDetailViewModel.h"
#import "LocationPicture.h"
#import "PictureService.h"
#import "ErrorReporting.h"
#import "DiningViewModel.h"
#import "ReviewService.h"

@import MessageUI;

#import <SVProgressHUD/SVProgressHUD.h>

@implementation DiningDetailViewModel {

}

+ (DiningDetailViewModel *)instance {

    static DiningDetailViewModel *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[super alloc] init];
            _instance.locationPictures = [NSArray new];
            _instance.reviews = [NSArray new];
        }
    }

    return _instance;
}

- (void)report:(UIViewController <MFMailComposeViewControllerDelegate> *)viewController {

    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    [mailController setToRecipients:@[@"tommy@eazyit.dk"]];
    [mailController setSubject:[NSString stringWithFormat:@"%@", self.location.objectId]];
    [mailController setMessageBody:@"Der er følgende forkerte oplysninger: \nUDDYB HER!" isHTML:false];
    mailController.mailComposeDelegate = viewController;
    [viewController presentViewController:mailController animated:true completion:nil];

}


- (LocationPicture *)pictureForRow:(NSUInteger)row {
    return [self.locationPictures objectAtIndex:row];
}

- (void)locationChanged:(NSNotification *)notification {
    //TODO reload distance
}

- (void)setLocation:(Location *)location {
    _location = location;

    self.locationPictures = [NSArray new];

    [[PictureService instance] locationPicturesForLocation:location onCompletion:^(NSArray *objects, NSError *error) {

        [SVProgressHUD dismiss];

        if (error) {

            [[ErrorReporting instance] reportError:error];
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", error.localizedDescription]];

        } else {
            self.locationPictures = objects;
        }

        if ([self.pictureDelegate respondsToSelector:@selector(reloadCollectionView)]) {
            [self.pictureDelegate reloadCollectionView];

        }
    }];

    [[ReviewService instance] reviewsForLocation:location onCompletion:^(NSArray *objects, NSError *error) {

        [SVProgressHUD dismiss];

        int oldNumberOfItems = [self.reviews count];

        if (error) {

            [[ErrorReporting instance] reportError:error];
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", error.localizedDescription]];

        } else {

            self.reviews = objects;
        }

        if ([self.reviewDelegate respondsToSelector:@selector(reloadCollectionView:insertNewItems:)]) {
            [self.reviewDelegate reloadCollectionView:oldNumberOfItems insertNewItems:[self.reviews count]];
        }

    }];

}


@end