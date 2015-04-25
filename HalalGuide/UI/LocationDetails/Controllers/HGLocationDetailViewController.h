//
//  HGLocationDetailViewController.h
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"
#import "HGLabels.h"
#import "iCarousel.h"
#import "HGLocationDetailViewModel.h"
#import <MessageUI/MessageUI.h>
#import <ALActionBlocks/UIControl+ALActionBlocks.h>
#import <ParseUI/ParseUI.h>
#import <MZFormSheetController/MZFormSheetSegue.h>
#import "HGBaseViewModel.h"
#import "HGCreateReviewViewModel.h"
#import "HGReview.h"
#import "HGNumberFormatter.h"
#import "HGReviewCell.h"
#import "HGReviewDetailViewModel.h"
#import "HGOnboarding.h"
#import "UIViewController+Extension.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/View+MASAdditions.h>
#import "HGReviewDetailViewController.h"
#import "HGCreateReviewViewController.h"
#import "HGAppDelegate.h"
#import "PFUser+Extension.h"
#import "HGLabels.h"
#import "HGLocation.h"

@interface HGLocationDetailViewController : UIViewController

- (instancetype)initWithViewModel:(HGLocationDetailViewModel *)viewModel;

+ (instancetype)controllerWithViewModel:(HGLocationDetailViewModel *)viewModel;

@end
