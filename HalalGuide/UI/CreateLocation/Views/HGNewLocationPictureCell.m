//
// Created by Privat on 25/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "HGNewLocationPictureCell.h"
#import "Masonry.h"

@interface HGNewLocationPictureCell()

@property(strong, nonatomic) UIImageView *imageView;
@property(strong, nonatomic) UIImageView *delete;
@end

@implementation HGNewLocationPictureCell {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self setNeedsUpdateConstraints];
    }

    return self;
}

- (void)setupViews {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.imageView];

    self.delete = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.delete.tintColor = [UIColor redColor];
    self.delete.image = [[UIImage imageNamed:@"HGReviewPictureCell.delete"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self addSubview:self.delete];
}


- (void)updateConstraints {

    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(2);
        make.top.equalTo(self).offset(2);
        make.right.equalTo(self).offset(-2);
        make.bottom.equalTo(self).offset(-2);
    }];

    [self.delete mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(7);
        make.right.equalTo(self).offset(-7);
        make.width.equalTo(@(22));
        make.height.equalTo(@(22));
    }];

    [super updateConstraints];
}
@end
