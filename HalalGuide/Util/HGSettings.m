//
// Created by Privat on 15/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "HGSettings.h"

#define kMaximumDistanceShop @"dk.eazyit.halalguide.filter.maximum.distance.shop"
#define kMaximumDistanceDining @"dk.eazyit.halalguide.filter.maximum.distance.dining"
#define kMaximumDistanceMosque @"dk.eazyit.halalguide.filter.maximum.distance.mosque"

#define kHalalFilter @"dk.eazyit.halalguide.filter.halal"
#define kAlcoholFilter @"dk.eazyit.halalguide.filter.alcohol"
#define kPorkFilter @"dk.eazyit.halalguide.filter.pork"

#define kShopFilter @"dk.eazyit.halalguide.filter.shop"
#define kDiningFilter @"dk.eazyit.halalguide.filter.dining"

#define kLanguageFilter @"dk.eazyit.halalguide.filter.language"

@interface HGSettings ()

@end


@implementation HGSettings {

}

@synthesize defaults, maximumDistanceShop = _maximumDistanceShop, maximumDistanceDining = _maximumDistanceDining, maximumDistanceMosque = _maximumDistanceMosque;
@synthesize halalFilter = _halalFilter, alcoholFilter = _alcoholFilter, porkFilter = _porkFilter;
@synthesize categoriesFilter = _categoriesFilter, shopCategoriesFilter = _shopCategoriesFilter;
@synthesize language = _language;

+ (HGSettings *)instance {
    static HGSettings *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
            _instance.defaults = [NSUserDefaults standardUserDefaults];
        }
    }
    return _instance;
}

- (NSNumber *)maximumDistanceShop {
    if (!_maximumDistanceShop) {
        _maximumDistanceShop = [self.defaults valueForKey:kMaximumDistanceShop];
    }
    return _maximumDistanceShop;
}

- (void)setMaximumDistanceShop:(NSNumber *)maximumDistanceShop {
    [self.defaults setValue:_maximumDistanceShop = maximumDistanceShop forKey:kMaximumDistanceShop];
}

- (NSNumber *)maximumDistanceDining {
    if (!_maximumDistanceDining) {
        _maximumDistanceDining = [self.defaults valueForKey:kMaximumDistanceDining];
    }
    return _maximumDistanceDining;
}

- (void)setMaximumDistanceDining:(NSNumber *)maximumDistanceDining {
    [self.defaults setValue:_maximumDistanceDining = maximumDistanceDining forKey:kMaximumDistanceDining];
}

- (NSNumber *)maximumDistanceMosque {
    if (!_maximumDistanceMosque) {
        _maximumDistanceMosque = [self.defaults valueForKey:kMaximumDistanceMosque];
    }
    return _maximumDistanceMosque;
}

- (void)setMaximumDistanceMosque:(NSNumber *)maximumDistanceMosque {
    [self.defaults setValue:_maximumDistanceMosque = maximumDistanceMosque forKey:kMaximumDistanceMosque];
}

- (NSNumber *)halalFilter {
    if (!_halalFilter) {
        _halalFilter = [self.defaults valueForKey:kHalalFilter];
    }
    return _halalFilter;
}

- (void)setHalalFilter:(NSNumber *)halalFilter {
    [self.defaults setValue:_halalFilter = halalFilter forKey:kHalalFilter];
}

- (NSNumber *)alcoholFilter {
    if (!_alcoholFilter) {
        _alcoholFilter = [self.defaults valueForKey:kAlcoholFilter];
    }
    return _alcoholFilter;
}

- (void)setAlcoholFilter:(NSNumber *)alcoholFilter {
    [self.defaults setValue:_alcoholFilter = alcoholFilter forKey:kAlcoholFilter];
}

- (NSNumber *)porkFilter {
    if (!_porkFilter) {
        _porkFilter = [self.defaults valueForKey:kPorkFilter];
    }
    return _porkFilter;
}

- (void)setPorkFilter:(NSNumber *)porkFilter {
    [self.defaults setValue:_porkFilter = porkFilter forKey:kPorkFilter];
}

- (NSMutableArray *)categoriesFilter {
    if (!_categoriesFilter) {
        _categoriesFilter = [self.defaults valueForKey:kDiningFilter];
    }
    return _categoriesFilter;
}

- (void)setCategoriesFilter:(NSMutableArray *)categoriesFilter {
    [self.defaults setValue:_categoriesFilter = categoriesFilter forKey:kDiningFilter];
}

- (NSMutableArray *)shopCategoriesFilter {
    if (!_shopCategoriesFilter) {
        _shopCategoriesFilter = [self.defaults valueForKey:kShopFilter];
    }
    return _shopCategoriesFilter;
}

- (void)setShopCategoriesFilter:(NSMutableArray *)shopCategoriesFilter {
    [self.defaults setValue:_shopCategoriesFilter = shopCategoriesFilter forKey:kShopFilter];
}

- (Language)language {
    return [self.defaults integerForKey:kLanguageFilter];
}

- (void)setLanguage:(Language)language {
    [self.defaults setInteger:_language = language forKey:kLanguageFilter];
}

@end