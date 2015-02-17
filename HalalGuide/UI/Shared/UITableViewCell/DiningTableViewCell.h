//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationTableViewCell.h"

@class PorkImageView;
@class AlcoholImageView;
@class HalalImageView;


@interface DiningTableViewCell : LocationTableViewCell

- (PorkImageView *)porkImageView;

- (AlcoholImageView *)alcoholImageView;

- (HalalImageView *)halalImageView;

@end