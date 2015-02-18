//
//  HalalGuideIAPHelper.m
//  In App Rage
//
//  Created by Ray Wenderlich on 9/5/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import <RMStore/RMStore.h>
#import <Parse/Parse.h>
#import "HalalGuideIAPHelper.h"

@implementation HalalGuideIAPHelper

+ (HalalGuideIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static HalalGuideIAPHelper *sharedInstance;

    dispatch_once(&once, ^{
        [PFConfig getConfigInBackgroundWithBlock:^(PFConfig *config, NSError *error) {
            NSArray *products = config[@"Products"];
            NSSet *set = [[NSSet alloc] initWithArray:products];
            [[RMStore defaultStore] requestProducts:set];
        }];
    });

    return sharedInstance;
}

@end
