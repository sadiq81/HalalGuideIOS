//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "FrontPageViewModel.h"
#import "HGLocationService.h"
#import "HGErrorReporting.h"

@interface FrontPageViewModel () {
}

@property(nonatomic) NSArray *locations;

@end

@implementation FrontPageViewModel {

}

@synthesize locations;

- (instancetype)init {

    self = [super init];
    if (self) {

    }
    return self;
}

- (LocationDetailViewModel *)viewModelForLocationAtIndex:(NSUInteger)index {
    return [LocationDetailViewModel modelWithLocation:[self.locations objectAtIndex:index]];
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