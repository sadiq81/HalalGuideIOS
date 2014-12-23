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
#import "HalalGuideSettings.h"

@implementation DiningViewModel {

}

@synthesize locations, delegate, maximumDistance, showNonHalal, showAlcohol, showPork, categories, page;

+ (DiningViewModel *)instance {
    static DiningViewModel *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[super alloc] init];

            _instance.maximumDistance = (int) [HalalGuideSettings instance].distanceFilter;
            _instance.showPork = [HalalGuideSettings instance].porkFilter;
            _instance.showAlcohol = [HalalGuideSettings instance].alcoholFilter;
            _instance.showNonHalal = [HalalGuideSettings instance].halalFilter;

            _instance.categories = [HalalGuideSettings instance].categoriesFilter;
            _instance.locations = [NSMutableArray new];

            _instance.page = 0;

        }
    }

    return _instance;
}

- (PFQuery *)query {

    PFQuery *query = [PFQuery queryWithClassName:kLocationTableName];
    [query whereKey:@"locationType" equalTo:@(LocationTypeDining)];
    [query whereKey:@"creationStatus" equalTo:@(CreationStatusApproved)];

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

    //Paging controls
    query.limit = 20;
    query.skip = self.page * 20;

    return query;
}

- (void)reset {
    self.locations = [NSMutableArray new];
    self.page = 0;
}

- (void)locationChanged:(NSNotification *)notification {

    [super locationChanged:notification];

    [self calculateDistances:self.locations sortByDistance:false];

    if ([self.delegate respondsToSelector:@selector(refreshTable)]) {
        [self.delegate refreshTable];
    }
}

- (void)refreshLocations:(BOOL)firstLoad {

    if (firstLoad) {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"fetching", nil) maskType:SVProgressHUDMaskTypeGradient];
    }

    [[LocationService instance] locationsByQuery:self.query onCompletion:^(NSArray *objects, NSError *error) {

        [SVProgressHUD dismiss];

        if (error) {

            [[ErrorReporting instance] reportError:error];
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", error.localizedDescription]];

        } else {

            if (self.page != 0) {
                [self.locations addObjectsFromArray:objects];
            } else {
                self.locations = [[NSMutableArray alloc] initWithArray:objects];
            }

            self.locations = [[NSMutableArray alloc] initWithArray:[self calculateDistances:self.locations sortByDistance:true]];
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