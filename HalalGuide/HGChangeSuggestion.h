//
// Created by Privat on 09/06/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse.h"
#import "HGBaseEntity.h"
#import "HGLocation.h"

@interface HGChangeSuggestion : HGBaseEntity <PFSubclassing>

@property(nonatomic, retain) NSString *addressCity;
@property(nonatomic, retain) NSString *addressPostalCode;
@property(nonatomic, retain) NSString *addressRoad;
@property(nonatomic, retain) NSString *addressRoadNumber;
@property(nonatomic, retain) NSNumber *alcohol;
@property(nonatomic, retain) NSString *homePage;
@property(nonatomic, retain) NSNumber *language;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSNumber *nonHalal;
@property(nonatomic, retain) NSNumber *pork;
@property(nonatomic, retain) NSString *submitterId;
@property(nonatomic, retain) NSString *telephone;
@property(nonatomic, retain) NSArray *categories;

@property(nonatomic, retain) HGLocation *existingLocation;

- (instancetype)initWithAddressCity:(NSString *)addressCity addressPostalCode:(NSString *)addressPostalCode addressRoad:(NSString *)addressRoad addressRoadNumber:(NSString *)addressRoadNumber alcohol:(NSNumber *)alcohol homePage:(NSString *)homePage language:(NSNumber *)language name:(NSString *)name nonHalal:(NSNumber *)nonHalal pork:(NSNumber *)pork submitterId:(NSString *)submitterId telephone:(NSString *)telephone categories:(NSArray *)categories;

+ (instancetype)suggestionWithAddressCity:(NSString *)addressCity addressPostalCode:(NSString *)addressPostalCode addressRoad:(NSString *)addressRoad addressRoadNumber:(NSString *)addressRoadNumber alcohol:(NSNumber *)alcohol homePage:(NSString *)homePage language:(NSNumber *)language name:(NSString *)name nonHalal:(NSNumber *)nonHalal pork:(NSNumber *)pork submitterId:(NSString *)submitterId telephone:(NSString *)telephone categories:(NSArray *)categories;


@end