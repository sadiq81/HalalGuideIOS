//
// Created by Privat on 13/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <EDStarRating/EDStarRating.h>
#import "ReviewCell.h"
#import "ReviewDetailViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface ReviewCell ()
@property(strong, nonatomic) UIImageView *submitterImage;
@property(strong, nonatomic) UILabel *submitterName;
@property(strong, nonatomic) EDStarRating *rating;
@property(strong, nonatomic) UILabel *review;
@end

@implementation ReviewCell {

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
    self.submitterImage = [[UIImageView alloc] initWithFrame:CGRectZero];
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
}

- (void)setupRating {
    self.rating.starImage = [UIImage imageNamed:@"HGLocationDetailsInfoView.star.unselected"];
    self.rating.starHighlightedImage = [UIImage imageNamed:@"HGLocationDetailsInfoView.star.selected"];
    self.rating.backgroundColor = [UIColor whiteColor];
}

- (void)setupViewModel {

    RAC(self.submitterName, text) = RACObserve(self, viewModel.submitterName);
    RAC(self.submitterImage, image) = RACObserve(self, viewModel.submitterImage);

    RAC(self.review, text) = RACObserve(self, viewModel.reviewText);
    RAC(self.rating, rating) = [RACObserve(self, viewModel.rating) map:^id(NSNumber *value) {
        return @([value floatValue]);
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
        make.top.equalTo(self.rating.mas_bottom).offset(8);
        make.bottom.equalTo(self.contentView).offset(-8);
    }];

    [super updateConstraints];
}
@end