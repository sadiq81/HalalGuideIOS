//
//  CreateReviewViewController.h
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "SZTextView.h"
#import "CreateReviewViewModel.h"

@interface CreateReviewViewController : UIViewController

- (instancetype)initWithViewModel:(CreateReviewViewModel *)viewModel;

+ (instancetype)controllerWithViewModel:(CreateReviewViewModel *)viewModel;


@end
