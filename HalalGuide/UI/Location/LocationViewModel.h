//
// Created by Privat on 22/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"

@protocol DiningViewModelDelegate <NSObject>

@optional

- (void)refreshTable;

- (void)reloadTable;

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


+ (LocationViewModel *)instance;

- (void)reset;

- (void)refreshLocations:(BOOL)firstLoad;

- (NSUInteger)numberOfLocations;

- (Location *)locationForRow:(NSUInteger)row;

@end