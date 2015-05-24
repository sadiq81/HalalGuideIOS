//
// Created by Privat on 30/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Masonry/View+MASAdditions.h>
#import <SZTextView/SZTextView.h>
#import "HGMessageComposeView.h"

@interface HGMessageComposeView ()

@property(nonatomic, strong) UIButton *submit;
@property(nonatomic, strong) SZTextView *text;
@property(nonatomic, strong) UIButton *mediaChooser;

@end


@implementation HGMessageComposeView {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self updateConstraints];
    }

    return self;
}

- (void)setupViews {

    self.backgroundColor = [UIColor colorWithRed:201.0f/255.0f green:201.0f/255.0f blue:206.0f/255.0f alpha:1.0f];

    self.mediaChooser = [UIButton buttonWithType:UIButtonTypeSystem];
//    [self.mediaChooser setImage:[UIImage imageNamed:@"HGMessageComposeView.button.mediaChooser"] forState:UIControlStateNormal];
    [self addSubview:self.mediaChooser];

    self.text = [[SZTextView alloc] initWithFrame:CGRectZero];
    self.text.inputAccessoryView = [[UIView alloc] init];
    self.text.placeholder = NSLocalizedString(@"HGMessageComposeView.text.placeholder", nil);
    self.text.layer.cornerRadius = 5;
    [self addSubview:self.text];

    self.submit = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.submit setTitle:NSLocalizedString(@"HGMessageComposeView.button.submit", nil) forState:UIControlStateNormal];
    [self addSubview:self.submit];
}

- (void)updateConstraints {

    [self.mediaChooser mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-5);
        make.height.equalTo(@(33));
        make.width.equalTo(@(33));
    }];

    [self.text mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mediaChooser.mas_right).offset(10);
        make.bottom.equalTo(self).offset(-5);
        make.height.equalTo(@(33));
        make.right.equalTo(self.submit.mas_left).offset(-5);
    }];

    [self.submit mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-5);
        make.bottom.equalTo(self).offset(-5);
        make.height.equalTo(@(33));
        make.width.equalTo(@(44));
    }];


    [super updateConstraints];
}


@end