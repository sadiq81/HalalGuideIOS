//
// Created by Privat on 15/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGLocation.h"

@class RACSignal;


@interface HGLocationService : NSObject
+ (HGLocationService *)instance;

- (void)saveLocation:(HGLocation *)location onCompletion:(PFBooleanResultBlock)completion;

- (void)locationsByQuery:(PFQuery *)query onCompletion:(PFArrayResultBlock)completion;

- (void)lastTenLocations:(PFArrayResultBlock)completion;

@end