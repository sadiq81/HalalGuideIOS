//
// Created by Privat on 29/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class Vejstykke;
@class Postnummer;
@class Stormodtageradresser;
@class Kommune;
@class Ejerlav;
@class Historik;
@class Adgangspunkt;
@class DDKN;
@class Sogn;
@class Region;
@class Retskreds;
@class Politikreds;
@class Opstillingskreds;


@interface HGAdgangsadresse : NSObject
@property(nonatomic, retain) NSString *href;
@property(nonatomic, retain) NSString *Id;
@property(nonatomic, retain) NSNumber *status;
@property(nonatomic, retain) Vejstykke *vejstykke;
@property(nonatomic, retain) NSString *husnr;
@property(nonatomic, retain) NSString *supplerendebynavn;
@property(nonatomic, retain) Postnummer *postnummer;
@property(nonatomic, retain) Kommune *kommune;
@property(nonatomic, retain) Ejerlav *ejerlav;
@property(nonatomic, retain) NSString *matrikelnr;
@property(nonatomic, retain) NSString *esrejendomsnr;
@property(nonatomic, retain) Historik *historik;
@property(nonatomic, retain) Adgangspunkt *adgangspunkt;
@property(nonatomic, retain) DDKN *ddkn;
@property(nonatomic, retain) Sogn *sogn;
@property(nonatomic, retain) Region *region;
@property(nonatomic, retain) Retskreds *retskreds;
@property(nonatomic, retain) Politikreds *politikreds;
@property(nonatomic, retain) Opstillingskreds *opstillingskreds;
@property(nonatomic, retain) NSString *zone;

- (CLLocation *)location;

- (NSString *)latitude;

- (NSString *)longitude;
@end


@interface Vejstykke : NSObject
@property(nonatomic, retain) NSString *href;
@property(nonatomic, retain) NSString *kode;
@property(nonatomic, retain) NSString *navn;
@end

@interface Postnummer : NSObject
@property(nonatomic, retain) NSString *href;
@property(nonatomic, retain) NSString *nr;
@property(nonatomic, retain) NSString *navn;
@property(nonatomic, retain) NSArray *stormodtageradresser;
@property(nonatomic, retain) NSArray *kommuner;
@end

@interface Stormodtageradresser : NSObject
@property(nonatomic, retain) NSString *href;
@property(nonatomic, retain) NSString *Id;
@end

@interface Kommune : NSObject
@property(nonatomic, retain) NSString *href;
@property(nonatomic, retain) NSString *kode;
@property(nonatomic, retain) NSString *navn;
@end

@interface Ejerlav : NSObject
@property(nonatomic, retain) NSString *kode;
@property(nonatomic, retain) NSString *navn;
@end

@interface Historik : NSObject
@property(nonatomic, retain) NSString *oprettet;
@property(nonatomic, retain) NSString *ændret;
@end

@interface Adgangspunkt : NSObject
@property(nonatomic, retain) NSArray *koordinater;
@property(nonatomic, retain) NSString *nøjagtighed;
@property(nonatomic, retain) NSNumber *kilde;
@property(nonatomic, retain) NSString *tekniskstandard;
@property(nonatomic, retain) NSNumber *tekstretning;
@property(nonatomic, retain) NSString *ændret;
@end

@interface DDKN : NSObject
@property(nonatomic, retain) NSString *m100;
@property(nonatomic, retain) NSString *km1;
@property(nonatomic, retain) NSString *km10;
@end

@interface Sogn : NSObject
@property(nonatomic, retain) NSString *href;
@property(nonatomic, retain) NSString *kode;
@property(nonatomic, retain) NSString *navn;
@end

@interface Region : NSObject
@property(nonatomic, retain) NSString *href;
@property(nonatomic, retain) NSString *kode;
@property(nonatomic, retain) NSString *navn;
@end

@interface Retskreds : NSObject
@property(nonatomic, retain) NSString *href;
@property(nonatomic, retain) NSString *kode;
@property(nonatomic, retain) NSString *navn;
@end

@interface Politikreds : NSObject
@property(nonatomic, retain) NSString *href;
@property(nonatomic, retain) NSString *kode;
@property(nonatomic, retain) NSString *navn;
@end

@interface Opstillingskreds : NSObject
@property(nonatomic, retain) NSString *href;
@property(nonatomic, retain) NSString *kode;
@property(nonatomic, retain) NSString *navn;
@end

@interface SimpleAddress : NSObject
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSMutableArray *numbers;
@property(nonatomic, retain) Postnummer *postnummer;

- (instancetype)initWithName:(NSString *)name numbers:(NSMutableArray *)numbers postalCode:(Postnummer *)postnummer;

@end


