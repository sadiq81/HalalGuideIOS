//
//  LocationDetailViewController.h
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"
#import "HGImageViews.h"
#import "HGLabels.h"
#import "iCarousel.h"
#import "LocationDetailViewModel.h"
#import <MessageUI/MessageUI.h>
#import <ALActionBlocks/UIControl+ALActionBlocks.h>
#import <ParseUI/ParseUI.h>
#import <MZFormSheetController/MZFormSheetSegue.h>
#import "HGBaseViewModel.h"
#import "CreateReviewViewModel.h"
#import "Review.h"
#import "HGNumberFormatter.h"
#import "ReviewCell.h"
#import "ReviewDetailViewModel.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "HGOnboarding.h"
#import "UIViewController+Extension.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/View+MASAdditions.h>
#import "ReviewDetailViewController.h"
#import "CreateReviewViewController.h"
#import "AppDelegate.h"
#import "PFUser+Extension.h"
#import "HGLabels.h"
#import "Location.h"

@interface LocationDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, iCarouselDataSource, iCarouselDelegate>


@property (strong, nonatomic, readonly) LocationDetailViewModel *viewModel;

- (instancetype)initWithViewModel:(LocationDetailViewModel *)viewModel;

+ (instancetype)controllerWithViewModel:(LocationDetailViewModel *)viewModel;

- (void)openMaps:(UITapGestureRecognizer *)recognizer;

@end
