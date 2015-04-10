//
//  HGLocationViewController.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIControl+ALActionBlocks.h>
#import <ALActionBlocks/UIBarButtonItem+ALActionBlocks.h>
#import <Masonry/View+MASAdditions.h>
#import "HGBaseViewModel.h"
#import "HGLocationViewController.h"
#import "HGDiningCell.h"
#import "HGCreateLocationViewModel.h"
#import "MKMapView+Extension.h"
#import "HGLocationAnnotation.h"
#import "HGLocationAnnotationView.h"
#import "HGOnboarding.h"
#import "HGAppDelegate.h"
#import "HGFilterLocationViewController.h"
#import "HGLocationDetailViewController.h"
#import "HGCreateLocationViewController.h"
#import "HGMosqueCell.h"
#import "HGShopCell.h"
#import "UITableView+Header.h"
#import "HGGeoLocationService.h"

@interface HGLocationViewController () <UISearchBarDelegate>
//@property(strong, nonatomic) UISegmentedControl *segmentControl;
@property(strong, nonatomic) UIBarButtonItem *addButton;
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) UITableViewController *tableViewController;
@property(strong, nonatomic) UIBarButtonItem *filter;
@property(strong, nonatomic) UIBarButtonItem *presentationMode;
@property(strong, nonatomic) UIToolbar *toolbar;
@property(strong, nonatomic) UISearchBar *searchBar;
@property(strong, nonatomic) UILabel *noResults;
@property(strong, nonatomic) MKMapView *mapView;
@property(strong, nonatomic) HGLocationViewModel *viewModel;

@end


@implementation HGLocationViewController {
}

- (instancetype)initWithViewModel:(HGLocationViewModel *)viewModel {
    self = [super init];
    if (self) {

        self.viewModel = viewModel;
        [self setupViews];
        [self setupViewModel];
        [self setupToolbar];
        [self setupSearchBar];
        [self setupTableView];
        [self setupMapView];
        [self updateViewConstraints];

    }

    return self;
}

+ (instancetype)controllerWithViewModel:(HGLocationViewModel *)viewModel {
    return [[self alloc] initWithViewModel:viewModel];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupHints];
}

- (void)setupViews {
    NSString *title = [NSString stringWithFormat:@"HGLocationViewController.title.%@", LocationTypeString(self.viewModel.locationType)];
    self.title = NSLocalizedString(title, nil);
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.view.backgroundColor = [UIColor whiteColor];

    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd block:nil];
    self.navigationItem.rightBarButtonItem = self.addButton;

    self.mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.mapView];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];

    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    self.tableView.tableHeaderView = self.searchBar;

    self.noResults = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.tableView addSubview:self.noResults];

    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.toolbar];

    self.filter = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"HGLocationViewController.button.filter", nil) style:UIBarButtonItemStylePlain block:nil];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    self.presentationMode = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"HGLocationViewController.button.map", nil) style:UIBarButtonItemStylePlain block:nil];
    [self.toolbar setItems:@[self.filter, spacer, self.presentationMode]];

};

#pragma mark - ViewModel changes

- (void)setupViewModel {

    @weakify(self)
    [[RACObserve(self.viewModel, fetchCount) throttle:0.5] subscribeNext:^(NSNumber *fetching) {
        @strongify(self)
        if (fetching.intValue == 0) {
            [SVProgressHUD dismiss];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self displayOnBoardingForFirstCell];
            });

        } else if (fetching.intValue == 1 && !self.tableView.headerLoadingIndicator.isAnimating && !self.tableView.footerLoadingIndicator.isAnimating) {
            [SVProgressHUD showWithStatus:NSLocalizedString(@"HGLocationViewController.hud.fetching", nil) maskType:SVProgressHUDMaskTypeNone];
        }
    }];

    [[RACObserve(self.viewModel, error) throttle:0.5] subscribeNext:^(NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"HGLocationViewController.hud.error", nil)];
        }
    }];

    RACSignal *locations = RACObserve(self.viewModel, listLocations);
    [[locations ignore:nil] subscribeNext:^(NSArray *locations) {
        @strongify(self)
        [self.tableView reloadData];
        [self.tableView finishRefresh];
        [self.tableView finishLoadMore];
    }];

    RAC(self.noResults, hidden) = [locations map:^(NSArray *locations) {
        return @([locations count]);
    }];

    [[RACObserve(self.viewModel, mapLocations) ignore:nil] subscribeNext:^(NSArray *locations) {
        @strongify(self)
        [self reloadAnnotations];
    }];
}

