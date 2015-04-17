//
// Created by Privat on 17/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HGSmiley.h"


@interface HGSmileyCell : UICollectionViewCell

@property (strong, nonatomic, readonly) UIImageView *smileyType;
@property (strong, nonatomic, readonly) UILabel *date;
@property (strong, nonatomic, readonly) HGSmiley *smiley;

- (void)configureForSmiley:(HGSmiley *)hgSmiley;

@end