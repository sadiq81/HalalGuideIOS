//
// Created by Privat on 15/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/SDWebImageManager.h>
#import "ReviewDetailViewModel.h"
#import "HGPictureService.h"
#import "PFUser+Extension.h"
#import "HGDateFormatter.h"

@interface ReviewDetailViewModel () {
}
@property(nonatomic) Review *review;
@property(strong, nonatomic) UIImage *submitterImage;
@property(strong, nonatomic) UIImage *submitterImageLarge;
@property(strong, nonatomic) NSString *submitterName;
@property(strong, nonatomic) NSNumber *rating;
@property(strong, nonatomic) NSString *reviewText;
@property(strong, nonatomic) NSString *date;

@end

@implementation ReviewDetailViewModel {

}

- (instancetype)initWithReview:(Review *)review {
    self = [super init];
    if (self) {
        _review = review;
        [self setup];
    }

    return self;
}

+ (instancetype)modelWithReview:(Review *)review {
    return [[self alloc] initWithReview:review];
}

- (void)setup {

    self.rating = self.review.rating;
    self.reviewText = self.review.review;
    self.date = [[HGDateFormatter instance] stringFromDate:self.review.createdAt];

    [[PFUser query] getObjectInBackgroundWithId:self.review.submitterId block:^(PFObject *object, NSError *error) {
        PFUser *user = (PFUser *) object;
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[user facebookProfileUrlSmall] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image) {
                self.submitterImage = image;
            }
        }];

        [manager downloadImageWithURL:[user facebookProfileUrl] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image) {
                self.submitterImageLarge = image;
            }
        }];
        self.submitterName = [user facebookName];
    }];

}


@end