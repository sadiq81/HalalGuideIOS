//
// Created by Privat on 29/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Adgangsadresse.h"

@interface AddressService : NSObject

+ (AddressService *)instance;

+ (CLLocationDistance)distanceInMetersToPoint:(CLLocation *)location;

+ (void)cityNameFor:(NSString *)postalCode onCompletion:(void (^)(Postnummer *postnummer))completion;

+ (void)doesAddressExist:(NSString *)road roadNumber:(NSString *)roadNumber postalCode:(NSString *)postalCode onCompletion:(void (^)(Adgangsadresse *address))completion;

+ (void)findPointForAddress:(NSString *)road roadNumber:(NSString *)roadNumber postalCode:(NSString *)postalCode onCompletion:(void (^)(CLPlacemark *place))completion;

+ (void)addressNearPosition:(CLLocation *)location onCompletion:(void (^)(NSArray *addresses))completion;

@end