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

@interface HGLocationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, UITableViewDragLoadDelegate>

@property(strong, nonatomic, readonly) HGLocationViewModel *viewModel;

- (instancetype)initWithViewModel:(HGLocationViewModel *)viewModel;

+ (instancetype)controllerWithViewModel:(HGLocationViewModel *)viewModel;


@end
