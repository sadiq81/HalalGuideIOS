//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseEntity.h"
#import "FrontPageViewModel.h"

@interface FrontPageViewController :UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) IBOutlet UITableView *latestUpdated;
@property(strong, nonatomic) UITableViewController *tableViewController;
@property(strong, nonatomic) UIRefreshControl *refreshControl;
@property(strong, nonatomic) FrontPageViewModel *viewModel;

@end