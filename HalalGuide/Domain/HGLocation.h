//
//  HGLocation.h
//  HalalGuide
//
//  Created by Privat on 13/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "HGBaseEntity.h"
#import <MapKit/MapKit.h>

//TODO Add multinational, ethiopian, sisha
typedef enum DiningCategory : int16_t {
    DiningCategoryAfghan = 0, DiningCategoryAfrican = 1, DiningCategoryAmerican = 2, DiningCategoryArgentine = 3,
    DiningCategoryAsian = 4, DiningCategoryBelgian = 5, DiningCategoryBrazilian = 6, DiningCategoryBritish = 7,
    DiningCategoryBuffet = 8, DiningCategoryBurger = 9, DiningCategoryBakery = 10, DiningCategoryBagel = 11,
    DiningCategoryBubbleThea = 12, DiningCategoryArabic = 13, DiningCategoryCafe = 14, DiningCategoryCaribbean = 14,
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

#define CategoryString(enum) [@{@(DiningCategoryAfghan) : @"DiningCategory.afghan",@(DiningCategoryAfrican) : @"DiningCategory.african",@(DiningCategoryAmerican) : @"DiningCategory.american",@(DiningCategoryAmerican) : @"DiningCategory.american",@(DiningCategoryArgentine) :@"DiningCategory.argentine",\
@(DiningCategoryAsian):@"DiningCategory.asian", @(DiningCategoryBelgian) :@"DiningCategory.belgian",@( DiningCategoryBrazilian ):@"DiningCategory.brazilian",@( DiningCategoryBritish ):@"DiningCategory.british",\
@(DiningCategoryBuffet ):@"DiningCategory.buffet",@( DiningCategoryBurger ):@"DiningCategory.burger",@( DiningCategoryBakery ):@"DiningCategory.bakery",@( DiningCategoryBagel ):@"DiningCategory.bagel",\
@(DiningCategoryBubbleThea ):@"DiningCategory.bubbleThea",@( DiningCategoryArabic ):@"DiningCategory.arabic",@( DiningCategoryCafe ):@"DiningCategory.cafe",@( DiningCategoryCaribbean ):@"DiningCategory.caribbean",\
@(DiningCategoryCupcake ):@"DiningCategory.cupcake",@( DiningCategoryCandy ):@"DiningCategory.candy",@( DiningCategoryChinese ):@"DiningCategory.chinese",@( DiningCategoryDanish ):@"DiningCategory.danish",\
@(DiningCategoryDessert ):@"DiningCategory.dessert",@( DiningCategoryFish ):@"DiningCategory.fish",@( DiningCategoryFruit ):@"DiningCategory.fruit",@( DiningCategoryFastFood ):@"DiningCategory.fastfood",\
@(DiningCategoryFrench ):@"DiningCategory.french",@( DiningCategoryGerman ):@"DiningCategory.german",@( DiningCategoryGrill ):@"DiningCategory.grill",@( DiningCategoryGreek ):@"DiningCategory.greek",\
@(DiningCategoryIceCream ):@"DiningCategory.iceCream",@( DiningCategoryJuice ):@"DiningCategory.juice",@( DiningCategoryKiosk ):@"DiningCategory.kiosk",@( DiningCategoryIndian ):@"DiningCategory.indian",\
@(DiningCategoryIndonesian ):@"DiningCategory.indonesian",@( DiningCategoryIrish ):@"DiningCategory.irish",@( DiningCategoryItalian ):@"DiningCategory.italian",@( DiningCategoryIranian ):@"DiningCategory.iranian",\
@(DiningCategoryJapanese ):@"DiningCategory.japanese",@( DiningCategoryKebab ):@"DiningCategory.kebab",@( DiningCategoryKorean ):@"DiningCategory.korean",@( DiningCategoryKosher ):@"DiningCategory.kosher",\
@(DiningCategoryLebanese ):@"DiningCategory.lebanese",@( DiningCategoryMediterranean ):@"DiningCategory.mediterranean",@( DiningCategoryMalaysian ):@"DiningCategory.malaysian",@( DiningCategoryMoroccan ):@"DiningCategory.moroccan",\
@(DiningCategoryMexican ):@"DiningCategory.mexican",@( DiningCategoryNordic ):@"DiningCategory.nordic",@( DiningCategoryNepalese ):@"DiningCategory.nepalese",@( DiningCategoryPastry ):@"DiningCategory.pastry",\
@(DiningCategoryPakistani ):@"DiningCategory.pakistani",@( DiningCategoryPersian ):@"DiningCategory.persian",@( DiningCategoryPizza ):@"DiningCategory.pizza",@( DiningCategoryPortuguese ):@"DiningCategory.portuguese",\
@(DiningCategoryRussian ):@"DiningCategory.russian",@( DiningCategorySeafood ):@"DiningCategory.seafood",@( DiningCategorySalad ):@"DiningCategory.salad",@( DiningCategorySandwich ):@"DiningCategory.sandwich",\
@(DiningCategorySpanish ):@"DiningCategory.spanish",@( DiningCategorySteak ):@"DiningCategory.steak",@( DiningCategorySoup ):@"DiningCategory.soup",@( DiningCategorySushi ):@"DiningCategory.sushi",\
@(DiningCategoryTapas ):@"DiningCategory.tapas",@( DiningCategoryThai ):@"DiningCategory.thai",@( DiningCategoryTibetan ):@"DiningCategory.tibetan",@( DiningCategoryTurkish ):@"DiningCategory.turkish",\
@(DiningCategoryVegan ):@"DiningCategory.vegan",@( DiningCategoryVietnamese ):@"DiningCategory.vietnamese",@( DiningCategoryWok):@"DiningCategory.wok"}  objectForKey :@(enum)]

