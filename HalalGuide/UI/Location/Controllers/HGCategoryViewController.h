//
//  HGLocationViewController.h
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "HGLocationViewModel.h"
#import "UIViewController+Extension.h"
#import "UITableView+DragLoad.h"

@class HGCategoryViewModel;

@interface HGCategoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic, readonly) HGCategoryViewModel *viewModel;

- (instancetype)initWithViewModel:(HGCategoryViewModel *)viewModel;

+ (instancetype)controllerWithViewModel:(HGCategoryViewModel *)viewModel;


@end
