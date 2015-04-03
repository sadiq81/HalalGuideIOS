//
// Created by Privat on 22/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGBaseViewModel.h"
#import "ReactiveCocoa/ReactiveCocoa.h"

@class LocationDetailViewModel;


typedef enum LocationPresentation : int16_t {
    LocationPresentationList = 0,
    LocationPresentationMap = 1,
} LocationPresentation;

@interface LocationViewModel : HGBaseViewModel <CategoriesViewModel>

@property(nonatomic) LocationType locationType;
@property(nonatomic, readonly) NSArray *listLocations;
@property(nonatomic, readonly) NSArray *mapLocations;
@property(nonatomic) NSNumber * maximumDistance;
@property(nonatomic) NSNumber *showNonHalal;
@property(nonatomic) NSNumber *showAlcohol;
@property(nonatomic) NSNumber *showPork;
@property(nonatomic) int page;
@property(nonatomic) NSString *searchText;

@property(nonatomic) LocationPresentation locationPresentation;
@property(nonatomic) PFGeoPoint *southWest;
@property(nonatomic) PFGeoPoint *northEast;

- (instancetype)initWithLocationType:(LocationType)type;

+ (instancetype)modelWithLocationType:(LocationType)type;

- (LocationDetailViewModel *)viewModelForLocationAtIndex:(NSUInteger)index;

- (void)refreshLocations;

@end