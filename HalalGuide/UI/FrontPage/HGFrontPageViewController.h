//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HGBaseEntity.h"
#import "HGFrontPageViewModel.h"

@interface HGFrontPageViewController :UIViewController

@property(strong, nonatomic, readonly) HGFrontPageViewModel *viewModel;

- (instancetype)initWithViewModel:(HGFrontPageViewModel *)aViewModel;

+ (instancetype)controllerWithViewModel:(HGFrontPageViewModel *)viewModel;


@end