#define kLocationTableName @"Location"

typedef enum WeekDay : int16_t {

    WeekDayMonday = 0,
    WeekDayTuesday = 1,
    WeekDayWednesday = 2,
    WeekDayThursday = 3,
    WeekDayFriday = 4,
    WeekDaySaturday = 5,
    WeekDaySunday = 6
} WeekDay;


#define DayString(enum) [@{@(WeekDaySunday) : @"WeekDay.sunday",\
@(WeekDayMonday) : @"WeekDay.monday",\
@(WeekDayTuesday) : @"WeekDay.tuesday",\
@(WeekDayWednesday) : @"WeekDay.wednesday",\
@(WeekDayThursday) : @"WeekDay.thursdag",\
@(WeekDayFriday) : @"WeekDay.friday",\
@(WeekDaySaturday) :@"WeekDay.saturday",}  objectForKey :@(enum)]

#define kDiningReuseIdentifier @"reuse.identifier.dining"
#define kShopReuseIdentifier @"reuse.identifier.shop"
#define kMosqueReuseIdentifier @"reuse.identifier.mosque"

#define kDiningImageIdentifier @"HGFrontPageViewController.button.dining"
#define kShopImageIdentifier @"HGFrontPageViewController.button.shop"
#define kMosqueImageIdentifier @"HGFrontPageViewController.button.mosque"

#define kFavoritesPin @"local.data.store.favorite.pin"

@interface HGLocation : HGBaseEntity <PFSubclassing>

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
@property(nonatomic) CLLocation *location;
//@property(nonatomic) BOOL open;
@property(nonatomic, retain) NSDictionary *openingHours;

@property(nonatomic, retain) NSArray *navneloebenummer;

@property(nonatomic, retain) NSString *facebookId;

- (instancetype)initWithAddressCity:(NSString *)addressCity addressPostalCode:(NSString *)addressPostalCode addressRoad:(NSString *)addressRoad addressRoadNumber:(NSString *)addressRoadNumber alcohol:(NSNumber *)alcohol creationStatus:(NSNumber *)creationStatus homePage:(NSString *)homePage language:(NSNumber *)language locationType:(NSNumber *)locationType name:(NSString *)name nonHalal:(NSNumber *)nonHalal pork:(NSNumber *)pork submitterId:(NSString *)submitterId telephone:(NSString *)telephone categories:(NSArray *)categories;

+ (instancetype)locationWithAddressCity:(NSString *)addressCity addressPostalCode:(NSString *)addressPostalCode addressRoad:(NSString *)addressRoad addressRoadNumber:(NSString *)addressRoadNumber alcohol:(NSNumber *)alcohol creationStatus:(NSNumber *)creationStatus homePage:(NSString *)homePage language:(NSNumber *)language locationType:(NSNumber *)locationType name:(NSString *)name nonHalal:(NSNumber *)nonHalal pork:(NSNumber *)pork submitterId:(NSString *)submitterId telephone:(NSString *)telephone categories:(NSArray *)categories;

- (NSString *)categoriesString;

- (void)setOpen:(NSDate *)open andClose:(NSDate *)close forWeekDay:(WeekDay)weekDay;

- (NSDictionary *)openCloseForWeekDay:(WeekDay)weekDay;

- (NSString *)reuseIdentifier;

- (NSString *)imageForType;

@end

