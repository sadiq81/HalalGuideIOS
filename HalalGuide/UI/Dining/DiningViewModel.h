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

@interface DiningViewModel : BaseViewModel <CategoriesViewModel>

@property(nonatomic, copy) NSArray *locations;
@property id <DiningViewModelDelegate> delegate;
@property(nonatomic) int maximumDistance;
@property(nonatomic) bool showNonHalal;
@property(nonatomic) bool showAlcohol;
@property(nonatomic) bool showPork;


+ (DiningViewModel *)instance;

- (void)refreshLocations:(BOOL)firstLoad;

- (NSUInteger)numberOfLocations;

- (Location *)locationForRow:(NSUInteger)row;

@end