//
// Created by Privat on 06/06/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Facebook-iOS-SDK/FBSDKCoreKit/FBSDKGraphRequest.h>
#import "HGUser.h"
#import "HGReachabilityManager.h"

@implementation HGUser {

}

+ (PF_NULLABLE PFQuery *)query {
    PFQuery *query = [super query];
    if (![HGReachabilityManager isReachable]) {
        [query fromLocalDatastore];
    }
    return query;
}


+ (void)storeProfileInfoForLoggedInUser:(PFBooleanResultBlock)completion {

    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        // result is a dictionary with the user's Facebook data
        if (!error) {
            NSDictionary *userData = (NSDictionary *) result;
            [[PFUser currentUser] setObject:userData forKey:@"userData"];
            [[PFUser currentUser] saveInBackground];
        } else {
            completion(false, error);
        }
    }];
}

- (NSDictionary *)facebookUserData {
    return [self valueForKey:@"userData"];
}

- (NSString *)facebookID {
    return [self.facebookUserData valueForKey:@"id"];
}

//TODO cache names
- (NSString *)facebookName {
    return [self.facebookUserData valueForKey:@"name"];
}

- (NSString *)facebookLocation {
    return [self.facebookUserData valueForKey:@"location.name"];
}

- (NSString *)facebookGender {
    return [self.facebookUserData valueForKey:@"gender"];
}

- (NSString *)facebookBirthday {
    return [self.facebookUserData valueForKey:@"birthday"];
}

- (NSString *)facebookRelationship {
    return [self.facebookUserData valueForKey:@"relationship"];
}

- (NSURL *)facebookProfileUrlSmall {
    NSString *facebookID = [self facebookID];
    NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=small&return_ssl_resources=1", facebookID]];
    return pictureURL;
}

- (NSURL *)facebookProfileUrl {
    NSString *facebookID = [self facebookID];
    NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal&return_ssl_resources=1", facebookID]];
    return pictureURL;
}

+ (void)load {
    [super load];
    [self registerSubclass];
}


+ (void)registerSubclass {
    [super registerSubclass];
}


@end