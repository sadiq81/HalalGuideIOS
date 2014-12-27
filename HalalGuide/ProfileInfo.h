//
// Created by Privat on 13/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEntity.h"

#define kProfileInfoTableName  @"ProfileInfo"

@interface ProfileInfo : BaseEntity

@property (nonatomic, retain) NSString * submitterId;
@property (nonatomic) NSDictionary *facebookInfo;

- (NSString *)facebookID;

- (NSString *)facebookName;

- (NSString *)facebookLocation;

- (NSString *)facebookGender;

- (NSString *)facebookBirthday;

- (NSString *)facebookRelationship;

- (NSURL *)facebookProfileUrlSmall;

- (NSURL *)facebookProfileUrl;


@end