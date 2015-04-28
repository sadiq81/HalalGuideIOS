//
// Created by Privat on 28/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HGSubjectsViewModel.h"
#import "HGMessagesViewModel.h"


@interface HGMessagesChatViewController : UIViewController

@property (strong, nonatomic, readonly) UITableView *messages;
@property (strong, nonatomic, readonly) HGMessagesViewModel *viewModel;

- (instancetype)initWithViewModel:(HGMessagesViewModel *)viewModel;

+ (instancetype)controllerWithViewModel:(HGMessagesViewModel *)viewModel;

@end