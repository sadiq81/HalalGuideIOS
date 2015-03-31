//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


@interface HGKeyChainService : NSObject

@property(nonatomic, retain) PFUser *user;

+ (HGKeyChainService *)instance;

- (BOOL)isAuthenticated;

- (void)storeCredentials:(NSDictionary *)credentials;

- (NSDictionary *)retrieveCredentials;

@end