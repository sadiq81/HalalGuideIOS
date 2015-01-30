//
// Created by Privat on 10/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIBarButtonItem+ALActionBlocks.h>
#import "CoordinatePickerViewController.h"
#import "CreateLocationViewModel.h"
#import "HalalGuideOnboarding.h"
#import "UIView+Extensions.h"
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/AddressBookUI.h>
#import <SVProgressHUD/SVProgressHUD.h>

@implementation CoordinatePickerViewController {

}
- (void)viewDidLoad {
    [super viewDidLoad];

    __weak typeof(self) weakSelf = self;

    self.tempCoordinate = kCLLocationCoordinate2DInvalid;

    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.title = [CreateLocationViewModel instance].suggestionName;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.005, 0.005);
    MKCoordinateRegion region;

    if ([CreateLocationViewModel instance].suggestedPlaceMark) {
        point.coordinate = [CreateLocationViewModel instance].suggestedPlaceMark.location.coordinate;
    } else {
        point.coordinate = [BaseViewModel currentLocation].coordinate;
    }

    [self.mapView addAnnotation:point];
    region = MKCoordinateRegionMake(point.coordinate, span);
    [self.mapView setRegion:region animated:YES];


    [self.approve setBlock:^(id weakSender) {
        if (!CLLocationCoordinate2DIsValid(weakSelf.tempCoordinate) && CLLocationCoordinate2DIsValid([CreateLocationViewModel instance].suggestedPlaceMark.location.coordinate)) {
            [CreateLocationViewModel instance].userChoosenLocation = [CreateLocationViewModel instance].suggestedPlaceMark.location.coordinate;
        } else {
            [CreateLocationViewModel instance].userChoosenLocation = weakSelf.tempCoordinate;
        }
        [weakSelf.navigationController popViewControllerAnimated:true];
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {

    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    static NSString *reuseId = @"pin";
    MKPinAnnotationView *mapPin = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (!mapPin) {
        mapPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        mapPin.draggable = YES;
        mapPin.animatesDrop = YES;

    }

    //TODO Position in view is off
    if ([[HalalGuideOnboarding instance] wasOnBoardingShow:kManuelGPSPositionKey]) {
        #warning implement
    }

    return mapPin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    if (newState == MKAnnotationViewDragStateEnding) {

        CLLocation *location = [[CLLocation alloc] initWithLatitude:view.annotation.coordinate.latitude longitude:view.annotation.coordinate.longitude];
        __weak typeof(self) weakSelf = self;
        [[[CLGeocoder alloc] init] reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (placemarks && !error && [placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                [SVProgressHUD showSuccessWithStatus:ABCreateStringWithAddressDictionary(placemark.addressDictionary, false) maskType:SVProgressHUDMaskTypeGradient];
                [view.annotation setCoordinate:view.annotation.coordinate];
                weakSelf.tempCoordinate = view.annotation.coordinate;
            } else {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"invalidAddress", nil) maskType:SVProgressHUDMaskTypeGradient];
            }
        }];
    }
}

@end