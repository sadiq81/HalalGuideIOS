//
//  BaseEntity.h
//  HalalGuide
//
//  Created by Privat on 07/12/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <Parse/Parse.h>

typedef enum CreateEntityResult : int16_t {
    CreateEntityResultOk = 0,
    CreateEntityResultCouldNotCreateEntityInDatabase = 1,
    CreateEntityResultAddressDoesNotExist = 3,
    CreateEntityResultError = 4
} CreateEntityResult;

#define CreateEntityResultString(enum) [@{@(CreateEntityResultOk) : @"ok",\
@(CreateEntityResultCouldNotCreateEntityInDatabase) : @"couldnotcreateindb",\
@(CreateEntityResultAddressDoesNotExist) : @"addressdoesnotexists",\
@(CreateEntityResultError) :@"error",}  objectForKey :@(enum)]


typedef enum CreationStatus : int16_t {
    CreationStatusAwaitingApproval = 0,
    CreationStatusApproved = 1,
    CreationStatusNotApproved = 2,
} CreationStatus;

#define CreationStatusString(enum) [@{@(CreationStatusAwaitingApproval) : @"awaiting",\
@(CreationStatusApproved) : @"approved",\
@(CreationStatusNotApproved) :@"notapproved",}  objectForKey :@(enum)]

typedef enum Language : int16_t {
    LanguageNone = 0,
    LanguageDanish = 1,
    LanguageArabic = 2,
    LanguageUrdu = 3,
    LanguageEnglish = 4
} Language;

#define LanguageString(enum) [@{@(LanguageNone) : @"none",\
@(LanguageDanish) : @"danish",\
@(LanguageArabic) : @"arabic",\
@(LanguageUrdu) : @"urdu",\
@(LanguageEnglish) :@"english",}  objectForKey :@(enum)]


typedef enum LocationType : int16_t {
    LocationTypeDining = 0,
    LocationTypeMosque = 1,
    LocationTypeShop = 2,
} LocationType;

#define LocationTypeString(enum) [@{@(LocationTypeDining) : @"dining",\
@(LocationTypeMosque) : @"mosque",\
@(LocationTypeShop) :@"shop",}  objectForKey :@(enum)]

typedef enum ShopType : int16_t {
    ShopTypeGroceries = 0,
    ShopTypeFurniture = 1,
    ShopTypeButcher = 2,
} ShopType;

#define ShopString(enum) [@{@(ShopTypeGroceries) : @"groceries",\
@(ShopTypeFurniture) : @"furniture" ,\
@(ShopTypeButcher) : @"butcher",} objectForKey :@(enum)]

@interface BaseEntity : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@end
