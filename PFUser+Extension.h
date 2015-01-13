//
// Created by Privat on 18/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//
#define kFacebookUserInfoKey @"facebookUserInfo"

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface PFUser (Extension)

+ (void)storeProfileInfoForLoggedInUser:(PFBooleanResultBlock)completion;


@end