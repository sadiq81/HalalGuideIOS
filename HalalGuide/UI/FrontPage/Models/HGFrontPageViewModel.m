//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "HGFrontPageViewModel.h"
#import "HGLocationService.h"
#import "HGErrorReporting.h"

@interface HGFrontPageViewModel () {
}

@property(nonatomic) NSArray *locations;

@end

@implementation HGFrontPageViewModel {

}

@synthesize locations;

- (instancetype)init {

    self = [super init];
    if (self) {

    }
    return self;
}

- (HGLocationDetailViewModel *)viewModelForLocationAtIndex:(NSUInteger)index {
    return [HGLocationDetailViewModel modelWithLocation:self.locations[index]];
}

- (void)refreshLocations {

    self.fetchCount++;
    [[HGLocationService instance] lastTenLocations:^(NSArray *objects, NSError *error) {
        self.fetchCount--;

        if ((self.error = error)) {
            [[HGErrorReporting instance] reportError:error];
        } else {
            self.locations = objects;
        }
    }];


}

@end