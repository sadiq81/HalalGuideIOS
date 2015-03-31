//
// Created by Privat on 06/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "HGImageViews.h"

@implementation HGImageViews
- (void)configureViewForLocation:(Location *)location {}
@end

@implementation PorkImageView
- (void)configureViewForLocation:(Location *)location {
    self.image = [location.pork boolValue] ? [UIImage imageNamed:@"PigTrue"] : [UIImage imageNamed:@"PigFalse"];
}
@end

@implementation AlcoholImageView
- (void)configureViewForLocation:(Location *)location {
    self.image = [location.alcohol boolValue] ? [UIImage imageNamed:@"AlcoholTrue"] : [UIImage imageNamed:@"AlcoholFalse"];
}
@end

@implementation HalalImageView
- (void)configureViewForLocation:(Location *)location {
    self.image = [location.nonHalal boolValue] ? [UIImage imageNamed:@"NonHalalTrue"] : [UIImage imageNamed:@"NonHalalFalse"];
}
@end