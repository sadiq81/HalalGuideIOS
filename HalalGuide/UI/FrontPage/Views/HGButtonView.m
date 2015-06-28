//
// Created by Privat on 24/02/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "HGButtonView.h"
#import "HGColor.h"

@interface HGButtonView ()
@property(nonatomic, retain) UIButton *button;
@property(nonatomic, retain) UILabel *label;
@property(nonatomic, copy) ButtonViewTapHandler tapHandler;
@end


@implementation HGButtonView {

}

- (instancetype)initWithButtonImageName:(NSString *)name andLabelText:(NSString *)labelText andTapHandler:(ButtonViewTapHandler )tapHandler {
    self = [super init];
    if (self) {

        self.tapHandler = tapHandler;

        self.button = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.button setTintColor:[HGColor greenTintColor]];
        [self.button setImage:[[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button];

        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.label.text = NSLocalizedString(labelText, nil);
        [self addSubview:self.label];
    }
    return self;

}

- (void)buttonTapped {
    if (self.tapHandler != nil) {
        self.tapHandler();
    }
}

- (void)updateConstraints {

    [self.button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@48);
        make.height.equalTo(@48);
        make.centerX.equalTo(self);
        make.top.equalTo(self);
    }];

    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.button.mas_bottom).offset(8);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
    }];

    [super updateConstraints];
}

@end