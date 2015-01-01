//
// Created by Privat on 29/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#define CLCOORDINATES_EQUAL(coord1, coord2) (coord1.latitude == coord2.latitude && coord1.longitude == coord2.longitude)

#import <UIKit/UIKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <CoreLocation/CoreLocation.h>
#import "CreateLocationViewModel.h"
#import "AddressService.h"
#import "Adgangsadresse.h"
#import "LocationService.h"
#import "KeyChainService.h"
#import "LocationPicture.h"
#import "PictureService.h"
#import "ErrorReporting.h"


@implementation CreateLocationViewModel {

}

@synthesize locationType, streetNumbers, categories, shopCategories, language, suggestedPlaceMark, suggestionName;

+ (CreateLocationViewModel *)instance {
    static CreateLocationViewModel *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[super alloc] init];

            _instance.streetNumbers = [NSDictionary new];

            _instance.categories = [[NSMutableArray alloc] init];
            _instance.shopCategories = [[NSMutableArray alloc] init];
            _instance.userChoosenLocation = kCLLocationCoordinate2DInvalid;
        }
    }

    return _instance;
}

- (void)reset {
    self.suggestedPlaceMark = nil;
    self.suggestionName = nil;
    self.userChoosenLocation = kCLLocationCoordinate2DInvalid;
}


- (NSArray *)streetNameForPrefix:(NSString *)prefix {
    return [[self.streetNumbers allKeys] linq_where:^BOOL(NSString *item) {
        return [item hasPrefix:prefix];
    }];
}

- (NSArray *)streetNumbersFor:(NSString *)road {
    SimpleAddress *address = [self.streetNumbers valueForKey:road];
    return address.numbers;
}

- (Postnummer *)postalCodeFor:(NSString *)road {
    SimpleAddress *address = [self.streetNumbers valueForKey:road];
    return address.postnummer;
}

- (void)loadAddressesNearPositionOnCompletion:(void (^)(void))completion {

    [[AddressService instance] addressNearPosition:[BaseViewModel currentLocation] onCompletion:^(NSArray *addresses) {

        NSMutableDictionary *streetNumbersTemp = [NSMutableDictionary new];
        for (Adgangsadresse *key in addresses) {

            SimpleAddress *address = [streetNumbersTemp valueForKey:key.vejstykke.navn];
            if (!address) {
                address = [[SimpleAddress alloc] initWithName:key.vejstykke.navn numbers:[@[key.husnr] mutableCopy] postalCode:key.postnummer];
                [streetNumbersTemp setValue:address forKey:key.vejstykke.navn];
            } else {
                [address.numbers addObject:key.husnr];
            }
        }
        self.streetNumbers = streetNumbersTemp;

        if (completion) {
            completion();
        }
    }];
}

- (void)cityNameFor:(NSString *)postalCode onCompletion:(void (^)(Postnummer *postnummer))completion {
    [[AddressService instance] cityNameFor:postalCode onCompletion:completion];
}

- (void)findAddressesForRoad:(NSString *)road number:(NSString *)roadNumber code:(NSString *)postalCode onCompletion:(void (^)(Adgangsadresse *address))completion {
    [[AddressService instance] doesAddressExist:road roadNumber:roadNumber postalCode:postalCode onCompletion:completion];
}


