//
// Created by Privat on 11/03/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HGLocationDetailViewModel.h"
#import "AsyncImageView.h"

@interface HGLocationDetailsSubmitterView : UIView

@property(strong, readonly) UILabel *submitterHeadLine;
@property(strong, readonly) UILabel *submitterName;
@property(strong, readonly) AsyncImageView *submitterImage;
@property(strong, readonly) HGLocationDetailViewModel *viewModel;

- (instancetype)initWithViewModel:(HGLocationDetailViewModel *)viewModel;

+ (instancetype)viewWithViewModel:(HGLocationDetailViewModel *)viewModel;


@end