//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseEntity.h"
#import "FrontPageViewModel.h"

@interface FrontPageViewController :UIViewController

@property(strong, nonatomic, readonly) FrontPageViewModel *viewModel;

- (instancetype)initWithViewModel:(FrontPageViewModel *)aViewModel;

+ (instancetype)controllerWithViewModel:(FrontPageViewModel *)viewModel;


@end