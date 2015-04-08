//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "HGKeyChainService.h"
#import "KeychainWrapper.h"
#import "PFFacebookUtils.h"
#import <Parse/Parse.h>

#define kUserKey @"userid"
#define kUserToken @"token"

@implementation HGKeyChainService {

}
+ (HGKeyChainService *)instance {
    static HGKeyChainService *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (BOOL)isAuthenticated {
    return ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]);
}

- (void)storeCredentials:(NSDictionary *)credentials {
    [KeychainWrapper createKeychainValue:[credentials objectForKey:kUserKey] forIdentifier:kUserKey];
    [KeychainWrapper createKeychainValue:[credentials objectForKey:kUserToken] forIdentifier:kUserToken];
}

- (NSDictionary *)retrieveCredentials {

    NSMutableDictionary *credentials = [[NSMutableDictionary alloc] init];
    [credentials setValue:[KeychainWrapper keychainStringFromMatchingIdentifier:kUserKey] forKey:kUserKey];
    [credentials setValue:[KeychainWrapper keychainStringFromMatchingIdentifier:kUserToken] forKey:kUserToken];
    return credentials;
}
@end
