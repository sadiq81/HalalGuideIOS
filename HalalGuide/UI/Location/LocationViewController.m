//
//  LocationViewController.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIControl+ALActionBlocks.h>
#import "BaseViewModel.h"
#import "LocationViewController.h"
#import "DiningTableViewCell.h"
#import "LocationDetailViewModel.h"
#import "CreateLocationViewModel.h"
#import "MKMapView+Extension.h"
#import "LocationAnnotation.h"
#import "LocationAnnotationView.h"
#import "HalalGuideOnboarding.h"
#import "AppDelegate.h"
#import "FilterLocationViewController.h"
#import "LocationDetailViewController.h"
#import "CreateLocationViewController.h"

@implementation LocationViewController {
}

@synthesize tableViewController, diningTableView, filter, toolbar, viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewModel];
    [self setupSegmentedController];
    [self setupSearchBar];

    [self configureTableView];
    [self configureMapView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupHints];
}

#pragma mark - ViewModel changes

- (void)setupViewModel {

    @weakify(self)
    [[RACObserve(self.viewModel, fetchCount) throttle:0.5] subscribeNext:^(NSNumber *fetching) {
        @strongify(self)
        if (fetching.intValue == 0) {
            [SVProgressHUD dismiss];
        } else if (fetching.intValue == 1 && !self.diningTableView.headerLoadingIndicator.isAnimating && !self.diningTableView.footerLoadingIndicator.isAnimating) {
            [SVProgressHUD showWithStatus:NSLocalizedString(@"fetching", nil) maskType:SVProgressHUDMaskTypeNone];
        }
    }];

    [[RACObserve(self.viewModel, error) throttle:0.5] subscribeNext:^(NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"error", nil)];
        }
    }];

    RACSignal *locations = RACObserve(self.viewModel, listLocations);
    [locations subscribeNext:^(NSArray *locations) {
        @strongify(self)
        [self.diningTableView reloadData];
        [self.diningTableView finishRefresh];
        [self.diningTableView finishLoadMore];
    }];

    RAC(self.noResults, hidden) = [locations map:^(NSArray *locations) {
        return @([locations count]);
    }];

    [RACObserve(self.viewModel, mapLocations) subscribeNext:^(NSArray *locations) {
        @strongify(self)
        [self reloadAnnotations];
    }];
}


#pragma mark - SegmentedController

- (void)setupSegmentedController {

    RACSignal *segmentChanged = [self.segmentControl rac_newSelectedSegmentIndexChannelWithNilValue:nil];

    @weakify(self)
    RAC(self.viewModel, locationPresentation) = segmentChanged;
    [[segmentChanged deliverOnMainThread] subscribeNext:^(NSNumber *selectedSegmentIndex) {
        @strongify(self)
        UIView *fromView = selectedSegmentIndex.intValue == 0 ? self.mapView : self.tableView;
        UIView *toView = selectedSegmentIndex.intValue == 0 ? self.tableView : self.mapView;
        [UIView transitionFromView:fromView toView:toView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
            [self.viewModel refreshLocations];
        }];
    }];
}

#pragma mark - Hints

- (void)setupHints {
    if (![[HalalGuideOnboarding instance] wasOnBoardingShow:kAddNewOnBoardingButtonKey]) {
        [self displayHintForView:[self.addButton valueForKey:@"view"] withHintKey:kAddNewOnBoardingButtonKey preferedPositionOfText:HintPositionBelow];
    } else if (![[HalalGuideOnboarding instance] wasOnBoardingShow:kFilterOnBoardingButtonKey]) {
        [self displayHintForView:[self.filter valueForKey:@"view"] withHintKey:kFilterOnBoardingButtonKey preferedPositionOfText:HintPositionAbove];
    }
}

- (void)hintWasDismissedByUser:(NSString *)hintKey {
    if ([hintKey isEqualToString:kAddNewOnBoardingButtonKey]) {
        [self displayHintForView:[self.filter valueForKey:@"view"] withHintKey:kFilterOnBoardingButtonKey preferedPositionOfText:HintPositionAbove];
    } else if ([hintKey isEqualToString:kFilterOnBoardingButtonKey]) {

    }
}

#pragma mark - SearchBar

