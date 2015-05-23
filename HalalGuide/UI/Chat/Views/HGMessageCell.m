//
// Created by Privat on 30/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <AsyncImageView/AsyncImageView.h>
#import "HGMessageCell.h"
#import "Masonry.h"
#import "ReactiveCocoa.h"


@interface HGMessageCell ()

//@property(nonatomic, strong) AsyncImageView *image;
@property(nonatomic, strong) AsyncImageView *avatar;
//@property (nonatomic, strong) UIImageView *videoView;
@property(nonatomic, strong) UILabel *submitterName;
@property(nonatomic, strong) UITextView *textView;

@end

@implementation HGMessageCell {

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        [self configureViewModel];
        [self updateConstraints];

    }
    return self;
}

- (void)setupViews {

/*    self.image = [[AsyncImageView alloc] initWithFrame:CGRectZero];
    self.image.clipsToBounds = true;
    self.image.contentMode = UIViewContentModeScaleAspectFill;
    self.image.layer.cornerRadius = 5;
    [self.contentView addSubview:self.image];*/

    self.avatar = [[AsyncImageView alloc] initWithFrame:CGRectZero];
    self.avatar.clipsToBounds = true;
    self.avatar.contentMode = UIViewContentModeScaleAspectFill;
    self.avatar.layer.cornerRadius = 10;
    [self.contentView addSubview:self.avatar];

    self.submitterName = [[UILabel alloc] initWithFrame:CGRectZero];
    self.submitterName.backgroundColor = [UIColor clearColor];
    self.submitterName.textColor = [UIColor lightGrayColor];
    self.submitterName.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.submitterName];

    self.textView = [[UITextView alloc] initWithFrame:CGRectZero];
    self.textView.layer.cornerRadius = 5;
    self.textView.editable = false;
    [self.contentView addSubview:self.textView];
}

- (void)configureViewModel {

    [RACObserve(self, viewModel) subscribeNext:^(HGMessageViewModel *viewModel) {
        bool isCurrentUSer = [viewModel.message.userId isEqualToString:[PFUser currentUser].objectId];
        self.textView.backgroundColor = isCurrentUSer ? HGCurrentUserMessageColor : HGOtherUserMessageColor;
        self.alignment = isCurrentUSer ? HGChatCellAlignmentRight : HGChatCellAlignmentLeft;
        [self updateConstraints];
    }];

    //RAC(self.image, imageURL) = RACObserve(self, viewModel.image);
    RAC(self.avatar, imageURL) = RACObserve(self, viewModel.avatar);
    RAC(self.submitterName, text) = RACObserve(self, viewModel.submitter);
    RAC(self.textView, text) = RACObserve(self, viewModel.text);

}


- (void)updateConstraints {

/*    [self.image mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.left.equalTo(self.contentView).offset(30);
        make.right.equalTo(self.contentView).offset(-30);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];*/

    [self.avatar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(20));
        make.width.equalTo(@(20));
        make.bottom.equalTo(self.contentView).offset(-5);

        if (self.alignment == HGChatCellAlignmentLeft) {
            make.left.equalTo(self.contentView).offset(5);
        } else if (self.alignment == HGChatCellAlignmentRight) {
            make.right.equalTo(self.contentView).offset(-5);
        }
    }];

    [self.submitterName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.left.equalTo(self.textView);
        make.right.equalTo(self.textView);
        make.bottom.equalTo(self.textView.mas_top).offset(-5);
    }];

    if (self.alignment == HGChatCellAlignmentLeft) {
        self.submitterName.textAlignment = NSTextAlignmentLeft;
    } else if (self.alignment == HGChatCellAlignmentRight) {
        self.submitterName.textAlignment = NSTextAlignmentRight;
    }

    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);

        if (self.alignment == HGChatCellAlignmentLeft) {
            make.left.equalTo(self.contentView).offset(30);
            make.right.equalTo(self.contentView).offset(-60);;
        } else if (self.alignment == HGChatCellAlignmentRight) {
            make.left.equalTo(self.contentView).offset(60);
            make.right.equalTo(self.contentView).offset(-30);
        }

        make.bottom.equalTo(self.contentView).offset(-5);
    }];

    [super updateConstraints];
}

@end