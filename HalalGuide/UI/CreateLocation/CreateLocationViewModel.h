//
// Created by Privat on 29/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HTAutocompleteTextField/HTAutocompleteTextField.h>
#import "BaseViewModel.h"
#import "Adgangsadresse.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface CreateLocationViewModel : BaseViewModel <CategoriesViewModel>

@property (nonatomic) LocationType locationType;
@property(nonatomic, retain) NSDictionary *streetNumbers;
@property(nonatomic, retain) Location *createdLocation;

- (NSArray *)streetNameForPrefix:(NSString *)prefix;

- (NSArray *)streetNumbersFor:(NSString *)road;

- (Postnummer *)postalCodeFor:(NSString *)road;

- (void)loadAddressesNearPositionOnCompletion:(void (^)(void))completion;

- (void)cityNameFor:(NSString *)postalCode onCompletion:(void (^)(Postnummer *postnummer))completion;

- (void)saveEntity:(NSString *)name road:(NSString *)road roadNumber:(NSString *)roadNumber postalCode:(NSString *)postalCode city:(NSString *)city telephone:(NSString *)telephone website:(NSString *)website pork:(BOOL)pork alcohol:(BOOL)alcohol nonHalal:(BOOL)nonHalal images:(NSArray *)images;

@end