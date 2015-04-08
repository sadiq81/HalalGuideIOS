//
//  HGCreateLocationViewController.h
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTAutocompleteTextField.h"
#import "SevenSwitch.h"
#import "HGCreateReviewViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "HGCreateLocationViewModel.h"


@interface HGCreateLocationViewController :UIViewController
- (instancetype)initWithViewModel:(HGCreateLocationViewModel *)viewModel;

+ (instancetype)controllerWithViewModel:(HGCreateLocationViewModel *)viewModel;


@end