#pragma mark - SegmentedController

- (void)setupToolbar {

    @weakify(self)
    [self.presentationMode setBlock:^(id weakSender) {
        @strongify(self)
        //TODO animate
        self.mapView.alpha = self.tableView.alpha;
        self.tableView.alpha = fabs(self.tableView.alpha - 1);

        [self.presentationMode setTitle:(self.mapView.alpha == 1 ? NSLocalizedString(@"HGLocationViewController.button.list", nil) : NSLocalizedString(@"HGLocationViewController.button.map", nil))];

        self.viewModel.locationPresentation = self.mapView.alpha == 1 ? LocationPresentationMap : LocationPresentationList;
        [self.viewModel refreshLocations];
    }];

    [self.filter setBlock:^(id weakSender) {
        @strongify(self)
        HGFilterLocationViewController *viewController = [HGFilterLocationViewController controllerWithViewModel:self.viewModel];
        viewController.modalPresentationStyle = UIModalPresentationFullScreen;
        viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:viewController animated:true completion:nil];
    }];

    [self.addButton setBlock:^(id weakSender) {
        @strongify(self)
        void (^completion)(void) = ^void(void) {
            HGCreateLocationViewModel *locationViewModel = [[HGCreateLocationViewModel alloc] initWithLocationType:self.viewModel.locationType];
            HGCreateLocationViewController *controller = [HGCreateLocationViewController controllerWithViewModel:locationViewModel];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:navigationController animated:true completion:nil];
        };

        if ([self.viewModel isAuthenticated]) {
            completion();
        } else {
            [self authenticate:completion];
        }

    }];;

}

#pragma mark - Hints

- (void)setupHints {
    if (![[HGOnboarding instance] wasOnBoardingShow:kAddNewOnBoardingButtonKey]) {
        [self displayHintForView:[self.addButton valueForKey:@"view"] withHintKey:kAddNewOnBoardingButtonKey preferedPositionOfText:HintPositionBelow];
    } else if (![[HGOnboarding instance] wasOnBoardingShow:kFilterOnBoardingButtonKey]) {
        [self displayHintForView:[self.filter valueForKey:@"view"] withHintKey:kFilterOnBoardingButtonKey preferedPositionOfText:HintPositionAbove];
    }
}

- (void)hintWasDismissedByUser:(NSString *)hintKey {

    if ([hintKey isEqualToString:kAddNewOnBoardingButtonKey]) {
        [self displayHintForView:[self.filter valueForKey:@"view"] withHintKey:kFilterOnBoardingButtonKey preferedPositionOfText:HintPositionAbove];
    } else {
        [self displayOnBoardingForFirstCell];
    }
}

#pragma mark - SearchBar

- (void)setupSearchBar {

    self.searchBar.showsCancelButton = true;
    self.searchBar.placeholder = NSLocalizedString(@"HGLocationViewController.searchbar.placeholder", nil);

    RAC(self.viewModel, searchText) = [[[self rac_signalForSelector:@selector(searchBar:textDidChange:)] throttle:1.5] reduceEach:^(UISearchBar *searchBar, NSString *text) {
        return text;
    }];

    @weakify(self)
    [[self rac_signalForSelector:@selector(searchBarSearchButtonClicked:) fromProtocol:@protocol(UISearchBarDelegate)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        [self.searchBar resignFirstResponder];
    }];

    [[self rac_signalForSelector:@selector(searchBarCancelButtonClicked:) fromProtocol:@protocol(UISearchBarDelegate)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        [self.searchBar resignFirstResponder];
        self.searchBar.text = @"";
    }];

    [[self rac_signalForSelector:@selector(viewWillDisappear:)] subscribeNext:^(NSNumber *animated) {
        @strongify(self);
        [self.tableView finishRefresh];
        [self.tableView finishLoadMore];
        [SVProgressHUD dismiss];
    }];
    self.searchBar.delegate = self;

}

#pragma mark - TableView

