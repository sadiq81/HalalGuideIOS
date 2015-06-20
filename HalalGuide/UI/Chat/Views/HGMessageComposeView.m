//
// Created by Privat on 30/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Masonry/View+MASAdditions.h>
#import <SZTextView/SZTextView.h>
#import <ALActionBlocks/UIControl+ALActionBlocks.h>
#import "HGMessageComposeView.h"
#import "ReactiveCocoa.h"
#import "AUIAutoGrowingTextView.h"

@interface HGMessageComposeView ()

@property(nonatomic, strong) UIButton *submit;
@property(nonatomic, strong) AUIAutoGrowingTextView *text;
@property(nonatomic, strong) UIButton *mediaChooser;

@property(strong, nonatomic) HGMessagesViewModel *viewModel;

@end


@implementation HGMessageComposeView {
}

- (instancetype)initWithFrame:(CGRect)frame andViewModel:(HGMessagesViewModel *)model {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewModel = model;
        [self setupViews];
        [self updateConstraints];
    }

    return self;
}

- (void)setupViews {

    self.backgroundColor = [UIColor colorWithRed:201.0f / 255.0f green:201.0f / 255.0f blue:206.0f / 255.0f alpha:1.0f];

    self.mediaChooser = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.mediaChooser setImage:[UIImage imageNamed:@"HGMessageComposeView.button.mediaChooser"] forState:UIControlStateNormal];
    [self addSubview:self.mediaChooser];

    self.text = [[AUIAutoGrowingTextView alloc] initWithFrame:CGRectZero];
    self.text.inputAccessoryView = [[UIView alloc] init];

    self.text.font = [UIFont systemFontOfSize:16];
    self.text.layer.cornerRadius = 5;
    self.text.minHeight = 32;
    self.text.maxHeight = 3 * 32;
    [self addSubview:self.text];

    self.submit = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.submit setTitle:NSLocalizedString(@"HGMessageComposeView.button.submit", nil) forState:UIControlStateNormal];
    [self.submit handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        [self.viewModel sendMessage:self.text.text];
        self.text.text = @"";
    }];
    [self addSubview:self.submit];
}

- (void)setupViewModel {

}

- (void)updateConstraints {

    [self.mediaChooser mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);

        make.top.greaterThanOrEqualTo(self).offset(6);
        make.bottom.equalTo(self).offset(-6);

        make.height.equalTo(@(32));
        make.width.equalTo(@(32));
    }];

    [self.text mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mediaChooser.mas_right).offset(8);
        make.right.equalTo(self.submit.mas_left).offset(-8);

        make.top.equalTo(self).offset(6);
        make.bottom.equalTo(self).offset(-6);

        make.height.equalTo(@32);
    }];

    [self.text manuelInit];

    [self.submit mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-8);

        make.top.greaterThanOrEqualTo(self).offset(6);
        make.bottom.equalTo(self).offset(-6);

        make.height.equalTo(@(32));
        make.width.equalTo(@(41));
    }];

    [super updateConstraints];
}


@end