//
// Created by Privat on 19/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "HGFavoriteViewModel.h"
#import "HGSettings.h"
#import "BFTask.h"
#import "HGErrorReporting.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "HGQuery.h"

@interface HGFavoriteViewModel ()

@property(strong, nonatomic) NSArray *favorites;

@end

@implementation HGFavoriteViewModel {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.favorites = [NSArray new];
    }

    return self;
}

- (void)setupFavorites {

    HGQuery *query = [HGQuery queryWithClassName:kLocationTableName];
    [query fromPinWithName:kFavoritesPin];

    self.fetchCount++;
    @weakify(self)
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        @strongify(self)
        self.fetchCount--;
        if ((self.error = error)) {
            [[HGErrorReporting instance] reportError:error];
        } else {
            self.favorites = objects;
        }
    }];
}

- (HGLocationDetailViewModel *)viewModelForLocationAtIndex:(NSUInteger)index {
    return [HGLocationDetailViewModel modelWithLocation:self.favorites[index]];
}

@end