- (void)setupSearchBar {

    self.searchBar.showsCancelButton = true;

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
        [self.diningTableView finishRefresh];
        [self.diningTableView finishLoadMore];
        [SVProgressHUD dismiss];
    }];

}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {

    if ([identifier isEqualToString:@"CreateLocation"] || [identifier isEqualToString:@"CreateReview"]) {

        if (![self.viewModel isAuthenticated]) {

            [self.viewModel authenticate:self];

            return false;
        } else {
            return true;
        }
    } else {
        return true;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];

    if (([segue.identifier isEqualToString:@"DiningDetail"] || [segue.identifier isEqualToString:@"ShopDetail"] || [segue.identifier isEqualToString:@"MosqueDetail"])) {

        Location *location = (self.viewModel.locationPresentation == LocationPresentationList) ? [self.viewModel.listLocations objectAtIndex:[self.diningTableView indexPathForSelectedRow].row] : ((LocationAnnotation *) [[self.mapView selectedAnnotations] objectAtIndex:0]).location;
        LocationDetailViewModel *detailViewModel = [[LocationDetailViewModel alloc] initWithLocation:location];

        LocationDetailViewController *detailViewController = (LocationDetailViewController *) segue.destinationViewController;
        detailViewController.viewModel = detailViewModel;

    } else if ([segue.identifier isEqualToString:@"CreateLocation"]) {

        CreateLocationViewModel *_viewModel = [[CreateLocationViewModel alloc] init];
        _viewModel.locationType = self.viewModel.locationType;

        UINavigationController *_navigationController = (UINavigationController *) segue.destinationViewController;
        CreateLocationViewController *_controller = [_navigationController.viewControllers objectAtIndex:0];
        _controller.viewModel = _viewModel;

    } else if ([segue.identifier isEqualToString:@"Filter"]) {
        FilterLocationViewController *controller = segue.destinationViewController;
        controller.viewModel = self.viewModel;
    }
}

#pragma mark - TableView

- (void)configureTableView {

    RACSignal *disappear = [self rac_signalForSelector:@selector(viewWillDisappear:)];
    @weakify(self)
    [[[NSNotificationCenter.defaultCenter rac_addObserverForName:@"locationManager:didUpdateLocations" object:nil] takeUntil:disappear] subscribeNext:^(id x) {
        @strongify(self);
        [self.diningTableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }];

    self.diningTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.tableViewController = [[UITableViewController alloc] init];
    self.tableViewController.tableView = self.diningTableView;

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
    [self.diningTableView setDragDelegate:self refreshDatePermanentKey:@"LocationViewController"];
    self.diningTableView.headerRefreshDateFormatText = NSLocalizedString(@"Last Updated: %@", nil);

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.listLocations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    Location *location = [self.viewModel.listLocations objectAtIndex:indexPath.row];

    NSString *identifier = LocationTypeString(self.viewModel.locationType);
    LocationTableViewCell *cell = [self.diningTableView dequeueReusableCellWithIdentifier:identifier];

    [cell configure:location];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark MapView

- (void)configureMapView {
    CLLocationManager *manager = ((AppDelegate *) [UIApplication sharedApplication].delegate).locationManager;
    [self.mapView setRegion:MKCoordinateRegionMake(manager.location.coordinate, MKCoordinateSpanMake(0.02, 0.02))];
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

        if ([annotation isKindOfClass:[LocationAnnotation class]]) {
            if ([self.viewModel.mapLocations indexOfObject:((LocationAnnotation *) annotation).location] == NSNotFound) {
                [shouldBeRemoved addObject:annotation];
            } else {
                [shouldNotAdded addObject:((LocationAnnotation *) annotation).location];
            }
        }
    }

    [self.mapView removeAnnotations:shouldBeRemoved];

    float minimumDistance = CGFLOAT_MAX, secondMinimumDistance = CGFLOAT_MAX;
    LocationAnnotation *closest = nil, *secondClosest = nil;
    for (Location *loc in self.viewModel.mapLocations) {

        LocationAnnotation *myAnnotation = [[LocationAnnotation alloc] init];
        myAnnotation.location = loc;
        myAnnotation.coordinate = CLLocationCoordinate2DMake(loc.point.latitude, loc.point.longitude);
        myAnnotation.title = loc.name;
        myAnnotation.subtitle = [NSString stringWithFormat:@"%@ %@\n%@ %@", loc.addressRoad, loc.addressRoadNumber, loc.addressPostalCode, loc.addressCity];

        CLLocationDistance distance = [loc.location distanceFromLocation:self.mapView.userLocation.location];

        if (distance < minimumDistance) {
            minimumDistance = distance;
            closest = myAnnotation;
        } else if (minimumDistance < distance && distance < secondMinimumDistance) {
            secondMinimumDistance = distance;
            secondClosest = myAnnotation;
        }

        if ([shouldNotAdded containsObject:loc]) {
            continue;
        }

        [self.mapView addAnnotation:myAnnotation];
    }

    if (shouldZoom && closest && secondClosest){
        MKCoordinateRegion region = [self regionForAnnotations:@[closest, secondClosest, self.mapView.userLocation.location]];
        [self.mapView setRegion:region animated:true];
    }

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;

    // Handle any custom annotations.
    if ([annotation isKindOfClass:[LocationAnnotation class]]) {
        // Try to dequeue an existing pin view first.

        //TODO make class for view
        LocationAnnotationView *pinView = (LocationAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"MKAnnotationView"];
        if (!pinView) {
            pinView = [[LocationAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MKAnnotationView"];
        } else {
            pinView.annotation = annotation;
        }
        [pinView configureLocation];
        return pinView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {

    [self performSegueWithIdentifier:@"DiningDetail" sender:self];
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

@end
