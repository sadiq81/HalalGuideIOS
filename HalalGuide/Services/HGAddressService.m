//
// Created by Privat on 29/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "HGAddressService.h"
#import "NSArray+LinqExtensions.h"
#import "DCKeyValueObjectMapping.h"
#import "DCArrayMapping.h"
#import "DCParserConfiguration.h"
#import "HGErrorReporting.h"
#import "HGNumberFormatter.h"
#import <AddressBook/ABPerson.h>
#import <Parse/Parse.h>
#import "HGAppDelegate.h"
#import "NSArray+Extensions.h"
#import "HGGeoLocationService.h"

@implementation HGAddressService {

}

+ (HGAddressService *)instance {
    static HGAddressService *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

+ (void)cityNameFor:(NSString *)postalCode onCompletion:(void (^)(Postnummer *postnummer))completion {

    NSString *url = [[NSString stringWithFormat:@"http://dawa.aws.dk/postnumre?nr=%@", postalCode] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        DCKeyValueObjectMapping *parser = [self parserForPostnummer];
        Postnummer *postnummer = [parser parseDictionary:[((NSArray *) responseObject) firstObject]];

        completion(postnummer);
    }    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[HGErrorReporting instance] reportError:error];
        completion(nil);
    }];

}

+ (void)doesAddressExist:(NSString *)road roadNumber:(NSString *)roadNumber postalCode:(NSString *)postalCode onCompletion:(void (^)(HGAdgangsadresse *address))completion {

    NSString *url = [[NSString stringWithFormat:@"http://dawa.aws.dk/adgangsadresser?vejnavn=%@&husnummer=%@&postnr=%@", road, roadNumber, postalCode] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        DCKeyValueObjectMapping *parser = [self parserForAdgangsadresser];
        NSMutableArray *addressses = [NSMutableArray new];

        for (NSDictionary *key in responseObject) {
            HGAdgangsadresse *address = [parser parseDictionary:key];
            [addressses addObject:address];
        }

        HGAdgangsadresse *adgangsadresse = [addressses linq_firstOrNil:^BOOL(HGAdgangsadresse *item) {
            return [road isEqualToString:item.vejstykke.navn] && [roadNumber isEqualToString:item.husnr] && [postalCode isEqualToString:item.postnummer.nr];
        }];
        completion(adgangsadresse);
    }    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[HGErrorReporting instance] reportError:error];
        completion(nil);
    }];
}

+ (void)findPointForAddress:(NSString *)road roadNumber:(NSString *)roadNumber postalCode:(NSString *)postalCode onCompletion:(void (^)(CLPlacemark *place))completion {

    NSDictionary *addressDict = @{
            (NSString *) kABPersonAddressStreetKey : [NSString stringWithFormat:@"%@ %@", road, roadNumber],
            (NSString *) kABPersonAddressZIPKey : postalCode,
            (NSString *) kABPersonAddressCountryKey : @"Denmark"
    };

    [[[CLGeocoder alloc] init] geocodeAddressDictionary:addressDict completionHandler:^(NSArray *placemarks, NSError *error) {
        //Try first placemark
        if (placemarks && !error && [placemarks count] > 0) {
            completion([placemarks objectAtIndex:0]);
        } else {
            completion(nil);
        }
    }];
}

+ (void)addressNearPosition:(CLLocation *)location onCompletion:(void (^)(NSArray *addresses))completion {

    NSString *url = [NSString stringWithFormat:@"http://dawa.aws.dk/adgangsadresser?cirkel=%f,%f,%f&srid=4326", location.coordinate.longitude, location.coordinate.latitude, 150.0f];
//    NSString *url = [[NSString stringWithFormat:@"http://dawa.aws.dk/adgangsadresser?cirkel=%@,%@,%@&srid=4326", location.coordinate.longitude, location.coordinate.latitude, @150] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        DCKeyValueObjectMapping *parser = [self parserForAdgangsadresser];
        NSMutableArray *addressses = [NSMutableArray new];

        for (NSDictionary *key in responseObject) {
            HGAdgangsadresse *address = [parser parseDictionary:key];
            [addressses addObject:address];
        }

        completion(addressses);

    }    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[HGErrorReporting instance] reportError:error];
        completion(nil);
    }];
}

+ (DCKeyValueObjectMapping *)parserForAdgangsadresser {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    DCObjectMapping *idToId = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"Id" onClass:[HGAdgangsadresse class]];
    [config addObjectMapping:idToId];
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[HGAdgangsadresse class] andConfiguration:config];
    return parser;
}

+ (DCKeyValueObjectMapping *)parserForPostnummer {
    DCParserConfiguration *config = [DCParserConfiguration configuration];

    DCObjectMapping *idToId = [DCObjectMapping mapKeyPath:@"id" toAttribute:@"Id" onClass:[Stormodtageradresser class]];
    [config addObjectMapping:idToId];

    DCArrayMapping *mapper = [DCArrayMapping mapperForClassElements:[Stormodtageradresser class] forAttribute:@"stormodtageradresser" onClass:[Postnummer class]];
    [config addArrayMapper:mapper];

    DCArrayMapping *mapper2 = [DCArrayMapping mapperForClassElements:[Kommune class] forAttribute:@"kommuner" onClass:[Postnummer class]];
    [config addArrayMapper:mapper2];

    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[Postnummer class] andConfiguration:config];
    return parser;
}


@end