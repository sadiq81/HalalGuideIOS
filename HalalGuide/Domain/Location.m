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
        NSString *string = nil;
        switch (self.locationType.intValue) {
            case LocationTypeShop: {
                string = NSLocalizedString(ShopString([number integerValue]), nil);
                break;
            };
            case LocationTypeDining: {
                string = NSLocalizedString(CategoryString([number integerValue]), nil);
                break;
            };
            case LocationTypeMosque: {
                string = NSLocalizedString(LanguageString([number integerValue]), nil);
                break;
            };
        }
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

- (BOOL)open {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *now = [[NSDate alloc] init];
    NSDateComponents *components = [cal components:NSCalendarUnitWeekday fromDate:now];
    NSInteger weekday = [components weekday]; // 1 = Sunday, 2 = Monday, etc.
    NSDictionary *openClose = [self openCloseForWeekDay:(weekday + 5) % 7];

    NSDate *openTime = [openClose objectForKey:@"open"];
    NSDate *closeTime = [openClose objectForKey:@"close"];
    //set date components
    NSDateComponents *dateComponents = [cal components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:now];
    [dateComponents setDay:1];
    [dateComponents setMonth:1];
    [dateComponents setYear:2000];
    //save date relative from date
    NSDate *nowIn2000 = [cal dateFromComponents:dateComponents];
    BOOL open = [openTime compare:nowIn2000] == NSOrderedAscending && [nowIn2000 compare:closeTime] == NSOrderedAscending;

    return open;
    /*
    if (openClose) {
        NSMutableAttributedString *openString = [[NSMutableAttributedString alloc] initWithString:open ? NSLocalizedString(@"open", nil) : NSLocalizedString(@"closed", nil)];
        [openString addAttribute:NSForegroundColorAttributeName value:open ? [UIColor greenColor] : [UIColor redColor] range:NSMakeRange(0, [openString.mutableString length])];
        self.attributedText = openString;
    } else {
        self.text = @"";
    }

    return _open;
    */
}

- (NSString *)reuseIdentifier {
    switch (self.locationType.intValue) {
        case LocationTypeShop:
            return kShopReuseIdentifier;
        case LocationTypeDining:
            return kDiningReuseIdentifier;
        case LocationTypeMosque:
            return kMosqueReuseIdentifier;
        default:
            return nil;
    }
}

- (NSString *)imageForType {
    switch (self.locationType.intValue) {
        case LocationTypeShop:
            return kShopImageIdentifier;
        case LocationTypeDining:
            return kDiningImageIdentifier;
        case LocationTypeMosque:
            return kMosqueImageIdentifier;
        default:
            return nil;
    }
}


@end

