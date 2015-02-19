//
//  LocationDetailViewController.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIControl+ALActionBlocks.h>
#import <ParseUI/ParseUI.h>
#import <MZFormSheetController/MZFormSheetSegue.h>
#import "LocationDetailViewController.h"
#import "CreateReviewViewModel.h"
#import "Review.h"
#import "HalalGuideNumberFormatter.h"
#import "ReviewCell.h"
#import "ReviewDetailViewModel.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "HalalGuideOnboarding.h"
#import "UIViewController+Extension.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SlideShowViewController.h"
#import "ReviewDetailViewController.h"
#import "CreateReviewViewController.h"
#import "AppDelegate.h"

@implementation LocationDetailViewController {
}

@synthesize viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewModel];

    [self setupTableView];
    [self setupUI];
    [self setupPictures];

    self.navigationItem.title = self.viewModel.location.name;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.viewModel.indexOfSelectedImage != 0) {
        [self.pictures scrollToItemAtIndex:self.viewModel.indexOfSelectedImage animated:false];
    }
    [self setupHints];
}


#pragma mark - Hints

- (void)setupHints {
    if (![[HalalGuideOnboarding instance] wasOnBoardingShow:kDiningDetailAddressTelephoneOptionsOnBoardingKey]) {
        [self displayHintForView:self.address withHintKey:kDiningDetailAddressTelephoneOptionsOnBoardingKey preferedPositionOfText:HintPositionBelow];
    }
}

#pragma mark - ViewModel changes

- (void)setupViewModel {

    [[RACObserve(self.viewModel, progress) skip:1] subscribeNext:^(NSNumber *progress) {
        NSLog(progress.stringValue);
        if (progress.intValue != 0 && progress.intValue != 100) {
            if ([SVProgressHUD isVisible]) {
                [SVProgressHUD setStatus:[self percentageString:progress.floatValue]];
            } else {
                [SVProgressHUD showWithStatus:[self percentageString:progress.floatValue] maskType:SVProgressHUDMaskTypeBlack];
            }
        } else if (progress.intValue == 100) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"imagesSaved", nil)];
        } else {
            [SVProgressHUD dismiss];
        }
    }];

    /*
    [[RACObserve(self.viewModel, saving) skip:1] subscribeNext:^(NSNumber *saving) {
        if (saving.boolValue) {
            [self showProgressHUD:NSLocalizedString(@"savingToTheCloud", nil)];
        } else {
            [self dismissProgressHUD];
        }
    }];
    */

    [[[RACObserve(self.viewModel, fetchCount) skip:1] throttle:0.5] subscribeNext:^(NSNumber *fetching) {
        if (fetching.intValue == 0) {
            [SVProgressHUD dismiss];
        } else if (fetching.intValue == 1) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"fetching", nil)];
        }
    }];

    [[RACObserve(self.viewModel, error) throttle:0.5] subscribeNext:^(NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"error", nil)];
        }
    }];
}


#pragma mark - Reviews

- (void)setupTableView {

    @weakify(self)
    RACSignal *reviewSignal = RACObserve(self.viewModel, reviews);

    [[reviewSignal skip:1] subscribeNext:^(NSArray *locations) {
        @strongify(self)
        [self.reviews reloadData];
    }];

    RAC(self.reviews.tableFooterView, hidden) = [reviewSignal map:^(NSArray *reviews) {
        return @([reviews count]);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.reviews count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    Review *review = [[self.viewModel reviews] objectAtIndex:indexPath.item];

    ReviewCell *reviewCell = (ReviewCell *) [self.reviews dequeueReusableCellWithIdentifier:@"Review" forIndexPath:indexPath];
    [reviewCell configure:review];
    return reviewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.reviews deselectRowAtIndexPath:indexPath animated:false];
}

#pragma mark - UI

- (void)setupUI {

    Location *loc = self.viewModel.location;

    self.name.text = loc.name;
    self.address.text = [[NSString alloc] initWithFormat:@"%@ %@\n%@ %@", loc.addressRoad, loc.addressRoadNumber, loc.addressPostalCode, loc.addressCity];
    [self.address sizeToFit];
    [self.address addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMaps:)]];

    CLLocationManager *manager = ((AppDelegate *) [UIApplication sharedApplication].delegate).locationManager;
    self.distance.text = [[HalalGuideNumberFormatter instance] stringFromNumber:@([loc.location distanceFromLocation:manager.location] / 1000)];


    self.rating.starImage = [UIImage imageNamed:@"starSmall"];
    self.rating.displayMode = EDStarRatingDisplayHalf;
    self.rating.starHighlightedImage = [UIImage imageNamed:@"starSmallSelected"];
    self.rating.rating = 0;

    if ([loc.locationType isEqualToNumber:@(LocationTypeDining)]) {
        self.category.text = [loc categoriesString];
        [self.porkImage configureViewForLocation:loc];
        [self.alcoholImage configureViewForLocation:loc];
        [self.halalImage configureViewForLocation:loc];
        [self.porkLabel configureViewForLocation:loc];
        [self.alcoholLabel configureViewForLocation:loc];
        [self.halalLabel configureViewForLocation:loc];
    } else {

        if ([loc.locationType isEqualToNumber:@(LocationTypeMosque)]) {
            self.halalLabel.text = NSLocalizedString(LanguageString([loc.language integerValue]), nil);
            self.halalImage.image = [UIImage imageNamed:LanguageString([loc.language integerValue])];
        } else {
            [self.halalLabel removeFromSuperview];
            [self.halalImage removeFromSuperview];
        }

        [self.category removeFromSuperview];
        [self.porkLabel removeFromSuperview];
        [self.porkImage removeFromSuperview];
        [self.alcoholImage removeFromSuperview];
        [self.alcoholLabel removeFromSuperview];
    }

    @weakify(self)
    [[self.addPicture rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel getPictures:self];
    }];

    [[self.report rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel report:self];
    }];
}

