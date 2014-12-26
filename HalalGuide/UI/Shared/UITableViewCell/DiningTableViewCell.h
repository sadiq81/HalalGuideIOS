//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationTableViewCell.h"
#import "CMPopTipView.h"

@class PorkImageView;
@class AlcoholImageView;
@class HalalImageView;


@interface DiningTableViewCell : LocationTableViewCell<CMPopTipViewDelegate>

-(void) showToolTip;

@end