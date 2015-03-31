//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGBaseViewModel.h"
#import "LocationDetailViewModel.h"

@interface FrontPageViewModel : HGBaseViewModel

@property(nonatomic, readonly) NSArray *locations;

- (LocationDetailViewModel *)viewModelForLocationAtIndex:(NSUInteger)index;

- (void)refreshLocations;

@end