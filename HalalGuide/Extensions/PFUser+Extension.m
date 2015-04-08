//
// Created by Privat on 18/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "PFUser+Extension.h"
#import "FBSDKGraphRequest.h"

@implementation PFUser (Extension)

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

- (void)createUserData {
    self.preferences = [NSDictionary new];
    self.favorites = [NSDictionary new];
}

- (NSDictionary *)facebookUserData {
    return [self valueForKey:@"userData"];
}

- (NSDictionary *)preferences {
    return [self valueForKey:@"preferences"];
}

- (void)setPreferences:(NSDictionary *)preferences {
    [self setObject:preferences forKey:@"preferences"];
}

- (NSDictionary *)favorites {
    return [self valueForKey:@"favorites"];
}

- (void)setFavorites:(NSDictionary *)favorites {
    [self setObject:favorites forKey:@"favorites"];
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


@end