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

}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [self.viewModel.locationPictures count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {

    LocationPicture *picture = [self.viewModel.locationPictures objectAtIndex:index];

    if (view == nil) {
        view  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width * 0.90f, self.view.height * 0.90f)];
        view.contentMode = UIViewContentModeScaleAspectFit;
    }
    //TODO Adjust frame so that portrait and landspace pictures are both max height

    [(UIImageView *) view setImageWithURL:[[NSURL alloc] initWithString:picture.picture.url] placeholderImage:[UIImage imageNamed:@"dining"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    //TODO Adjust frame so that portrait and landspace pictures are both max height
    return view;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    self.viewModel.indexOfSelectedImage = index;
    [self mz_dismissFormSheetControllerAnimated:true completionHandler:nil];
}

- (void)setViewModel:(LocationDetailViewModel *)viewModel {
    _viewModel = viewModel;
    [self.iCarousel reloadData];
    [self.iCarousel scrollToItemAtIndex:self.viewModel.indexOfSelectedImage animated:false];
}


@end