- (void)setupTableView {

    //TODO is this to late?
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.tableView registerClass:[HGDiningCell class] forCellReuseIdentifier:[HGDiningCell reuseIdentifier]];
    [self.tableView registerClass:[HGMosqueCell class] forCellReuseIdentifier:[HGMosqueCell reuseIdentifier]];
    [self.tableView registerClass:[HGShopCell class] forCellReuseIdentifier:[HGShopCell reuseIdentifier]];

    RACSignal *disappear = [self rac_signalForSelector:@selector(viewWillDisappear:)];
    @weakify(self)
    [[[NSNotificationCenter.defaultCenter rac_addObserverForName:@"locationManager:didUpdateLocations" object:nil] takeUntil:disappear] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.tableViewController = [[UITableViewController alloc] init];
    self.tableViewController.tableView = self.tableView;

    [[self rac_signalForSelector:@selector(dragTableDidTriggerRefresh:) fromProtocol:@protocol(UITableViewDragLoadDelegate)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        self.viewModel.page = 0;
        [self.viewModel refreshLocations];
    }];

    [[self rac_signalForSelector:@selector(dragTableDidTriggerLoadMore:) fromProtocol:@protocol(UITableViewDragLoadDelegate)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        self.viewModel.page++;
        [self.viewModel refreshLocations];
    }];
    [self.tableView setDragDelegate:self refreshDatePermanentKey:@"HGLocationViewController"];
    self.tableView.headerRefreshDateFormatText = NSLocalizedString(@"Last Updated: %@", nil);

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.listLocations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HGLocationDetailViewModel *cellModel = [self.viewModel viewModelForLocationAtIndex:indexPath.row];

    HGLocationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellModel.location.reuseIdentifier forIndexPath:indexPath];

    [cell configureForViewModel:cellModel];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HGLocationCell *cell = (HGLocationCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    HGLocationDetailViewController *detailViewController = [HGLocationDetailViewController controllerWithViewModel:cell.viewModel];
    [self.navigationController pushViewController:detailViewController animated:true];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)displayOnBoardingForFirstCell {

    HGLocationCell *cell = (HGLocationCell *) [self.tableView cellForRowAtIndexPath:[[self.tableView indexPathsForVisibleRows] firstObject]];

    if ([cell isKindOfClass:[HGDiningCell class]] && [[HGOnboarding instance] wasOnBoardingShow:kFilterOnBoardingButtonKey]) {

        HGDiningCell *diningTableViewCell = (HGDiningCell *) cell;

        if (![[HGOnboarding instance] wasOnBoardingShow:kDiningCellPorkOnBoardingKey]) {
            [self displayHintForView:diningTableViewCell.porkImage withHintKey:kDiningCellPorkOnBoardingKey preferedPositionOfText:HintPositionBelow];

        } else if (![[HGOnboarding instance] wasOnBoardingShow:kDiningCellAlcoholOnBoardingKey]) {
            [self displayHintForView:diningTableViewCell.alcoholImage withHintKey:kDiningCellAlcoholOnBoardingKey preferedPositionOfText:HintPositionBelow];

        } else if (![[HGOnboarding instance] wasOnBoardingShow:kDiningCellHalalOnBoardingKey]) {
            [self displayHintForView:diningTableViewCell.halalImage withHintKey:kDiningCellHalalOnBoardingKey preferedPositionOfText:HintPositionBelow];
        }
    }
}

#pragma mark MapView

- (void)setupMapView {

    [self.mapView setRegion:MKCoordinateRegionMake([HGGeoLocationService instance].currentLocation.coordinate, MKCoordinateSpanMake(0.02, 0.02))];
    self.mapView.showsUserLocation = true;

    @weakify(self)
    [[[self rac_signalForSelector:@selector(mapView:regionWillChangeAnimated:) fromProtocol:@protocol(MKMapViewDelegate)] throttle:1] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        self.viewModel.southWest = [self.mapView southWest];
        self.viewModel.northEast = [self.mapView northEast];

        if (self.viewModel.locationPresentation == LocationPresentationList) {
            return;
        } else {
            [self.viewModel refreshLocations];
        }
    }];
    //https://github.com/ReactiveCocoa/ReactiveCocoa/issues/1121
    self.mapView.delegate = self;
}

