//
// Created by Privat on 13/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <EDStarRating/EDStarRating.h>
#import <ParseUI/ParseUI.h>
#import "ReviewCell.h"
#import "Review.h"
#import "PictureService.h"
#import "ProfileInfo.h"
#import "ReviewDetailViewModel.h"
#import "UIImageView+WebCache.h"
#import "PFUser+Extension.h"
#import "View+MASAdditions.h"

//TODO use MVVM/RAC on cell
@implementation ReviewCell {

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }

    return self;
}


- (void)configure:(Review *)review1 {
    self.profileImage.image = nil;
    self.submitterName.text = @"";

    [[PFUser query] getObjectInBackgroundWithId:review1.submitterId block:^(PFObject *object, NSError *error) {
        PFUser *user = (PFUser *) object;
        [self.profileImage sd_setImageWithURL:user.facebookProfileUrlSmall];
        self.submitterName.text = user.facebookName;
    }];

    self.rating.rating = [review1.rating floatValue];
    self.rating.starImage = [UIImage imageNamed:@"starSmall"];
    self.rating.starHighlightedImage = [UIImage imageNamed:@"starSmallSelected"];

    self.review.text = review1.review;

    //[self needsUpdateConstraints];
}

/*
- (void)updateConstraints {

    [self.profileImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(8);
        make.right.equalTo(self.submitterName).offset(8);
        make.height.mas_equalTo(@(25));
        make.width.mas_equalTo(@(25));
    }];

    [self.submitterName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rating).offset(8);
        make.height.equalTo(self.profileImage);
    }];

    [self.rating mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(158));
        make.right.equalTo(self.contentView).offset(8);
        make.height.equalTo(self.submitterName);
    }];

    [self.review mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(8);
        make.right.equalTo(self.contentView).offset(8);
        make.top.equalTo(self.profileImage).offset(8);
        make.bottom.equalTo(self.contentView).offset(8);
    }];

    [super updateConstraints];
}
*/
@end