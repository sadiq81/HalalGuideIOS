//
//  DiningViewController.h
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CMPopTipView/CMPopTipView.h>
#import "DiningViewModel.h"
#import "BaseViewController.h"

@interface DiningViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, DiningViewModelDelegate, CMPopTipViewDelegate>

@property(strong, nonatomic) IBOutlet UITableView *diningTableView;
@property(strong, nonatomic) UITableViewController *tableViewController;
@property(strong, nonatomic) UIRefreshControl *refreshControl;
@property(strong, nonatomic) UIRefreshControl *bottomRefreshControl;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *filter;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;



@end
