//
// Created by Privat on 18/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "PFUser+Extension.h"
#import "FBRequest.h"
#import "ProfileInfo.h"
#import "ProfileInfoService.h"


@implementation PFUser (Extension)

+ (void)storeProfileInfoForLoggedInUser:(PFBooleanResultBlock)completion {

    FBRequest *request = [FBRequest requestForMe];

    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *) result;

            ProfileInfo *info = [ProfileInfo object];
            info.facebookInfo = userData;
            info.submitterId = [PFUser currentUser].objectId;

            PFACL *userACL = [PFACL ACL];
            [userACL setPublicReadAccess:true];
            [userACL setWriteAccess:true forUser:[PFUser currentUser]];

            info.ACL = userACL;

            [[ProfileInfoService instance] saveProfileInfo:info onCompletion:completion];

        } else {
            completion(false, error);
        }
    }];
}


@end