//
// Created by Privat on 11/03/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "LocationDetailViewModel.h"


@interface HGLocationDetailsPictureView : UIView

@property(strong, readonly) UIButton *report;
@property(strong, readonly) UIButton *addReview;
@property(strong, readonly) UIButton *addPicture;
@property(strong, readonly) iCarousel *pictures;
@property(strong, nonatomic, readonly) UILabel *noPicturesLabel;

@property(strong, readonly) LocationDetailViewModel *viewModel;

- (instancetype)initWithViewModel:(LocationDetailViewModel *)viewModel ;

+ (instancetype)viewWithViewModel:(LocationDetailViewModel *)viewModel ;


@end