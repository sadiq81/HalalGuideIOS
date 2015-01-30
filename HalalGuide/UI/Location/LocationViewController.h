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

@interface LocationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DiningViewModelDelegate, UISearchBarDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property(strong, nonatomic) IBOutlet UITableView *diningTableView;
@property(strong, nonatomic) UITableViewController *tableViewController;
@property(strong, nonatomic) UIRefreshControl *refreshControl;
@property(strong, nonatomic) UIRefreshControl *bottomRefreshControl;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *filter;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UILabel *noResults;
@property (strong, nonatomic) IBOutlet UIView *tableView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
