//
// Created by Privat on 13/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <EDStarRating/EDStarRating.h>
#import "HGReviewCell.h"
#import "HGReviewDetailViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import "HGLocationPicture.h"
#import "NSString+Extensions.h"

@interface HGReviewCell ()
@property(strong, nonatomic) AsyncImageView *submitterImage;
@property(strong, nonatomic) UILabel *submitterName;
@property(strong, nonatomic) EDStarRating *rating;
@property(strong, nonatomic) UILabel *review;

@property(strong, nonatomic) UILabel *date;

@property(strong, nonatomic) AsyncImageView *image1;
@property(strong, nonatomic) AsyncImageView *image2;
@property(strong, nonatomic) AsyncImageView *image3;
@end

@implementation HGReviewCell {

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        [self setupRating];
        [self setupViewModel];
        [self setNeedsUpdateConstraints];

    }
    return self;
}

- (void)setupViews {
    self.submitterImage = [[AsyncImageView alloc] initWithFrame:CGRectZero];
    self.submitterImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.submitterImage];

    self.submitterName = [[UILabel alloc] initWithFrame:CGRectZero];
    self.submitterName.minimumScaleFactor = 0.5;
    self.submitterName.adjustsFontSizeToFitWidth = true;
    [self.contentView addSubview:self.submitterName];

    self.rating = [[EDStarRating alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.rating];

    self.review = [[UILabel alloc] initWithFrame:CGRectZero];
    self.review.numberOfLines = 0;
    self.review.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.review];

    self.date = [[UILabel alloc] initWithFrame:CGRectZero];
    self.date.minimumScaleFactor = 0.5;
    self.date.adjustsFontSizeToFitWidth = true;
    self.date.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.date];

    self.image1 = [[AsyncImageView alloc] initWithFrame:CGRectZero];
    self.image1.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.image1];

    self.image2 = [[AsyncImageView alloc] initWithFrame:CGRectZero];
    self.image2.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.image2];

    self.image3 = [[AsyncImageView alloc] initWithFrame:CGRectZero];
    self.image3.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.image3];
}

- (void)setupRating {
    self.rating.starImage = [UIImage imageNamed:@"HGReviewCell.star.unselected"];
    self.rating.starHighlightedImage = [UIImage imageNamed:@"HGReviewCell.star.selected"];
    self.rating.backgroundColor = [UIColor whiteColor];
}

- (void)setupViewModel {

    RAC(self.submitterName, text) = RACObserve(self, viewModel.submitterName);
    RAC(self.submitterImage, imageURL) = RACObserve(self, viewModel.submitterImage);

    RAC(self.review, text) = RACObserve(self, viewModel.reviewText);
    RAC(self.rating, rating) = [RACObserve(self, viewModel.rating) map:^id(NSNumber *value) {
        return @([value floatValue]);
    }];

    RAC(self.date, text) = RACObserve(self, viewModel.date);

    [[RACObserve(self, viewModel.reviewImages) ignore:nil] subscribeNext:^(NSArray *images) {

        if ([images count] == 0) {
            return;
        }

        if ([images count] >= 1) {
            HGLocationPicture *picture = (HGLocationPicture *) [images objectAtIndex:0];
            self.image3.imageURL = picture.picture.url.toURL;
        }
        if ([images count] >= 2) {
            HGLocationPicture *picture = (HGLocationPicture *) [images objectAtIndex:1];
            self.image2.imageURL = picture.picture.url.toURL;
        }
        if ([images count] >= 3) {
            HGLocationPicture *picture = (HGLocationPicture *) [images objectAtIndex:2];
            self.image1.imageURL = picture.picture.url.toURL;
        }

    }];
}

- (void)updateConstraints {

    [self.submitterImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.contentView).offset(8);
        make.height.equalTo(@(25));
        make.width.equalTo(@(25));
    }];

    [self.submitterName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.right.equalTo(self.rating.mas_left).offset(-8);
        make.left.equalTo(self.submitterImage.mas_right).offset(8);
        make.height.equalTo(self.submitterImage);
    }];

    [self.rating mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.width.equalTo(@(158));
        make.right.equalTo(self.contentView).offset(-8);
        make.height.equalTo(self.submitterImage);
    }];

    [self.review mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(8);
        make.right.equalTo(self.contentView).offset(-8);
        make.top.equalTo(self.rating.mas_bottom);
        make.bottom.equalTo(self.image1.mas_top);
    }];

    [self.date mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(8);
        make.right.equalTo(self.image1.mas_left).offset(-8);
        make.top.equalTo(self.review.mas_bottom);
        make.bottom.equalTo(self.contentView);
    }];

    [self.image1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(25));
        make.height.equalTo(@(25));
        make.right.equalTo(self.image2.mas_left).offset(-8);
        make.top.equalTo(self.review.mas_bottom);
        make.bottom.equalTo(self.contentView);
    }];

    [self.image2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(25));
        make.height.equalTo(@(25));
        make.right.equalTo(self.image3.mas_left).offset(-8);
        make.top.equalTo(self.review.mas_bottom);
        make.bottom.equalTo(self.contentView);
    }];

    [self.image3 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(25));
        make.height.equalTo(@(25));
        make.right.equalTo(self.contentView).offset(-8);
        make.top.equalTo(self.review.mas_bottom);
        make.bottom.equalTo(self.contentView);
    }];

    [super updateConstraints];
}
@end