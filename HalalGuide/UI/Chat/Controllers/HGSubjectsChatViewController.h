//
// Created by Privat on 26/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HGSubjectsViewModel.h"


@interface HGSubjectsChatViewController : UIViewController

@property (strong, nonatomic, readonly) UITableView *subjects;
@property (strong, nonatomic, readonly) HGSubjectsViewModel *viewModel;

- (instancetype)initWithViewModel:(HGSubjectsViewModel *)viewModel;

+ (instancetype)controllerWithViewModel:(HGSubjectsViewModel *)viewModel;

@end