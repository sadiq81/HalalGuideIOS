//
// Created by Privat on 06/06/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Parse/PFConstants.h>
#import "HGUserService.h"
#import "HGUser.h"
#import "HGReachabilityManager.h"
#import "HGQuery.h"


@implementation HGUserService {

}

+ (HGUserService *)instance {
    static HGUserService *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (void)getUserInBackGround:(NSString *)id onCompletion:(PFObjectResultBlock)completion {

    if ([HGReachabilityManager isReachable]) {

        [[HGUser query] getObjectInBackgroundWithId:id block:^(PFObject *object, NSError *error) {
            if (object && !error) {
                [object pinInBackground];
            }
            completion(object, error);
        }];
    } else {
        PFQuery *query = [HGUser query];
        [query whereKey:@"objectId" equalTo:id];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

            HGUser *user = nil;
            if ([objects count] == 1) {
                user = [objects firstObject];
            }
            completion(user, error);
        }];
    }
}

@end