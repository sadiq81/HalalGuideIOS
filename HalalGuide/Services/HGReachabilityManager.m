//
// Created by Privat on 06/06/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "HGReachabilityManager.h"
#import "Reachability.h"


@implementation HGReachabilityManager {

}
#pragma mark -
#pragma mark Default Manager

+ (HGReachabilityManager *)sharedManager {
    static HGReachabilityManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });

    return _sharedManager;
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
    // Stop Notifier
    if (_reachability) {
        [_reachability stopNotifier];
    }
}

#pragma mark -
#pragma mark Class Methods

+ (BOOL)isReachable {
    return [[[HGReachabilityManager sharedManager] reachability] isReachable];
}

+ (BOOL)isUnreachable {
    return ![[[HGReachabilityManager sharedManager] reachability] isReachable];
}

+ (BOOL)isReachableViaWWAN {
    return [[[HGReachabilityManager sharedManager] reachability] isReachableViaWWAN];
}

+ (BOOL)isReachableViaWiFi {
    return [[[HGReachabilityManager sharedManager] reachability] isReachableViaWiFi];
}

#pragma mark -
#pragma mark Private Initialization

- (id)init {
    self = [super init];

    if (self) {
        // Initialize Reachability
        self.reachability = [Reachability reachabilityForInternetConnection];

        // Start Monitoring
        [self.reachability startNotifier];
        self.reachability.reachableBlock = ^(Reachability *reachability) {
            NSLog(@"Reachable");
        };
        self.reachability.unreachableBlock = ^(Reachability *reachability) {
            NSLog(@"Unreachable");
        };
    }

    return self;
}

@end