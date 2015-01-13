//
// Created by Privat on 18/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "PFUser+Extension.h"
#import "FBRequest.h"
#import "ProfileInfo.h"


@implementation PFUser (Extension)

+ (void)storeProfileInfoForLoggedInUser:(PFBooleanResultBlock)completion {

    FBRequest *request = [FBRequest requestForMe];

    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *) result;
            [[PFUser currentUser] setObject:userData forKey:@"userData"];
            [[PFUser currentUser] saveEventually];

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

//TODO different sizes for cell and view
- (NSURL *)facebookProfileUrl {
    NSString *facebookID = [self facebookID];
    NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal&return_ssl_resources=1", facebookID]];
    return pictureURL;
}


@end