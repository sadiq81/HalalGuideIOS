//
// Created by Privat on 15/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGLocation.h"
#import "HGChangeSuggestion.h"
#import "ReactiveCocoa.h"

@interface HGLocationService : NSObject
+ (HGLocationService *)instance;

- (void)locationById:(NSString *)objectId onCompletion:(PFIdResultBlock)completion;

- (void)saveLocation:(HGLocation *)location onCompletion:(PFBooleanResultBlock)completion;

- (void)locationsByQuery:(PFQuery *)query onCompletion:(PFArrayResultBlock)completion;

- (void)lastTenLocations:(PFArrayResultBlock)completion;

- (void)saveSuggestion:(HGChangeSuggestion *)suggestion onCompletion:(void (^)(BOOL, NSError *))completion;
@end