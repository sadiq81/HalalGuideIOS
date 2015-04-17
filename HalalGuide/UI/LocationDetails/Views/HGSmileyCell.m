//
// Created by Privat on 17/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>
#import "HGSmileyCell.h"
#import "HGSmiley.h"
#import "UIImageView+WebCache.h"

@interface HGSmileyCell()

@property (strong, nonatomic) UIImageView *smileyType;
@property (strong, nonatomic) UILabel *date;
@property (strong, nonatomic) HGSmiley *smiley;

@end

@implementation HGSmileyCell {

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
    self.smileyType = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.smileyType];

    self.date = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:self.date];

}

- (void)configureForSmiley:(HGSmiley *)hgSmiley {

    self.smiley = hgSmiley;

    [self.smileyType sd_setImageWithURL:[[NSURL alloc] initWithString:hgSmiley.smiley]];

    self.date.font = [UIFont systemFontOfSize:10];
    self.date.textAlignment = NSTextAlignmentCenter;
    self.date.text = hgSmiley.date;
}

- (void)updateConstraints {

    [self.smileyType mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.centerX.equalTo(self);
        make.width.equalTo(@31);
        make.height.equalTo(@31);
    }];

    [self.date mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.smileyType.mas_bottom).offset(8);
        make.centerX.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(@21);
    }];

    [super updateConstraints];
}


@end