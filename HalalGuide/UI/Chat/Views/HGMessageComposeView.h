//
// Created by Privat on 30/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SZTextView.h"
#import "JSQMessagesComposerTextView.h"
#import "AUIAutoGrowingTextView.h"
#import "HGMessagesViewModel.h"

@interface HGMessageComposeView : UIView

@property (nonatomic, strong, readonly) UIButton *submit;
@property (nonatomic, strong, readonly) AUIAutoGrowingTextView *text;
@property (nonatomic, strong, readonly) UIButton *mediaChooser;

@property(strong, nonatomic, readonly) HGMessagesViewModel *viewModel;

- (instancetype)initWithFrame:(CGRect)frame andViewModel:(HGMessagesViewModel *)model;

@end