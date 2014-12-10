//
//  DiningDetailViewController.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIControl+ALActionBlocks.h>
#import <MapKit/MapKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "DiningDetailViewController.h"
#import "DiningDetailViewModel.h"
#import "HalalGuideNumberFormatter.h"
#import "CreateReviewViewModel.h"
#import "UIAlertController+Blocks.h"
#import "CreateDiningViewModel.h"

@implementation DiningDetailViewController {
    UIImage *image;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    __weak typeof(self) weakSelf = self;

    [self.addPicture handleControlEvents:UIControlEventTouchUpInside withBlock:^(UIButton *weakSender) {
        [[DiningDetailViewModel instance] getPicture:weakSelf withDelegate:weakSelf];
    }];

    [self.report handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        [[DiningDetailViewModel instance] report:weakSelf];
    }];

    [self setupUIValues];
}

- (void)setupUIValues {
    Location *loc = [DiningDetailViewModel instance].location;
    self.name.text = loc.name;
    self.address.text = [[NSString alloc] initWithFormat:@"%@ %@\n%@ %@", loc.addressRoad, loc.addressRoadNumber, loc.addressPostalCode, loc.addressCity];
    [self.address addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMaps:)]];
    self.distance.text = [[HalalGuideNumberFormatter instance] stringFromNumber:loc.distance];
    self.category.text = [loc categoriesString];
    [self.porkImage configureViewForLocation:loc];
    [self.alcoholImage configureViewForLocation:loc];
    [self.halalImage configureViewForLocation:loc];
    [self.porkLabel configureViewForLocation:loc];
    [self.alcoholLabel configureViewForLocation:loc];
    [self.halalLabel configureViewForLocation:loc];

}

- (void)openMaps:(UITapGestureRecognizer *)recognizer {

    [UIAlertController showAlertInViewController:self withTitle:@"Find vej" message:[NSString stringWithFormat:@"Vil du åbne Kort og få vist vejen til %@", [DiningDetailViewModel instance].location.name] cancelButtonTitle:@"Ellers tak" destructiveButtonTitle:nil otherButtonTitles:@[@"Ja tak"] tapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex) {
        if (buttonIndex >= UIAlertControllerBlocksFirstOtherButtonIndex) {
            PFGeoPoint *point = [[DiningDetailViewModel instance].location point];
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(point.latitude, point.longitude) addressDictionary:nil];
            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
            [mapItem setName:[DiningDetailViewModel instance].location.name];

            // Set the directions mode to "Driving"
            // Can use MKLaunchOptionsDirectionsModeWalking instead
            NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};

            // Get the "Current User Location" MKMapItem
            MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];

            // Pass the current location and destination map items to the Maps app
            // Set the direction mode in the launchOptions dictionary
            [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem] launchOptions:launchOptions];
        }
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"CreateReview"]) {
        [CreateReviewViewModel instance].reviewedLocation = [DiningDetailViewModel instance].location;
    }

}

#pragma mark - ImagePicker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:true completion:nil];
    image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //TODO Ugly hack, fix with TODO below
    [CreateDiningViewModel instance].createdLocation = [DiningDetailViewModel instance].location;
    [[CreateDiningViewModel instance] savePicture:image onCompletion:^(CreateEntityResult result) {
        [CreateDiningViewModel instance].createdLocation = nil;
        //TODO Error handling like CreateDiningViewController, share code somehow
    }];
}

#pragma mark - Mail composer

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
