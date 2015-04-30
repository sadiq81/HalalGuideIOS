//
// Created by Privat on 30/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SZTextView.h"

@interface HGMessageComposeView : UIView

@property (nonatomic, strong, readonly) UIButton *submit;
@property (nonatomic, strong, readonly) SZTextView *text;
@property (nonatomic, strong, readonly) UIButton *mediaChooser;

@end