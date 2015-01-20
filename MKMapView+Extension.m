//
// Created by Privat on 20/01/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MKMapView+Extension.h"


@implementation MKMapView (Extension)

- (PFGeoPoint *)southWest {
    MKCoordinateRegion region1 = self.region;
    double latitude = region1.center.latitude - region1.span.latitudeDelta;
    double longitude = region1.center.longitude - region1.span.longitudeDelta;
    CLLocation *sw = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    PFGeoPoint *southwest = [PFGeoPoint geoPointWithLocation:sw];

    return southwest;
}

- (PFGeoPoint *)northEast {

    MKCoordinateRegion region1 = self.region;
    double latitude = region1.center.latitude + region1.span.latitudeDelta;
    double longitude = region1.center.longitude + region1.span.longitudeDelta;
    CLLocation *ne = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    PFGeoPoint *northeast = [PFGeoPoint geoPointWithLocation:ne];

    return northeast;
}


@end