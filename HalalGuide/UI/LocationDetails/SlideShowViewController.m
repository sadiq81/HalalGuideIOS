//
// Created by Privat on 27/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <iCarousel/iCarousel.h>
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>
#import <MZFormSheetController/MZFormSheetController.h>
#import "SlideShowViewController.h"
#import "LocationDetailViewModel.h"
#import "LocationPicture.h"
#import "IQUIView+Hierarchy.h"
#import "HalalGuideOnboarding.h"
#import "UIView+Extensions.h"


@implementation SlideShowViewController {

}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = true;

    self.iCarousel.bounces = false;
    self.iCarousel.pagingEnabled = true;

    [self.iCarousel scrollToItemAtIndex:[LocationDetailViewModel instance].indexOfSelectedImage animated:false];
}

//TODO Make delegate methods in LocationDetailViewController use same datasource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [[LocationDetailViewModel instance].locationPictures count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {

    UIImageView *temp;
    LocationPicture *picture = [[LocationDetailViewModel instance] pictureForRow:index];

    if (view == nil) {
        view = temp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width * 0.90f, self.view.height * 0.90f)];
        temp.contentMode = UIViewContentModeScaleAspectFit;
    }

    if ([[LocationDetailViewModel instance].locationPictures count] > 1 && ![[HalalGuideOnboarding instance] wasOnBoardingShow:kSlideShowViewSwipeToViewMoreKey]) {
        [temp showOnBoardingWithHintKey:kSlideShowViewSwipeToViewMoreKey withDelegate:nil];
    }

    //TODO Adjust frame so that portrait and landspace pictures are both max height

    [temp setImageWithURL:[[NSURL alloc] initWithString:picture.picture.url] placeholderImage:[UIImage imageNamed:@"dining"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    return view;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    [self mz_dismissFormSheetControllerAnimated:true completionHandler:nil];
}

@end