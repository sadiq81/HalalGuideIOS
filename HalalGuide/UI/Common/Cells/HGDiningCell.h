//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGLocationCell.h"


@interface HGDiningCell : HGLocationCell

@property(strong, nonatomic, readonly) UIImageView *porkImage;
@property(strong, nonatomic, readonly) UIImageView *alcoholImage;
@property(strong, nonatomic, readonly) UIImageView *halalImage;

@property(strong, nonatomic, readonly) UILabel *porkLabel;
@property(strong, nonatomic, readonly) UILabel *alcoholLabel;
@property(strong, nonatomic, readonly) UILabel *halalLabel;

@end