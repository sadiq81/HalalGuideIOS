//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "FrontPageViewModel.h"
#import "LocationService.h"
#import "SVProgressHUD.h"
#import "ErrorReporting.h"


@implementation FrontPageViewModel {

}

@synthesize locations, delegate;

+ (FrontPageViewModel *)instance {

    static FrontPageViewModel *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[super alloc] init];
            _instance.locations = [[NSArray alloc] init];

        }
    }

    return _instance;
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
        [SVProgressHUD showWithStatus:NSLocalizedString(@"fetching", nil) maskType:SVProgressHUDMaskTypeGradient];
    }

    [[LocationService instance] lastTenLocations:^(NSArray *objects, NSError *error) {

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