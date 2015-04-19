//
// Created by Privat on 19/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGBaseViewModel.h"
#import "HGLocationDetailViewModel.h"


@interface HGFavoriteViewModel : HGBaseViewModel

@property (strong, nonatomic, readonly) NSArray *favorites;

- (void)setupFavorites;

- (HGLocationDetailViewModel *)viewModelForLocationAtIndex:(NSUInteger)index;

@end