//
// Created by Privat on 15/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"


@interface LocationService : NSObject
+ (LocationService *)instance;

- (void)saveLocation:(Location *)location onCompletion:(PFBooleanResultBlock)completion;

- (void)locationsByQuery:(PFQuery *)query onCompletion:(PFArrayResultBlock)completion;

- (void)lastTenLocations:(PFArrayResultBlock)completion;

@end