- (void)saveEntity:(NSString *)name road:(NSString *)road roadNumber:(NSString *)roadNumber postalCode:(NSString *)postalCode city:(NSString *)city telephone:(NSString *)telephone website:(NSString *)website pork:(BOOL)pork alcohol:(BOOL)alcohol nonHalal:(BOOL)nonHalal image:(UIImage *)image onCompletion:(void (^)(CreateEntityResult result))completion {

    [SVProgressHUD showWithStatus:NSLocalizedString(@"savingToTheCloud", nil) maskType:SVProgressHUDMaskTypeGradient];

    [[AddressService instance] doesAddressExist:road roadNumber:roadNumber postalCode:postalCode onCompletion:^(Adgangsadresse *address) {

        if (!address && !CLLocationCoordinate2DIsValid(self.userChoosenLocation)) {
            [SVProgressHUD dismiss];

            [PFAnalytics trackEvent:@"CreateEntityResultAddressDoesNotExist" dimensions:@{
                    @"name" : name,
                    @"road" : road,
                    @"roadNumber" : roadNumber,
                    @"postalCode" : postalCode,
                    @"city" : city,
            }];


            completion(CreateEntityResultAddressDoesNotExist);
            return;
        }

        Location *location = [Location object];
        location.name = name;
        location.addressRoad = road;
        location.addressRoadNumber = roadNumber;
        location.addressCity = city;
        location.addressPostalCode = postalCode;
        location.telephone = telephone;
        location.homePage = website;
        location.creationStatus = @(CreationStatusAwaitingApproval);
        location.submitterId = [PFUser currentUser].objectId;

        //TODO validation
        location.locationType = @(self.locationType);

        switch (self.locationType) {
            case LocationTypeMosque: {
                location.language = @(self.language);
                break;
            }
            case LocationTypeDining: {
                location.alcohol = @(alcohol);
                location.pork = @(pork);
                location.nonHalal = @(nonHalal);
                location.categories = self.categories;
                break;
            }
            case LocationTypeShop: {
                location.categories = self.shopCategories;
                break;
            }
        }

        if (!CLLocationCoordinate2DIsValid(self.userChoosenLocation)) {
            NSString *latitude = [address.adgangspunkt.koordinater objectAtIndex:1];
            NSString *longitude = [address.adgangspunkt.koordinater objectAtIndex:0];
            location.point = [PFGeoPoint geoPointWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
        } else {
            location.point = [PFGeoPoint geoPointWithLatitude:self.userChoosenLocation.latitude longitude:self.userChoosenLocation.longitude];
        }


        [[LocationService instance] saveLocation:location onCompletion:^(BOOL succeeded, NSError *error) {

            [SVProgressHUD dismiss];

            if (error) {

                [[ErrorReporting instance] reportError:error];

                [SVProgressHUD showErrorWithStatus:NSLocalizedString(CreateEntityResultString(CreateEntityResultCouldNotCreateEntityInDatabase), nil) maskType:SVProgressHUDMaskTypeGradient];
                completion(CreateEntityResultCouldNotCreateEntityInDatabase);
            } else {

                self.createdLocation = location;

                if (image) {
                    [self savePicture:image onCompletion:completion];
                } else {
                    completion(CreateEntityResultOk);
                }
            }
        }];
    }];
}

- (void)findAddressByDescription:(NSString *)road roadNumber:(NSString *)roadNumber postalCode:(NSString *)postalCode onCompletion:(void (^)(void))completion {

    [SVProgressHUD showWithStatus:NSLocalizedString(@"estimatingAddress", nil) maskType:SVProgressHUDMaskTypeGradient];

    [[AddressService instance] findPointForAddress:road roadNumber:roadNumber postalCode:postalCode onCompletion:^(CLPlacemark *place) {

        [SVProgressHUD dismiss];

        self.suggestedPlaceMark = place;

        completion();
    }];
}

- (void)savePicture:(UIImage *)image onCompletion:(void (^)(CreateEntityResult result))completion {

    [SVProgressHUD showWithStatus:NSLocalizedString(@"savingToTheCloud", nil) maskType:SVProgressHUDMaskTypeGradient];

    [[PictureService instance] savePicture:image forLocation:self.createdLocation onCompletion:^(BOOL succeeded, NSError *error) {

        [SVProgressHUD dismiss];

        if (error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(CreateEntityResultString(CreateEntityResultCouldNotUploadFile), nil) maskType:SVProgressHUDMaskTypeGradient];
            [[ErrorReporting instance] reportError:error];
            completion(CreateEntityResultCouldNotUploadFile);
        } else {

            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"imageSaved", nil)];

            completion(CreateEntityResultOk);
        }
    }];
}


@end