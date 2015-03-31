//
// Created by Privat on 20/01/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "LocationAnnotationView.h"
#import "HGPictureService.h"
#import "LocationAnnotation.h"
#import "LocationPicture.h"


@implementation LocationAnnotationView {

}
@synthesize thumbnail;

- (instancetype)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.canShowCallout = YES;

        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
        //[rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
        self.rightCalloutAccessoryView = rightButton;

        UIImageView *profileIconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 33, 33)];
        profileIconView.contentMode = UIViewContentModeScaleAspectFit;
        self.leftCalloutAccessoryView = self.thumbnail = profileIconView;

        self.image = [UIImage imageNamed:@"diningSmall"];
    }

    return self;
}

- (void)configureLocation {

    [[HGPictureService instance] thumbnailForLocation:((LocationAnnotation *) self.annotation).location onCompletion:^(NSArray *objects, NSError *error) {
        if (objects != nil && [objects count] == 1) {
            LocationPicture *picture = [objects firstObject];
            [self.thumbnail sd_setImageWithURL:[[NSURL alloc] initWithString:picture.thumbnail.url]];
        }
    }];
}

@end