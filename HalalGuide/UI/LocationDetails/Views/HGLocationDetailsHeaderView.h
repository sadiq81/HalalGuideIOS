//
// Created by Privat on 29/03/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LocationDetailViewModel.h"
#import "HGLocationDetailsInfoView.h"
#import "HGLocationDetailsSubmitterView.h"
#import "HGLocationDetailsPictureView.h"


@interface HGLocationDetailsHeaderView : UIView

@property(strong, nonatomic, readonly) HGLocationDetailsInfoView *headerTopView;
@property(strong, nonatomic, readonly) HGLocationDetailsSubmitterView *submitterView;
@property(strong, nonatomic, readonly) HGLocationDetailsPictureView *pictureView;

@property(strong, nonatomic) LocationDetailViewModel *viewModel;

- (instancetype)initWithViewModel:(LocationDetailViewModel *)viewModel;

+ (instancetype)viewWithViewModel:(LocationDetailViewModel *)viewModel;

@end