//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"

@protocol FrontPageViewModelDelegate <NSObject>

@optional

- (void)refreshTable;

- (void)reloadTable;

@end


@interface FrontPageViewModel : BaseViewModel

@property(nonatomic, copy) NSArray *locations;
@property id <FrontPageViewModelDelegate> delegate;

+ (FrontPageViewModel *)instance;

- (void)refreshLocations:(BOOL) firstLoad;

- (NSUInteger)numberOfLocations;

- (Location *)locationForRow:(NSUInteger)row;

@end