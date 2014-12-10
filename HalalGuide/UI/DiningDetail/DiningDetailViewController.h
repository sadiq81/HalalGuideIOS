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
#import <MessageUI/MessageUI.h>

@interface DiningDetailViewController : BaseViewController<UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *distance;
@property (strong, nonatomic) IBOutlet EDStarRating *rating;
@property (strong, nonatomic) IBOutlet UILabel *category;
@property (strong, nonatomic) IBOutlet PorkImageView *porkImage;
@property (strong, nonatomic) IBOutlet AlcoholImageView     *alcoholImage;
@property (strong, nonatomic) IBOutlet HalalImageView *halalImage;
@property (strong, nonatomic) IBOutlet PorkLabel *porkLabel;
@property (strong, nonatomic) IBOutlet AlcoholLabel *alcoholLabel;
@property (strong, nonatomic) IBOutlet HalalLabel *halalLabel;
@property (strong, nonatomic) IBOutlet UIButton *report;
@property (strong, nonatomic) IBOutlet UIButton *addReview;
@property (strong, nonatomic) IBOutlet UIButton *addPicture;

@end
