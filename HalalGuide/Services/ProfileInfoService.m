//
// Created by Privat on 15/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "ProfileInfoService.h"
#import "Location.h"
#import "ProfileInfo.h"

@implementation ProfileInfoService {

}

+ (ProfileInfoService *)instance {
    static ProfileInfoService *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (void)saveProfileInfo:(ProfileInfo *)info onCompletion:(PFBooleanResultBlock)completion {
    [info saveInBackgroundWithBlock:completion];
}

- (void)profileInfoForSubmitter:(NSString *)submitter onCompletion:(void (^)(ProfileInfo *info))completion {
    PFQuery *query = [PFQuery queryWithClassName:kProfileInfoTableName];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    [query whereKey:@"submitterId" equalTo:submitter];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        if (!error && [objects count] > 0) {
            completion([objects firstObject]);
        } else {
            completion(nil);
        }
    }];
}

@end