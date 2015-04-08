//
// Created by Privat on 29/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "HGCreateLocationViewModel.h"
#import "HGAddressService.h"
#import "HGLocationService.h"
#import "HGAppDelegate.h"
#import "HGPictureService.h"
#import "HGGeoLocationService.h"

@interface HGCreateLocationViewModel ()
@property(nonatomic) LocationType locationType;
@property(nonatomic, strong) NSDictionary *streetNumbers;
@property(nonatomic, strong) HGLocation *createdLocation;
@end

@implementation HGCreateLocationViewModel {

}

@synthesize locationType, streetNumbers, categories, shopCategories, language;

- (instancetype)initWithLocationType:(LocationType)type {
    self = [super init];
    if (self) {
        locationType = type;
        streetNumbers = [NSDictionary new];
        categories = [[NSMutableArray alloc] init];
        shopCategories = [[NSMutableArray alloc] init];
    }

    return self;
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
    CLLocation *location = [HGGeoLocationService instance].currentLocation;

    [HGAddressService addressNearPosition:location onCompletion:^(NSArray *addresses) {

        NSMutableDictionary *streetNumbersTemp = [NSMutableDictionary new];
        for (HGAdgangsadresse *key in addresses) {

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

- (void)cityNameFor:(NSString *)postalCode onCompletion:(void (^)(Postnummer *postNummer))completion {
    [HGAddressService cityNameFor:postalCode onCompletion:completion];
}

- (void)saveEntity:(NSString *)name road:(NSString *)road roadNumber:(NSString *)roadNumber postalCode:(NSString *)postalCode city:(NSString *)city telephone:(NSString *)telephone website:(NSString *)website pork:(BOOL)pork alcohol:(BOOL)alcohol nonHalal:(BOOL)nonHalal images:(NSArray *)images {

    self.error = nil;
    self.saving = true;

    HGLocation *location = [HGLocation locationWithAddressCity:city addressPostalCode:postalCode addressRoad:road addressRoadNumber:roadNumber alcohol:@(alcohol) creationStatus:@(CreationStatusAwaitingApproval) homePage:website language:@(self.language) locationType:@(self.locationType) name:name nonHalal:@(nonHalal) pork:@(pork) submitterId:[PFUser currentUser].objectId telephone:telephone categories:self.typeBaseCategories];

    [[[[[self doesAddressExist:road roadNumber:roadNumber postalCode:postalCode] flattenMap:^RACStream *(HGAdgangsadresse *value) {
        location.point = [self pointForAddress:value];
        return [self saveLocation:location];
    }] then:^RACSignal * {
        return images ? [self saveImages:images forLocation:location] : [RACSignal empty];
    }] finally:^{
        self.createdLocation = location;
        self.saving = false;
    }] subscribeError:^(NSError *error) {
        self.error = error;
        self.createdLocation = nil;
        [location deleteEventually];
    }];
}

- (NSArray *)typeBaseCategories {
    switch (self.locationType) {
        case LocationTypeMosque: {
            return nil;
        }
        case LocationTypeDining: {
            return self.categories;
        }
        case LocationTypeShop: {
            return self.shopCategories;
        }
        default: {
            return nil;
        }
    }
}

- (PFGeoPoint *)pointForAddress:(HGAdgangsadresse *)address {
    if (address) {
        return [PFGeoPoint geoPointWithLatitude:[address.latitude doubleValue] longitude:[address.longitude doubleValue]];
    } else {
        return nil;
    }
}

- (RACSignal *)doesAddressExist:(NSString *)road roadNumber:(NSString *)roadNumber postalCode:(NSString *)postalCode {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        [HGAddressService doesAddressExist:road roadNumber:roadNumber postalCode:postalCode onCompletion:^(HGAdgangsadresse *address) {
            [subscriber sendNext:address];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (RACSignal *)saveLocation:(HGLocation *)location {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        [[HGLocationService instance] saveLocation:location onCompletion:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [subscriber sendNext:@(succeeded)];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}

- (RACSignal *)saveImages:(NSArray *)images forLocation:(HGLocation *)location {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        [[HGPictureService instance] saveMultiplePictures:images forLocation:location completion:^(BOOL completed, NSError *error, NSNumber *progress) {
            if (progress) {
                self.progress = progress.floatValue;
                [subscriber sendNext:progress];
            }
            if (completed) {
                [subscriber sendCompleted];
            }
            if (error) {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}


@end