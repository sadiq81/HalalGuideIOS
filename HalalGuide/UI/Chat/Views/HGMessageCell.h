//
// Created by Privat on 30/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HGMessageViewModel.h"
#import "AsyncImageView.h"

#define HGOtherUserMessageColor [UIColor colorWithRed:201.0f/255.0f green:201.0f/255.0f blue:206.0f/255.0f alpha:1.0f]
#define HGCurrentUserMessageColor [UIColor colorWithRed:0.34 green:0.75 blue:1 alpha:1]

typedef NS_ENUM(NSInteger, HGChatCellAlignment) {
    HGChatCellAlignmentLeft = 0,
    HGChatCellAlignmentRight =1,
};


@interface HGMessageCell : UITableViewCell

//@property(nonatomic, strong, readonly) AsyncImageView *image;
@property(nonatomic, strong, readonly) AsyncImageView *avatar;
//@property (nonatomic, strong, readonly) UIImageView *videoView;
@property(nonatomic, strong, readonly) UILabel *submitterName;
@property(nonatomic, strong, readonly) UITextView *textView;

@property(strong, nonatomic) HGMessageViewModel *viewModel;

@property(nonatomic) HGChatCellAlignment alignment;

@end