//
// Created by Privat on 10/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIBarButtonItem+ALActionBlocks.h>
#import "CoordinatePickerViewController.h"
#import "CreateDiningViewModel.h"
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/AddressBookUI.h>
#import <SVProgressHUD/SVProgressHUD.h>

@implementation CoordinatePickerViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tempCoordinate = kCLLocationCoordinate2DInvalid;

    if ([CreateDiningViewModel instance].suggestedPlaceMark) {
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = [CreateDiningViewModel instance].suggestedPlaceMark.location.coordinate;
        //point.title = [CreateDiningViewModel instance].suggestionName;
        [self.mapView addAnnotation:point];

        MKCoordinateSpan span = MKCoordinateSpanMake(0.005, 0.005);
        MKCoordinateRegion region = MKCoordinateRegionMake([CreateDiningViewModel instance].suggestedPlaceMark.location.coordinate, span);
        [self.mapView setRegion:region animated:YES];
    }
    __weak typeof(self) weakSelf = self;
    [self.approve setBlock:^(id weakSender) {
        if (!CLLocationCoordinate2DIsValid(weakSelf.tempCoordinate) && CLLocationCoordinate2DIsValid([CreateDiningViewModel instance].suggestedPlaceMark.location.coordinate)) {
            [CreateDiningViewModel instance].userChoosenLocation = [CreateDiningViewModel instance].suggestedPlaceMark.location.coordinate;
        } else {
            [CreateDiningViewModel instance].userChoosenLocation = weakSelf.tempCoordinate;
        }
        [weakSelf.navigationController popViewControllerAnimated:true];
    }];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {

    if ([CreateDiningViewModel instance].suggestedPlaceMark == nil && mapView.tag == 0) {

        MKCoordinateSpan span = MKCoordinateSpanMake(0.005, 0.005);
        MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.location.coordinate, span);
        self.mapView.tag = 1;
        [self.mapView setRegion:region animated:YES];
    }
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
                [SVProgressHUD showErrorWithStatus:@"Ikke en gyldig adresse" maskType:SVProgressHUDMaskTypeGradient];
            }
        }];


    }
}

@end