- (void)openMaps:(UITapGestureRecognizer *)recognizer {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"addPicture", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    if (self.viewModel.location.addressRoad) {
        UIAlertAction *directions = [UIAlertAction actionWithTitle:NSLocalizedString(@"directions", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            PFGeoPoint *point = [self.viewModel.location point];
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(point.latitude, point.longitude) addressDictionary:nil];
            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
            [mapItem setName:self.viewModel.location.name];

            // Set the directions mode to "Driving"
            // Can use MKLaunchOptionsDirectionsModeWalking instead
            NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};

            // Get the "Current User Location" MKMapItem
            MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];

            // Pass the current location and destination map items to the Maps app
            // Set the direction mode in the launchOptions dictionary
            [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem] launchOptions:launchOptions];
        }];
        [alertController addAction:directions];
    }
    if (self.viewModel.location.telephone) {
        UIAlertAction *call = [UIAlertAction actionWithTitle:NSLocalizedString(@"call", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

            NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", self.viewModel.location.telephone]];

            if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
                [[UIApplication sharedApplication] openURL:phoneUrl];
            } else {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"warning", nil) message:NSLocalizedString(@"callNotAvaileble", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil] show];
            }

        }];
        [alertController addAction:call];
    }
    if (self.viewModel.location.homePage && [self.viewModel.location.homePage length] > 0) {
        UIAlertAction *homepage = [UIAlertAction actionWithTitle:NSLocalizedString(@"homepage", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //TODO Add http if missing
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", self.viewModel.location.homePage]];
            [[UIApplication sharedApplication] openURL:url];
        }];
        [alertController addAction:homepage];
    }

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"regret", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:cancel];

    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - CollectionView - Pictures

- (void)setupPictures {
    self.pictures.type = iCarouselTypeCoverFlow2;
    self.pictures.delegate = self;
    self.pictures.dataSource = self;

    @weakify(self)
    RACSignal *pictures = RACObserve(self.viewModel, locationPictures);

    [pictures subscribeNext:^(NSArray *locations) {
        @strongify(self)
        [self.pictures reloadData];
    }];

    RAC(self.noPicturesLabel, hidden) = [pictures map:^(NSArray *pictures) {
        return @([pictures count]);
    }];
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [self.viewModel.locationPictures count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {

    LocationPicture *picture = [self.viewModel.locationPictures objectAtIndex:index];

    if (view == nil) {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180.0f, 180.0f)];
        view.contentMode = UIViewContentModeScaleAspectFit;
    }
    //TODO Adjust frame so that portrait and landspace pictures are both max height

    [(UIImageView *) view setImageWithURL:[[NSURL alloc] initWithString:picture.mediumPicture.url] placeholderImage:[UIImage imageNamed:@"dining"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    return view;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    self.viewModel.indexOfSelectedImage = index;
    [self performSegueWithIdentifier:@"SlideShow" sender:self];
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

    if ([segue.identifier isEqualToString:@"CreateReview"]) {

        CreateReviewViewModel *viewModel1 = [[CreateReviewViewModel alloc] initWithReviewedLocation:self.viewModel.location];
        UINavigationController *_navigationController = (UINavigationController *) segue.destinationViewController;

        CreateReviewViewController *controller = [_navigationController.viewControllers objectAtIndex:0];
        controller.viewModel = viewModel1;
    }
    else if ([segue.identifier isEqualToString:@"ReviewDetails"]) {
        NSIndexPath *selected = [self.reviews indexPathForSelectedRow];
        Review *review = [[self.viewModel reviews] objectAtIndex:selected.item];
        ReviewDetailViewModel *viewModel1 = [[ReviewDetailViewModel alloc] initWithReview:review];
        ReviewDetailViewController *controller = (ReviewDetailViewController *) segue.destinationViewController;
        controller.viewModel = viewModel1;
    }

    else if ([segue.identifier isEqualToString:@"SlideShow"]) {
        MZFormSheetSegue *formSheetSegue = (MZFormSheetSegue *) segue;
        MZFormSheetController *formSheet = formSheetSegue.formSheetController;
        SlideShowViewController *controller = (SlideShowViewController *) segue.destinationViewController;
        controller.viewModel = self.viewModel;

        formSheet.portraitTopInset = 6;
        formSheet.cornerRadius = 6;
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        formSheet.presentedFormSheetSize = CGSizeMake(screenSize.width * 0.95f, screenSize.height * 0.95f);
        formSheet.transitionStyle = MZFormSheetTransitionStyleFade;
    }

}

#pragma mark - Mail composer

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {

    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ImagePicker

- (void)finishedPickingImages {
    [super finishedPickingImages];
    [self.viewModel saveMultiplePictures:self.images];
}

@end
