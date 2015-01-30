//
//  LocationViewController.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIControl+ALActionBlocks.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "BaseViewModel.h"
#import "LocationViewController.h"
#import "DiningTableViewCell.h"
#import "UIView+Extensions.h"
#import "LocationDetailViewModel.h"
#import "HalalGuideOnboarding.h"
#import "RACSignal.h"
#import "CreateLocationViewModel.h"
#import "CategoriesViewController.h"
#import "MKMapView+Extension.h"
#import "PictureService.h"
#import "LocationPicture.h"
#import "LocationAnnotation.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "LocationAnnotationView.h"
#import "UIViewController+Extension.h"
#import "UIImage+ScreenShot.h"
#import "UIImage+Transformation.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+RoundedCorner.h"
#import "UIImage+Combine.h"
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation LocationViewController {
    NSString *priorSearchText;
    BOOL firstShown;
    UIImageView *tipView;
}

@synthesize tableViewController, diningTableView, refreshControl, bottomRefreshControl, filter, toolbar;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
    [self configureMapView];
    [[LocationViewModel instance] refreshLocations:true];
    [LocationViewModel instance].delegate = self;

    [self.segmentControl handleControlEvents:UIControlEventValueChanged withBlock:^(UISegmentedControl *weakSender) {
        UIView *fromView = weakSender.selectedSegmentIndex == 0 ? self.mapView : self.tableView;
        UIView *toView = weakSender.selectedSegmentIndex == 0 ? self.tableView : self.mapView;
        [LocationViewModel instance].locationPresentation = weakSender.selectedSegmentIndex;

        [UIView transitionFromView:fromView toView:toView
                          duration:1.0
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:^(BOOL finished) {
                            [self updateMap:self.mapView];
                        }];
    }];

    //Used for onBoarding
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudDismissed:) name:SVProgressHUDDidDisappearNotification object:nil];

}


- (void)dealloc {
    [[LocationViewModel instance] reset];
}

- (void)viewDidAppear:(BOOL)animated {

    if ((self.searchBar.text == nil || [self.searchBar.text length] == 0) && !firstShown) {
        [self.diningTableView setContentOffset:CGPointMake(0, 44) animated:true];
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.bottomRefreshControl endRefreshing];

}

#pragma mark SearchBar

- (void)searchBar:(UISearchBar *)aSearchBar textDidChange:(NSString *)searchText {

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateSearch:) object:priorSearchText];

    priorSearchText = searchText;

    [self performSelector:@selector(updateSearch:) withObject:searchText afterDelay:1.5];

}


- (void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar {

    [self updateSearch:nil];

    aSearchBar.text = @"";
    [aSearchBar resignFirstResponder];

    [self.diningTableView setContentOffset:CGPointMake(0, 44) animated:true];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar {
    [self updateSearch:aSearchBar.text];
    [aSearchBar resignFirstResponder];
}

- (void)updateSearch:(NSString *)searchText {
    [LocationViewModel instance].searchText = searchText;
    [[LocationViewModel instance] refreshLocations:false];
}


#pragma mark OnBoarding

- (void)hudDismissed:(NSNotification *)notification {

    if (!firstShown) {
        [self setupHints];
    }
}

- (void)setupHints {
    UIImage *image = [UIImage snapshot];
    UIView *buttonView = [self.addButton valueForKey:@"view"];
    CGRect buttonViewAbsolute = [buttonView convertRect:buttonView.bounds toView:nil];
    UIImage *cropped = [image crop:buttonViewAbsolute];
    UIImage *button = [UIImage makeRoundedImage:cropped radius:fmaxf(cropped.size.height, cropped.size.width) / 2];
    UIImage *blurred = [image applyBlurWithRadius:3 tintColor:[UIColor colorWithWhite:0.44 alpha:0.53] saturationDeltaFactor:1.5 maskImage:nil];

    UIImage *combined = [blurred drawImage:button InRect:buttonViewAbsolute];
    UIImage *final = [combined crop:CGRectMake(0, 20, image.size.width, image.size.height)];

    tipView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height + 44)];
    [tipView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTipView:)]];
    tipView.userInteractionEnabled = true;
    tipView.alpha = 0.0;
    tipView.image = final;

    [[UIApplication sharedApplication].keyWindow addSubview:tipView];

    [UIView animateWithDuration:0.5 animations:^{
        tipView.alpha = 1.0;
    }];


#warning implement

}

