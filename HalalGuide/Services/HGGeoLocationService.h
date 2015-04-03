//
// Created by Privat on 02/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HGGeoLocationService : NSObject

@property(nonatomic, strong, readonly) CLLocation *currentLocation;

+ (HGGeoLocationService *)instance;

@end