//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"
#import "LocationDetailViewModel.h"

@interface FrontPageViewModel : BaseViewModel

@property(nonatomic, readonly) NSArray *locations;

- (LocationDetailViewModel *)viewModelForLocationAtIndex:(NSUInteger)index;

- (void)refreshLocations;

@end