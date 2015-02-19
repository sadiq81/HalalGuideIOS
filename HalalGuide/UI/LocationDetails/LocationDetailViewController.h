//
//  LocationDetailViewController.h
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"
#import "HalalGuideImageViews.h"
#import "HalalGuideLabels.h"
#import "iCarousel.h"
#import "LocationDetailViewModel.h"
#import <MessageUI/MessageUI.h>

@interface LocationDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, iCarouselDataSource, iCarouselDelegate>

@property(strong) IBOutlet UILabel *name;
@property(strong) IBOutlet UILabel *address;
@property(strong) IBOutlet UILabel *distance;
@property(strong) IBOutlet EDStarRating *rating;
@property(strong) IBOutlet UILabel *category;
@property(strong) IBOutlet PorkImageView *porkImage;
@property(strong) IBOutlet AlcoholImageView *alcoholImage;
@property(strong) IBOutlet HalalImageView *halalImage;
@property(strong) IBOutlet PorkLabel *porkLabel;
@property(strong) IBOutlet AlcoholLabel *alcoholLabel;
@property(strong) IBOutlet HalalLabel *halalLabel;
@property(strong) IBOutlet UILabel *submitterName;
@property(strong) IBOutlet UIImageView *submitterImage;
@property(strong) IBOutlet UIButton *report;
@property(strong) IBOutlet UIButton *addReview;
@property(strong) IBOutlet UIButton *addPicture;
@property(strong) IBOutlet iCarousel *pictures;
@property(strong) IBOutlet UITableView *reviews;
@property (strong, nonatomic) IBOutlet UILabel *noPicturesLabel;
@property (strong, nonatomic) IBOutlet UILabel *noReviewsLabel;
@property (strong, nonatomic) LocationDetailViewModel *viewModel;

- (void)openMaps:(UITapGestureRecognizer *)recognizer;
@end
