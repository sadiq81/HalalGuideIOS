//
// Created by Privat on 29/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HTAutocompleteTextField/HTAutocompleteTextField.h>
#import "HGBaseViewModel.h"
#import "HGAdgangsadresse.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface HGCreateLocationViewModel : HGBaseViewModel <CategoriesViewModel>

@property(nonatomic, readonly) LocationType locationType;
@property(nonatomic, strong, readonly) NSDictionary *streetDictionary;
@property(nonatomic, strong, readonly) HGLocation *createdLocation;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *road;
@property(nonatomic, strong) NSString *roadNumber;
@property(nonatomic, strong) NSString *postalCode;
@property(nonatomic, strong) NSString *city;
@property(nonatomic, strong) NSString *telephone;
@property(nonatomic, strong) NSString *website;
@property(nonatomic, strong) NSNumber *pork;
@property(nonatomic, strong) NSNumber *alcohol;
@property(nonatomic, strong) NSNumber *nonHalal;
@property(nonatomic, strong) NSArray *images;


- (instancetype)initWithLocationType:(LocationType)type;

- (NSArray *)streetNameForPrefix:(NSString *)prefix;

- (NSArray *)streetNumbersForRoad;

- (Postnummer *)postalCodeForRoad;

- (void)loadAddressesNearPositionOnCompletion:(void (^)(void))completion;

- (void)cityNameForPostalCode:(void (^)(Postnummer *postNummer))completion;

- (void)saveLocation;

@end