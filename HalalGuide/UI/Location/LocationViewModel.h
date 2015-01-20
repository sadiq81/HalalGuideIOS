//
// Created by Privat on 22/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"

typedef enum LocationPresentation : int16_t {
    LocationPresentationList = 0,
    LocationPresentationMap = 1,
} LocationPresentation;

@protocol DiningViewModelDelegate <NSObject>

@optional

- (void)refreshTable;

- (void)reloadTable;

- (void)reloadAnnotations;

@end

@interface LocationViewModel : BaseViewModel <CategoriesViewModel>

@property(nonatomic) LocationType locationType;
@property(nonatomic, retain) NSMutableArray *locations;
@property id <DiningViewModelDelegate> delegate;
@property(nonatomic) NSUInteger maximumDistance;
@property(nonatomic) bool showNonHalal;
@property(nonatomic) bool showAlcohol;
@property(nonatomic) bool showPork;
@property(nonatomic) int page;
@property(nonatomic, copy) NSString *searchText;

@property(nonatomic) LocationPresentation locationPresentation;
@property(nonatomic) PFGeoPoint *southWest;
@property(nonatomic) PFGeoPoint *northEast;

+ (LocationViewModel *)instance;

- (void)reset;

- (void)refreshLocations:(BOOL)firstLoad;

- (NSUInteger)numberOfLocations;

- (Location *)locationForRow:(NSUInteger)row;

@end