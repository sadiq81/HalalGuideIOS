//
//  Location.m
//  HalalGuide
//
//  Created by Privat on 13/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "Location.h"

@implementation Location

@dynamic addressCity, addressPostalCode, addressRoad, addressRoadNumber, alcohol, creationStatus, distance, homePage, language, locationType, name, nonHalal, pork, submitterId, telephone, categories, point, openingHours, location;

- (instancetype)initWithAddressCity:(NSString *)addressCity addressPostalCode:(NSString *)addressPostalCode addressRoad:(NSString *)addressRoad addressRoadNumber:(NSString *)addressRoadNumber alcohol:(NSNumber *)alcohol creationStatus:(NSNumber *)creationStatus homePage:(NSString *)homePage language:(NSNumber *)language locationType:(NSNumber *)locationType name:(NSString *)name nonHalal:(NSNumber *)nonHalal pork:(NSNumber *)pork submitterId:(NSString *)submitterId telephone:(NSString *)telephone categories:(NSArray *)categories {
    self = [super init];
    if (self) {
        self.addressCity = addressCity;
        self.addressPostalCode = addressPostalCode;
        self.addressRoad = addressRoad;
        self.addressRoadNumber = addressRoadNumber;
        self.alcohol = alcohol;
        self.creationStatus = creationStatus;
        self.homePage = homePage;
        self.language = language;
        self.locationType = locationType;
        self.name = name;
        self.nonHalal = nonHalal;
        self.pork = pork;
        self.submitterId = submitterId;
        self.telephone = telephone;
        self.categories = categories;
    }

    return self;
}

+ (instancetype)locationWithAddressCity:(NSString *)addressCity addressPostalCode:(NSString *)addressPostalCode addressRoad:(NSString *)addressRoad addressRoadNumber:(NSString *)addressRoadNumber alcohol:(NSNumber *)alcohol creationStatus:(NSNumber *)creationStatus homePage:(NSString *)homePage language:(NSNumber *)language locationType:(NSNumber *)locationType name:(NSString *)name nonHalal:(NSNumber *)nonHalal pork:(NSNumber *)pork submitterId:(NSString *)submitterId telephone:(NSString *)telephone categories:(NSArray *)categories {
    return [[self alloc] initWithAddressCity:addressCity addressPostalCode:addressPostalCode addressRoad:addressRoad addressRoadNumber:addressRoadNumber alcohol:alcohol creationStatus:creationStatus homePage:homePage language:language locationType:locationType name:name nonHalal:nonHalal pork:pork submitterId:submitterId telephone:telephone categories:categories];
}


+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Location";
}

- (NSString *)categoriesString {
    NSMutableString *categoryAsString = [[NSMutableString alloc] init];
    for (NSNumber *number in self.categories) {
        NSString *string = NSLocalizedString(categoryString([number integerValue]), nil);
        [categoryAsString appendString:[NSString stringWithFormat:@"%@, ", string]];
    }
    if ([categoryAsString length] > 0) {
        [categoryAsString deleteCharactersInRange:NSMakeRange([categoryAsString length] - 2, 2)];
    }
    return categoryAsString;
}

- (void)setOpen:(NSDate *)open andClose:(NSDate *)close forWeekDay:(WeekDay)weekDay {
    NSMutableDictionary *openClose = [[NSMutableDictionary alloc] initWithDictionary:self.openingHours];
    if (open && close) {
        [openClose setObject:@{@"open" : open, @"close" : close} forKey:DayString(weekDay)];
    } else {
        [openClose removeObjectForKey:DayString(weekDay)];
    }
    self.openingHours = openClose;
}

- (NSDictionary *)openCloseForWeekDay:(WeekDay)weekDay {
    return [self.openingHours valueForKey:DayString(weekDay)];
}

- (CLLocation *)location {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.point.latitude longitude:self.point.longitude];
    return location;
}


@end

