//
//  HGCreateReviewViewController.h
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "SZTextView.h"
#import "HGCreateReviewViewModel.h"

@interface HGCreateReviewViewController : UIViewController

- (instancetype)initWithViewModel:(HGCreateReviewViewModel *)viewModel;

+ (instancetype)controllerWithViewModel:(HGCreateReviewViewModel *)viewModel;


@end
