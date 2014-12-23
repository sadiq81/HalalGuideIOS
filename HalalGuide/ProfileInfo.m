//
// Created by Privat on 13/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "ProfileInfo.h"


@implementation ProfileInfo {

}

@dynamic submitterId, facebookInfo;

- (NSString *)facebookID {
    return [self.facebookInfo valueForKey:@"id"];
}

//TODO cache names
- (NSString *)facebookName {
    return [self.facebookInfo valueForKey:@"name"];
}

- (NSString *)facebookLocation {
    return [self.facebookInfo valueForKey:@"location.name"];
}

- (NSString *)facebookGender {
    return [self.facebookInfo valueForKey:@"gender"];
}

- (NSString *)facebookBirthday {
    return [self.facebookInfo valueForKey:@"birthday"];
}

- (NSString *)facebookRelationship {
    return [self.facebookInfo valueForKey:@"relationship"];
}

//TODO different sizes for cell and view
- (NSURL *)facebookProfileUrl {
    NSString *facebookID = [self facebookID];
    NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal&return_ssl_resources=1", facebookID]];
    return pictureURL;
}

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return kProfileInfoTableName;
}
@end