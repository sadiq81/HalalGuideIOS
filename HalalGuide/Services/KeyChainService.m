//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "KeyChainService.h"
#import "KeychainWrapper.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

#define kUserKey @"userid"
#define kUserToken @"token"

@implementation KeyChainService {

}
+ (KeyChainService *)instance {
    static KeyChainService *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (BOOL)isAuthenticated {
    return [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]];
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
