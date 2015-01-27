//
//  Location.m
//  HalalGuide
//
//  Created by Privat on 13/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "Location.h"

@implementation Location

@dynamic addressCity, addressPostalCode, addressRoad, addressRoadNumber, alcohol, creationStatus, distance, homePage, language, locationType, name, nonHalal, pork, submitterId, telephone, categories, point, openingHours;

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

@end

