//
// Created by Privat on 09/06/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "HGChangeSuggestion.h"

@implementation HGChangeSuggestion {

}


@dynamic addressCity, addressPostalCode, addressRoad, addressRoadNumber, alcohol, homePage, language, name, nonHalal, pork, submitterId, telephone, categories, existingLocation;

- (instancetype)initWithAddressCity:(NSString *)addressCity addressPostalCode:(NSString *)addressPostalCode addressRoad:(NSString *)addressRoad addressRoadNumber:(NSString *)addressRoadNumber alcohol:(NSNumber *)alcohol homePage:(NSString *)homePage language:(NSNumber *)language name:(NSString *)name nonHalal:(NSNumber *)nonHalal pork:(NSNumber *)pork submitterId:(NSString *)submitterId telephone:(NSString *)telephone categories:(NSArray *)categories {
    self = [super init];
    if (self) {
        self.addressCity = addressCity;
        self.addressPostalCode = addressPostalCode;
        self.addressRoad = addressRoad;
        self.addressRoadNumber = addressRoadNumber;
        self.alcohol = alcohol;
        self.homePage = homePage;
        self.language = language;
        self.name = name;
        self.nonHalal = nonHalal;
        self.pork = pork;
        self.submitterId = submitterId;
        self.telephone = telephone;
        self.categories = categories;
    }

    return self;
}

+ (instancetype)suggestionWithAddressCity:(NSString *)addressCity addressPostalCode:(NSString *)addressPostalCode addressRoad:(NSString *)addressRoad addressRoadNumber:(NSString *)addressRoadNumber alcohol:(NSNumber *)alcohol homePage:(NSString *)homePage language:(NSNumber *)language name:(NSString *)name nonHalal:(NSNumber *)nonHalal pork:(NSNumber *)pork submitterId:(NSString *)submitterId telephone:(NSString *)telephone categories:(NSArray *)categories {
    return [[self alloc] initWithAddressCity:addressCity addressPostalCode:addressPostalCode addressRoad:addressRoad addressRoadNumber:addressRoadNumber alcohol:alcohol homePage:homePage language:language name:name nonHalal:nonHalal pork:pork submitterId:submitterId telephone:telephone categories:categories];
}


+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"ChangeSuggestion";
}
@end