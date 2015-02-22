//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "FrontPageViewModel.h"
#import "LocationService.h"
#import "ErrorReporting.h"

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
    return [[LocationDetailViewModel alloc] initWithLocation:[self.locations objectAtIndex:index]];
}

- (void)refreshLocations {

    self.fetchCount++;
    [[LocationService instance] lastTenLocations:^(NSArray *objects, NSError *error) {
        self.fetchCount--;

        if ((self.error = error)) {
            [[ErrorReporting instance] reportError:error];
        } else {
            self.locations = objects;
        }
    }];


}

@end