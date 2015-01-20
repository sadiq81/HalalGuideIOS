//
// Created by Privat on 20/01/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class Location;


@interface LocationAnnotation : MKPointAnnotation

@property (nonatomic) Location *location;

@end