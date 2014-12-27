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

@import MessageUI;

#import <SVProgressHUD/SVProgressHUD.h>

@implementation LocationDetailViewModel {

}

+ (LocationDetailViewModel *)instance {

    static LocationDetailViewModel *_instance = nil;

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
    [mailController setMessageBody:NSLocalizedString(@"errorMailText", nil) isHTML:false];
    mailController.mailComposeDelegate = viewController;
    [viewController presentViewController:mailController animated:true completion:nil];

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

- (LocationPicture *)pictureForRow:(NSUInteger)row {
    return [self.locationPictures objectAtIndex:row];
}

- (void)locationChanged:(NSNotification *)notification {
    //TODO reload distance
}

- (void)setLocation:(Location *)location {
    _location = location;

    self.locationPictures = [NSArray new];
    self.reviews = [NSArray new];

    [SVProgressHUD showWithStatus:NSLocalizedString(@"fetching", nil) maskType:SVProgressHUDMaskTypeNone];

    [[PictureService instance] locationPicturesForLocation:location onCompletion:^(NSArray *objects, NSError *error) {

        [SVProgressHUD popActivity];

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

    [SVProgressHUD showWithStatus:NSLocalizedString(@"fetching", nil) maskType:SVProgressHUDMaskTypeNone];

    [[ReviewService instance] reviewsForLocation:location onCompletion:^(NSArray *objects, NSError *error) {

        [SVProgressHUD popActivity];

        int oldNumberOfItems = (int) [self.reviews count];

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