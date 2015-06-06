//
// Created by Privat on 15/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGBaseEntity.h"


@interface HGSettings : NSObject

@property NSUserDefaults *defaults;

@property(nonatomic, strong) NSNumber *maximumDistanceShop;
@property(nonatomic, strong) NSNumber *maximumDistanceDining;
@property(nonatomic, strong) NSNumber *maximumDistanceMosque;

@property(nonatomic, strong) NSNumber *halalFilter;
@property(nonatomic, strong) NSNumber *alcoholFilter;
@property(nonatomic, strong) NSNumber *porkFilter;

@property(nonatomic, strong) NSMutableArray *categoriesFilter;
@property(nonatomic, strong) NSMutableArray *shopCategoriesFilter;

@property (nonatomic) Language language;

@property(nonatomic, strong) NSMutableArray *favorites;

+ (HGSettings *)instance;

@end