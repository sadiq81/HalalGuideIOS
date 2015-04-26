//
// Created by Privat on 26/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HGChatViewModel.h"


@interface HGChatViewController : UIViewController

@property (strong, nonatomic, readonly) UITableView *subjects;
@property (strong, nonatomic, readonly) HGChatViewModel *viewModel;

- (instancetype)initWithViewModel:(HGChatViewModel *)viewModel;

+ (instancetype)controllerWithViewModel:(HGChatViewModel *)viewModel;

@end