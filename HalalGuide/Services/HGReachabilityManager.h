//
// Created by Privat on 06/06/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Reachability;

@interface HGReachabilityManager : NSObject

@property (strong, nonatomic) Reachability *reachability;

#pragma mark -
#pragma mark Shared Manager
+ (HGReachabilityManager *)sharedManager;

#pragma mark -
#pragma mark Class Methods
+ (BOOL)isReachable;
+ (BOOL)isUnreachable;
+ (BOOL)isReachableViaWWAN;
+ (BOOL)isReachableViaWiFi;

@end