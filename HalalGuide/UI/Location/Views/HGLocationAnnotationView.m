//
// Created by Privat on 20/01/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <AsyncImageView/AsyncImageView.h>
#import "HGLocationAnnotationView.h"
#import "HGPictureService.h"
#import "HGLocationAnnotation.h"
#import "HGLocationPicture.h"
#import "NSString+Extensions.h"

@interface HGLocationAnnotationView ()

@property(nonatomic, strong) AsyncImageView *imageView;
@end

@implementation HGLocationAnnotationView {

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

        AsyncImageView *profileIconView = [[AsyncImageView alloc] initWithFrame:CGRectMake(5, 5, 33, 33)];
        profileIconView.contentMode = UIViewContentModeScaleAspectFill;
        self.leftCalloutAccessoryView = self.thumbnail = profileIconView;

        self.imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(-15, -15, 30, 30)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.image = [UIImage imageNamed:((HGLocationAnnotation *) self.annotation).location.imageForType];
        [self addSubview:self.imageView];


    }

    return self;
}

- (void)configureLocation {

    [[HGPictureService instance] thumbnailForLocation:((HGLocationAnnotation *) self.annotation).location onCompletion:^(NSArray *objects, NSError *error) {
        if (objects != nil && [objects count] == 1) {
            HGLocationPicture *picture = [objects firstObject];
            self.thumbnail.imageURL = picture.thumbnail.url.toURL;
        }
    }];
}

@end