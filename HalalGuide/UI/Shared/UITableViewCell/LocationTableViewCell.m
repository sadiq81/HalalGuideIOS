//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "LocationTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "PictureService.h"
#import "LocationPicture.h"
#import "HalalGuideNumberFormatter.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "HalalGuideLabels.h"

@implementation LocationTableViewCell {

}

- (void)configure:(Location *)location {

    UIImageView *thumbNail = (UIImageView *) [self.contentView viewWithTag:101];
    thumbNail.image = [UIImage imageNamed:[self placeholderImageName]];

    [[PictureService instance] thumbnailForLocation:location onCompletion:^(NSArray *objects, NSError *error) {
        if (objects != nil && [objects count] == 1) {
            LocationPicture *picture = [objects firstObject];
            [thumbNail setImageWithURL:[[NSURL alloc] initWithString:picture.thumbnail.url] placeholderImage:[UIImage imageNamed:@"dining"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
    }];

    UILabel *distance = (UILabel *) [self.contentView viewWithTag:200];
    distance.text = [[HalalGuideNumberFormatter instance] stringFromNumber:location.distance];
    UILabel *name = (UILabel *) [self.contentView viewWithTag:201];
    name.text = location.name;
    UILabel *address = (UILabel *) [self.contentView viewWithTag:202];
    address.text = [NSString stringWithFormat:@"%@ %@", location.addressRoad, location.addressRoadNumber];
    UILabel *postalCode = (UILabel *) [self.contentView viewWithTag:203];
    postalCode.text = [NSString stringWithFormat:@"%@ %@", location.addressPostalCode, location.addressCity];

    OpenLabel *open = (OpenLabel *) [self.contentView viewWithTag:207];
    [open configureViewForLocation:location];


}

- (void)prepareForReuse {
    [super prepareForReuse];
    UIImageView *thumbNail = (UIImageView *) [self.contentView viewWithTag:101];
    thumbNail.image = nil;
    [thumbNail sd_cancelCurrentImageLoad];
}

- (NSString *)placeholderImageName {
    @throw @"Should be override";
}


@end