- (void)reloadAnnotations {

    NSMutableArray *shouldBeRemoved = [NSMutableArray new];
    NSMutableArray *shouldNotAdded = [NSMutableArray new];

    bool shouldZoom = [self.mapView.annotations count] <= 1;

    for (MKPointAnnotation *annotation in self.mapView.annotations) {

        if ([annotation isKindOfClass:[HGLocationAnnotation class]]) {
            if ([self.viewModel.mapLocations indexOfObject:((HGLocationAnnotation *) annotation).location] == NSNotFound) {
                [shouldBeRemoved addObject:annotation];
            } else {
                [shouldNotAdded addObject:((HGLocationAnnotation *) annotation).location];
            }
        }
    }

    [self.mapView removeAnnotations:shouldBeRemoved];

    float minimumDistance = CGFLOAT_MAX, secondMinimumDistance = CGFLOAT_MAX;
    HGLocationAnnotation *closest = nil, *secondClosest = nil;
    for (HGLocation *loc in self.viewModel.mapLocations) {

        HGLocationAnnotation *myAnnotation = [[HGLocationAnnotation alloc] init];
        myAnnotation.location = loc;
        myAnnotation.coordinate = CLLocationCoordinate2DMake(loc.point.latitude, loc.point.longitude);
        myAnnotation.title = loc.name;
        myAnnotation.subtitle = [NSString stringWithFormat:@"%@ %@\n%@ %@", loc.addressRoad, loc.addressRoadNumber, loc.addressPostalCode, loc.addressCity];

        CLLocationDistance distance = [loc.location distanceFromLocation:self.mapView.userLocation.location];

        if (distance < minimumDistance) {
            minimumDistance = (float) distance;
            closest = myAnnotation;
        } else if (minimumDistance < distance && distance < secondMinimumDistance) {
            secondMinimumDistance = (float) distance;
            secondClosest = myAnnotation;
        }

        if ([shouldNotAdded containsObject:loc]) {
            continue;
        }

        [self.mapView addAnnotation:myAnnotation];
    }

    if (shouldZoom && closest && secondClosest) {
        MKCoordinateRegion region = [self regionForAnnotations:@[closest, secondClosest, self.mapView.userLocation.location]];
        [self.mapView setRegion:region animated:true];
    }

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;

    // Handle any custom annotations.
    if ([annotation isKindOfClass:[HGLocationAnnotation class]]) {
        // Try to dequeue an existing pin view first.

        //TODO make class for view
        HGLocationAnnotationView *pinView = (HGLocationAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"MKAnnotationView"];
        if (!pinView) {
            pinView = [[HGLocationAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MKAnnotationView"];
        } else {
            pinView.annotation = annotation;
        }
        [pinView configureLocation];
        return pinView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {

    HGLocation *location = ((HGLocationAnnotation *) view.annotation).location;
    HGLocationDetailViewModel *lViewModel = [HGLocationDetailViewModel modelWithLocation:location];
    HGLocationDetailViewController *detailViewController = [HGLocationDetailViewController controllerWithViewModel:lViewModel];
    [self.navigationController pushViewController:detailViewController animated:true];

}

- (MKCoordinateRegion)regionForAnnotations:(NSArray *)annotations {
    double minLat = 90.0f, maxLat = -90.0f;
    double minLon = 180.0f, maxLon = -180.0f;

    for (id <MKAnnotation> mka in annotations) {
        if (mka.coordinate.latitude < minLat) minLat = mka.coordinate.latitude;
        if (mka.coordinate.latitude > maxLat) maxLat = mka.coordinate.latitude;
        if (mka.coordinate.longitude < minLon) minLon = mka.coordinate.longitude;
        if (mka.coordinate.longitude > maxLon) maxLon = mka.coordinate.longitude;
    }

    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minLat + maxLat) / 2.0, (minLon + maxLon) / 2.0);
    MKCoordinateSpan span = MKCoordinateSpanMake(maxLat - minLat, maxLon - minLon);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);

    return region;
}

- (void)updateViewConstraints {

    [self.searchBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(@(44));
    }];

    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.toolbar.mas_top);
    }];

    [self.tableView sizeHeaderToFit];

    [self.noResults mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
    }];

    [self.toolbar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(44));
    }];

    [self.mapView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.toolbar.mas_top);
    }];

    [super updateViewConstraints];
}

@end
