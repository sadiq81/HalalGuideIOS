//
// Created by Privat on 02/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "HGGeoLocationService.h"

@interface HGGeoLocationService () <CLLocationManagerDelegate>
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) CLLocation *currentLocation;
@end

@implementation HGGeoLocationService {

}

+ (HGGeoLocationService *)instance {
    static HGGeoLocationService *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
            [_instance startStandardUpdates];
#if (TARGET_IPHONE_SIMULATOR)
            _instance.currentLocation = [[CLLocation alloc] initWithLatitude:55.690297 longitude:12.542128];
#endif
        }
    }

    return _instance;
}

- (void)startStandardUpdates {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = 500;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation *lastLocation = [locations lastObject];
    NSDate *eventDate = lastLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 15.0) {
        //[NSNotificationCenter defaultCenter] TODO Broadcast signal to update distance labels
        self.currentLocation = lastLocation;
    }
}
@end