//
// Created by Privat on 29/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HTAutocompleteTextField/HTAutocompleteTextField.h>
#import "BaseViewModel.h"

@class UIImage;
@class Postnummer;
@class Adgangsadresse;


@interface CreateLocationViewModel : BaseViewModel <CategoriesViewModel>

@property (nonatomic) LocationType locationType;
@property(nonatomic, retain) NSDictionary *streetNumbers;
@property(nonatomic, retain) Location *createdLocation;
@property(nonatomic, retain) CLPlacemark *suggestedPlaceMark;
@property(nonatomic, retain) NSString *suggestionName;
@property(nonatomic) CLLocationCoordinate2D userChoosenLocation;

+ (CreateLocationViewModel *)instance;

- (void)reset;

- (NSArray *)streetNameForPrefix:(NSString *)prefix;

- (NSArray *)streetNumbersFor:(NSString *)road;

- (Postnummer *)postalCodeFor:(NSString *)road;

- (void)loadAddressesNearPositionOnCompletion:(void (^)(void))completion;

- (void)cityNameFor:(NSString *)postalCode onCompletion:(void (^)(Postnummer *postnummer))completion;

- (void)findAddressesForRoad:(NSString *)road number:(NSString *)roadNumber code:(NSString *)postalCode onCompletion:(void (^)(Adgangsadresse *address))completion;

- (void)findAddressByDescription:(NSString *)road roadNumber:(NSString *)roadNumber postalCode:(NSString *)postalCode onCompletion:(void (^)(void))completion;

- (void)saveEntity:(NSString *)name road:(NSString *)road roadNumber:(NSString *)roadNumber postalCode:(NSString *)postalCode city:(NSString *)city telephone:(NSString *)telephone website:(NSString *)website pork:(BOOL)pork alcohol:(BOOL)alcohol nonHalal:(BOOL)nonHalal image:(UIImage *)image onCompletion:(void (^)(CreateEntityResult result))completion;

- (void)savePicture:(UIImage *)image showReviewFeedback:(BOOL)show onCompletion:(void (^)(CreateEntityResult result))completion;

@end