- (void)dismissTipView:(UIGestureRecognizer *)recognizer {
    [UIView animateWithDuration:0.5 animations:^{
        tipView.alpha = 0.0;
    }                completion:^(BOOL finished) {
        [tipView removeFromSuperview];
    }];


}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {

    if ([identifier isEqualToString:@"CreateLocation"] || [identifier isEqualToString:@"CreateReview"]) {

        if (![[LocationViewModel instance] isAuthenticated]) {

            [[LocationViewModel instance] authenticate:self];

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

    if (([segue.identifier isEqualToString:@"DiningDetail"] || [segue.identifier isEqualToString:@"ShopDetail"] || [segue.identifier isEqualToString:@"MosqueDetail"]) && [LocationViewModel instance].locationPresentation == LocationPresentationList) {
        Location *location = [[LocationViewModel instance] locationForRow:[self.diningTableView indexPathForSelectedRow].row];
        [LocationDetailViewModel instance].location = location;
    } else if ([segue.identifier isEqualToString:@"CreateLocation"]) {
        [CreateLocationViewModel instance].locationType = [LocationViewModel instance].locationType;
    }
}

#pragma mark - DiningViewModelDelegate

- (void)refreshTable {
    [self.diningTableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadTable {
    [self.diningTableView reloadData];
    [self.refreshControl endRefreshing];
    [self.bottomRefreshControl endRefreshing];

    self.noResults.hidden = ![[LocationViewModel instance].locations count] == 0;
}

#pragma mark - TableView

- (void)configureTableView {

    self.searchBar.text = [LocationViewModel instance].searchText;
    self.searchBar.showsCancelButton = true;

    self.diningTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.tableViewController = [[UITableViewController alloc] init];
    self.tableViewController.tableView = self.diningTableView;

    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl handleControlEvents:UIControlEventValueChanged withBlock:^(id weakControl) {
        [LocationViewModel instance].page = 0;
        [[LocationViewModel instance] refreshLocations:false];
    }];
    self.tableViewController.refreshControl = self.refreshControl;

    self.bottomRefreshControl = [UIRefreshControl new];
    self.diningTableView.bottomRefreshControl = self.bottomRefreshControl;
    [self.bottomRefreshControl handleControlEvents:UIControlEventValueChanged withBlock:^(id weakControl) {
        [LocationViewModel instance].page++;
        [[LocationViewModel instance] refreshLocations:false];
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[LocationViewModel instance] numberOfLocations];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    Location *location = [[LocationViewModel instance] locationForRow:indexPath.row];

    NSString *identifier = LocationTypeString([LocationViewModel instance].locationType);
    LocationTableViewCell *cell = [self.diningTableView dequeueReusableCellWithIdentifier:identifier];

    [cell configure:location];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark MapView

- (void)configureMapView {
    [self.mapView setRegion:MKCoordinateRegionMake([BaseViewModel currentLocation].coordinate, MKCoordinateSpanMake(0.02, 0.02))];
    self.mapView.showsUserLocation = true;
}

- (BOOL)mapViewRegionDidChangeFromUserInteraction {
    //TODO Ugly
    UIView *view = self.mapView.subviews.firstObject;
    //  Look through gesture recognizers to determine whether this region change is from user interaction
    for (UIGestureRecognizer *recognizer in view.gestureRecognizers) {
        if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateEnded) {
            return YES;
        }
    }
    return NO;
}

static BOOL mapChangedFromUserInteraction = NO;

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    mapChangedFromUserInteraction = [self mapViewRegionDidChangeFromUserInteraction];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {

    if (mapChangedFromUserInteraction) {
        if ([LocationViewModel instance].locationPresentation == LocationPresentationList) {
            return;
        }

        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateSearch:) object:mapView];

        [self performSelector:@selector(updateMap:) withObject:mapView afterDelay:1.0];
    }
}

- (void)updateMap:(MKMapView *)mapView {

    [LocationViewModel instance].southWest = [mapView southWest];
    [LocationViewModel instance].northEast = [mapView northEast];

    [[LocationViewModel instance] refreshLocations:false];
}

- (void)reloadAnnotations {

    NSMutableArray *shouldBeRemoved = [NSMutableArray new];
    NSMutableArray *shouldNotAdded = [NSMutableArray new];

    for (MKPointAnnotation *annotation in self.mapView.annotations) {

        if ([annotation isKindOfClass:[LocationAnnotation class]]) {
            if ([[LocationViewModel instance].locations indexOfObject:((LocationAnnotation *) annotation).location] == NSNotFound) {
                [shouldBeRemoved addObject:annotation];
            } else {
                [shouldNotAdded addObject:((LocationAnnotation *) annotation).location];
            }
        }
    }

    [self.mapView removeAnnotations:shouldBeRemoved];

    for (Location *loc in [LocationViewModel instance].locations) {

        if ([shouldNotAdded containsObject:loc]) {
            continue;
        }

        LocationAnnotation *myAnnotation = [[LocationAnnotation alloc] init];
        myAnnotation.location = loc;
        myAnnotation.coordinate = CLLocationCoordinate2DMake(loc.point.latitude, loc.point.longitude);
        myAnnotation.title = loc.name;
        myAnnotation.subtitle = [NSString stringWithFormat:@"%@ %@\n%@ %@", loc.addressRoad, loc.addressRoadNumber, loc.addressPostalCode, loc.addressCity];

        [self.mapView addAnnotation:myAnnotation];
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
            // If an existing pin view was not available, create one.
            pinView = [[LocationAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MKAnnotationView"];
            //pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;

            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton setTitle:annotation.title forState:UIControlStateNormal];
            [rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
            pinView.rightCalloutAccessoryView = rightButton;

            UIImageView *profileIconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 33, 33)];
            profileIconView.contentMode = UIViewContentModeScaleAspectFit;
            pinView.leftCalloutAccessoryView = pinView.thumbnail = profileIconView;

            pinView.image = [UIImage imageNamed:@"diningSmall"];

        } else {
            pinView.annotation = annotation;
        }

        [[PictureService instance] thumbnailForLocation:((LocationAnnotation *) annotation).location onCompletion:^(NSArray *objects, NSError *error) {
            if (objects != nil && [objects count] == 1) {
                LocationPicture *picture = [objects firstObject];
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:[[NSURL alloc] initWithString:picture.thumbnail.url] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    pinView.thumbnail.image = image;
                }];
            }
        }];

        return pinView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    LocationAnnotation *annotation = (LocationAnnotation *) view.annotation;
    [LocationDetailViewModel instance].location = annotation.location;
}

- (IBAction)showDetails:(id)sender {
    [self performSegueWithIdentifier:@"DiningDetail" sender:self];
}


@end
