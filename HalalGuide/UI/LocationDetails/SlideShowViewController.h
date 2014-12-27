//
// Created by Privat on 27/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iCarousel/iCarousel.h>


@interface SlideShowViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>
@property(strong, nonatomic) IBOutlet iCarousel *iCarousel;

@end