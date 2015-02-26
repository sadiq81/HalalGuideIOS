//
//  LocationViewController.h
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocationViewModel.h"
#import "UIViewController+Extension.h"
#import "UITableView+DragLoad.h"

@interface LocationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, UITableViewDragLoadDelegate>

@property(strong, nonatomic, readonly) LocationViewModel *viewModel;

- (instancetype)initWithViewModel:(LocationViewModel *)viewModel;

+ (instancetype)controllerWithViewModel:(LocationViewModel *)viewModel;


@end
