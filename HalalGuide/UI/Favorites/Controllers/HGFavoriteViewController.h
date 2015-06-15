//
// Created by Privat on 19/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GoogleAnalytics/GAITrackedViewController.h>
#import "HGFavoriteViewModel.h"


@interface HGFavoriteViewController : GAITrackedViewController

@property(strong, nonatomic, readonly) UITableView *tableView;
@property(strong, nonatomic, readonly) UILabel *noFavorites;
@property (strong, nonatomic, readonly) HGFavoriteViewModel *viewModel;

- (instancetype)initWithViewModel:(HGFavoriteViewModel *)viewModel;

+ (instancetype)controllerWithViewModel:(HGFavoriteViewModel *)viewModel;


@end