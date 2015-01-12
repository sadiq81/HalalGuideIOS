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

@class LocationDetail;

@interface LocationDetailViewController : UICollectionViewController <UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, DiningDetailReviewDelegate, iCarouselDataSource, iCarouselDelegate, DiningDetailPictureDelegate>

@property(strong) LocationDetail *headerView;

- (void)openMaps:(UITapGestureRecognizer *)recognizer;
@end
