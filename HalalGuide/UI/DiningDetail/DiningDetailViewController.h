//
//  DiningDetailViewController.h
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"
#import "HalalGuideImageViews.h"
#import "HalalGuideLabels.h"
#import "BaseViewController.h"
#import "iCarousel.h"
#import "DiningDetailViewModel.h"
#import "BaseCollectionViewController.h"
#import <MessageUI/MessageUI.h>

@class DiningDetailTopView;

@interface DiningDetailViewController : BaseCollectionViewController   <UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate, DiningDetailReviewDelegate,iCarouselDataSource, iCarouselDelegate, DiningDetailPictureDelegate>

@property (strong) DiningDetailTopView *headerView;

- (void)openMaps:(UITapGestureRecognizer *)recognizer;
@end
