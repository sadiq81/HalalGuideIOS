//
// Created by Privat on 22/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGBaseViewModel.h"
#import "ReactiveCocoa/ReactiveCocoa.h"

@class HGLocationDetailViewModel;


@interface HGCategoryViewModel : HGBaseViewModel <CategoriesViewModel>

@property(nonatomic, copy, readonly) NSArray *locations;

@property(nonatomic) PFGeoPoint *southWest;
@property(nonatomic) PFGeoPoint *northEast;

- (instancetype)initWithLocationType:(LocationType)type;

+ (instancetype)modelWithLocationType:(LocationType)type;

- (HGLocationDetailViewModel *)viewModelForLocationAtIndex:(NSUInteger)index;

- (void)refreshLocations;

@end