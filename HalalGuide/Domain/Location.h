//
//  Location.h
//  HalalGuide
//
//  Created by Privat on 13/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseEntity.h"
#import <MapKit/MapKit.h>

typedef enum DiningCategory : int16_t {
    DiningCategoryAfghan = 0, DiningCategoryAfrican = 1, DiningCategoryAmerican = 2, DiningCategoryArgentine = 3,
    DiningCategoryAsian = 4, DiningCategoryBelgian = 5, DiningCategoryBrazilian = 6, DiningCategoryBritish = 7,
    DiningCategoryBuffet = 8, DiningCategoryBurger = 9, DiningCategoryBakery = 10, DiningCategoryBagel = 11,
    DiningCategoryBubbleThea = 12, DiningCategoryButcher = 13, DiningCategoryCafe = 14, DiningCategoryCaribbean = 14,
    DiningCategoryCupcake = 15, DiningCategoryCandy = 16, DiningCategoryChinese = 17, DiningCategoryDanish = 18,
    DiningCategoryDessert = 19, DiningCategoryFish = 20, DiningCategoryFruit = 21, DiningCategoryFastFood = 22,
    DiningCategoryFrench = 23, DiningCategoryGerman = 24, DiningCategoryGrill = 25, DiningCategoryGreek = 26,
    DiningCategoryIceCream = 27, DiningCategoryJuice = 28, DiningCategoryKiosk = 29, DiningCategoryIndian = 30,
    DiningCategoryIndonesian = 31, DiningCategoryIrish = 32, DiningCategoryItalian = 33, DiningCategoryIranian = 34,
    DiningCategoryJapanese = 35, DiningCategoryKebab = 36, DiningCategoryKorean = 37, DiningCategoryKosher = 38,
    DiningCategoryLebanese = 39, DiningCategoryMediterranean = 40, DiningCategoryMalaysian = 41, DiningCategoryMoroccan = 42,
    DiningCategoryMexican = 43, DiningCategoryNordic = 44, DiningCategoryNepalese = 45, DiningCategoryPastry = 46,
    DiningCategoryPakistani = 47, DiningCategoryPersian = 48, DiningCategoryPizza = 49, DiningCategoryPortuguese = 50,
    DiningCategoryRussian = 51, DiningCategorySeafood = 52, DiningCategorySalad = 53, DiningCategorySandwich = 54,
    DiningCategorySpanish = 55, DiningCategorySteak = 56, DiningCategorySoup = 57, DiningCategorySushi = 58,
    DiningCategoryTapas = 59, DiningCategoryThai = 60, DiningCategoryTibetan = 61, DiningCategoryTurkish = 62,
    DiningCategoryVegan = 63, DiningCategoryVietnamese = 64, DiningCategoryWok = 65

} DiningCategory;

#define categoryString(enum) [@{@(DiningCategoryAfghan) : @"afghan",@(DiningCategoryAfrican) : @"african",@(DiningCategoryAmerican) : @"american",@(DiningCategoryAmerican) : @"american",@(DiningCategoryArgentine) :@"argentine",\
@(DiningCategoryAsian):@"asian", @(DiningCategoryBelgian) :@"belgian",@( DiningCategoryBrazilian ):@"brazilian",@( DiningCategoryBritish ):@"british",\
@(DiningCategoryBuffet ):@"buffet",@( DiningCategoryBurger ):@"burger",@( DiningCategoryBakery ):@"bakery",@( DiningCategoryBagel ):@"bagel",\
@(DiningCategoryBubbleThea ):@"bubbleThea",@( DiningCategoryButcher ):@"butcher",@( DiningCategoryCafe ):@"cafe",@( DiningCategoryCaribbean ):@"caribbean",\
@(DiningCategoryCupcake ):@"cupcake",@( DiningCategoryCandy ):@"candy",@( DiningCategoryChinese ):@"chinese",@( DiningCategoryDanish ):@"danish",\
@(DiningCategoryDessert ):@"dessert",@( DiningCategoryFish ):@"fish",@( DiningCategoryFruit ):@"fruit",@( DiningCategoryFastFood ):@"fastfood",\
@(DiningCategoryFrench ):@"french",@( DiningCategoryGerman ):@"german",@( DiningCategoryGrill ):@"grill",@( DiningCategoryGreek ):@"greek",\
@(DiningCategoryIceCream ):@"iceCream",@( DiningCategoryJuice ):@"juice",@( DiningCategoryKiosk ):@"kiosk",@( DiningCategoryIndian ):@"indian",\
@(DiningCategoryIndonesian ):@"indonesian",@( DiningCategoryIrish ):@"irish",@( DiningCategoryItalian ):@"italian",@( DiningCategoryIranian ):@"iranian",\
@(DiningCategoryJapanese ):@"japanese",@( DiningCategoryKebab ):@"kebab",@( DiningCategoryKorean ):@"korean",@( DiningCategoryKosher ):@"kosher",\
@(DiningCategoryLebanese ):@"lebanese",@( DiningCategoryMediterranean ):@"mediterranean",@( DiningCategoryMalaysian ):@"malaysian",@( DiningCategoryMoroccan ):@"moroccan",\
@(DiningCategoryMexican ):@"mexican",@( DiningCategoryNordic ):@"nordic",@( DiningCategoryNepalese ):@"nepalese",@( DiningCategoryPastry ):@"pastry",\
@(DiningCategoryPakistani ):@"pakistani",@( DiningCategoryPersian ):@"persian",@( DiningCategoryPizza ):@"pizza",@( DiningCategoryPortuguese ):@"portuguese",\
@(DiningCategoryRussian ):@"russian",@( DiningCategorySeafood ):@"seafood",@( DiningCategorySalad ):@"salad",@( DiningCategorySandwich ):@"sandwich",\
@(DiningCategorySpanish ):@"spanish",@( DiningCategorySteak ):@"steak",@( DiningCategorySoup ):@"soup",@( DiningCategorySushi ):@"sushi",\
@(DiningCategoryTapas ):@"tapas",@( DiningCategoryThai ):@"thai",@( DiningCategoryTibetan ):@"tibetan",@( DiningCategoryTurkish ):@"turkish",\
@(DiningCategoryVegan ):@"vegan",@( DiningCategoryVietnamese ):@"vietnamese",@( DiningCategoryWok):@"wok"}  objectForKey :@(enum)]

#define kLocationTableName @"Location"

@interface Location : BaseEntity

@property(nonatomic, retain) NSString *addressCity;
@property(nonatomic, retain) NSString *addressPostalCode;
@property(nonatomic, retain) NSString *addressRoad;
@property(nonatomic, retain) NSString *addressRoadNumber;
@property(nonatomic, retain) NSNumber *alcohol;
@property(nonatomic, retain) NSNumber *creationStatus;
@property(nonatomic, retain) NSNumber *distance;
@property(nonatomic, retain) NSString *homePage;
@property(nonatomic, retain) PFGeoPoint *point;
@property(nonatomic, retain) NSNumber *locationType;
@property(nonatomic, retain) NSNumber *language;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSNumber *nonHalal;
@property(nonatomic, retain) NSNumber *pork;
@property(nonatomic, retain) NSString *submitterId;
@property(nonatomic, retain) NSString *telephone;
@property(nonatomic, retain) NSArray *categories;

- (NSString *)categoriesString;

@end

