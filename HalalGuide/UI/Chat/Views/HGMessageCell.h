//
// Created by Privat on 30/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HGMessageViewModel.h"
#import "AsyncImageView.h"


@interface HGMessageCell : UITableViewCell

@property(nonatomic, strong, readonly) AsyncImageView *image;
@property(nonatomic, strong, readonly) AsyncImageView *avatar;
//@property (nonatomic, strong, readonly) UIImageView *videoView;
@property(nonatomic, strong, readonly) UILabel *submitterName;
@property(nonatomic, strong, readonly) UITextView *textView;

@property (strong, nonatomic) HGMessageViewModel *viewModel;

@end