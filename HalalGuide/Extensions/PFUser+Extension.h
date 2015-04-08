//
// Created by Privat on 18/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//
#define kFacebookUserInfoKey @"facebookUserInfo"

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


@interface PFUser (Extension)

@property (nonatomic, strong) NSDictionary *preferences;
@property (nonatomic, strong) NSDictionary *favorites;

+ (void)storeProfileInfoForLoggedInUser:(PFBooleanResultBlock)completion;

- (void)createUserData;

- (NSString *)facebookID;

- (NSString *)facebookName;

- (NSString *)facebookLocation;

- (NSString *)facebookGender;

- (NSString *)facebookBirthday;

- (NSString *)facebookRelationship;

- (NSURL *)facebookProfileUrlSmall;

- (NSURL *)facebookProfileUrl;

@end