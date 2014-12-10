//
// Created by Privat on 22/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//


#import "LocationService.h"
#import "DiningViewModel.h"
#import "MapKit/MapKit.h"
#import "NSMutableString+Extensions.h"
#import "SVProgressHUD.h"
#import "ErrorReporting.h"

@implementation DiningViewModel {

}

@synthesize locations, delegate, maximumDistance, showNonHalal, showAlcohol, showPork, categories;

+ (DiningViewModel *)instance {
    static DiningViewModel *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[super alloc] init];

            _instance.maximumDistance = 5;
            _instance.showPork = true;
            _instance.showAlcohol = true;
            _instance.showNonHalal = true;

            _instance.categories = [[NSMutableArray alloc] init];

        }
    }

    return _instance;
}

- (PFQuery *)query {


#warning set creationStatus == 1 in production

    PFQuery *query = [PFQuery queryWithClassName:kLocationTableName];
    [query whereKey:@"locationType" equalTo:@(0)];
    [query whereKey:@"creationStatus" equalTo:@(0)];

    if (!self.showPork) {
        [query whereKey:@"pork" equalTo:@(self.showPork)];
    }

    if (!self.showAlcohol) {
        [query whereKey:@"alcohol" equalTo:@(self.showAlcohol)];
    }

    if (!self.showNonHalal) {
        [query whereKey:@"nonHalal" equalTo:@(self.showNonHalal)];
    }

    if ([BaseViewModel currentLocation] && self.maximumDistance < 20) {
        [query whereKey:@"point" nearGeoPoint:[PFGeoPoint geoPointWithLocation:[BaseViewModel currentLocation]] withinKilometers:self.maximumDistance];
    }

    if ([self.categories count] > 0) {
        [query whereKey:@"categories" containedIn:self.categories];
    }

    return query;
}

- (void)locationChanged:(NSNotification *)notification {

    [super locationChanged:notification];

    [self calculateDistances:self.locations sortByDistance:false];

    if ([self.delegate respondsToSelector:@selector(refreshTable)]) {
        [self.delegate refreshTable];
    }
}

- (void)refreshLocations:(BOOL) firstLoad {

    if (firstLoad){
        [SVProgressHUD showWithStatus:@"Henter" maskType:SVProgressHUDMaskTypeGradient];
    }

    [[LocationService instance] locationsByQuery:self.query onCompletion:^(NSArray *objects, NSError *error) {

        [SVProgressHUD dismiss];

        if (error) {

            [[ErrorReporting instance] reportError:error];
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", error.localizedDescription]];

        } else {

            self.locations = objects;
            [self calculateDistances:self.locations sortByDistance:false];
        }

        if ([self.delegate respondsToSelector:@selector(reloadTable)]) {
            [self.delegate reloadTable];
        }
    }];


}

- (NSUInteger)numberOfLocations {
    return [self.locations count];
}

- (Location *)locationForRow:(NSUInteger)row {
    return [self.locations objectAtIndex:row];
}
@end