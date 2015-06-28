//
// Created by Privat on 06/06/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

<<<<<<< HEAD:HalalGuide/Extensions/PFUser+Extension.h

@interface PFUser (Extension)
=======
@interface HGUser : PFUser<PFSubclassing>
>>>>>>> developer:HalalGuide/Extensions/HGUser.h

+ (void)storeProfileInfoForLoggedInUser:(PFBooleanResultBlock)completion;

- (NSString *)facebookID;

- (NSString *)facebookName;

- (NSString *)facebookLocation;

- (NSString *)facebookGender;

- (NSString *)facebookBirthday;

- (NSString *)facebookRelationship;

- (NSURL *)facebookProfileUrlSmall;

- (NSURL *)facebookProfileUrl;

@end