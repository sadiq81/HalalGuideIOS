//
//  LocationDetailViewController.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "LocationDetailViewController.h"
#import "UITableView+Header.h"
#import "HGLocationDetailsTopView.h"
#import "HGLocationDetailsSubmitterView.h"
#import "HGLocationDetailsPictureView.h"

@interface LocationDetailViewController ()
//-------------------------------------------
@property(strong) HGLocationDetailsTopView *headerTopView;
@property(strong) HGLocationDetailsSubmitterView *submitterView;
@property(strong) HGLocationDetailsPictureView *pictureView;

//-------------------------------------------
//-------------------------------------------
@property(strong) UITableView *reviews;
@property(strong, nonatomic) UILabel *noReviewsLabel;
//-------------------------------------------
@property(strong, nonatomic) LocationDetailViewModel *viewModel;
@end

@implementation LocationDetailViewController {
}

- (instancetype)initWithViewModel:(LocationDetailViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
        [self setupViews];
        [self setupViewModel];
        [self setupTableView];
        [self updateViewConstraints];
    }

    return self;
}

+ (instancetype)controllerWithViewModel:(LocationDetailViewModel *)viewModel {
    return [[self alloc] initWithViewModel:viewModel];
}

- (void)setupViews {

    self.title = self.viewModel.location.name;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.view.backgroundColor = [UIColor whiteColor];

    self.reviews = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.reviews];

    self.reviews.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];

    self.headerTopView = [HGLocationDetailsTopView viewWithViewModel:self.viewModel];
    [self.reviews.tableHeaderView addSubview:self.headerTopView];

    self.submitterView = [HGLocationDetailsSubmitterView viewWithViewModel:self.viewModel];
    [self.reviews.tableHeaderView addSubview:self.submitterView];

    self.pictureView = [HGLocationDetailsPictureView viewWithViewModel:self.viewModel];
    [self.reviews.tableHeaderView addSubview:self.pictureView];


}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupHints];
}

#pragma mark - Hints

- (void)setupHints {
    if (![[HalalGuideOnboarding instance] wasOnBoardingShow:kDiningDetailAddressTelephoneOptionsOnBoardingKey]) {
        [self displayHintForView:self.headerTopView.road withHintKey:kDiningDetailAddressTelephoneOptionsOnBoardingKey preferedPositionOfText:HintPositionBelow];
    }
}

#pragma mark - ViewModel changes

- (void)setupViewModel {

    [[RACObserve(self.viewModel, progress) skip:1] subscribeNext:^(NSNumber *progress) {
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

    @weakify(self)
    [[self.pictureView.addPicture rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        //[self.viewModel getPictures:self];
    }];

    [[self.pictureView.report rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel report:self];
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
    return 0;//[self.viewModel.reviews count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ReviewCell *reviewCell = (ReviewCell *) [self.reviews dequeueReusableCellWithIdentifier:@"Review" forIndexPath:indexPath];
    ReviewDetailViewModel *detailViewModel = [self.viewModel getReviewDetailViewModel:indexPath.item];
    reviewCell.viewModel = detailViewModel;
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


}

- (void)openMaps:(UITapGestureRecognizer *)recognizer {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"addPicture", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];

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

    if (self.viewModel.location.telephone && [self.viewModel.location.telephone length] >= 8) {
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


- (void)updateViewConstraints {

    [self.reviews mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self.reviews.tableHeaderView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.height.equalTo(@(410));
        make.width.equalTo(self.view);
    }];

    [self.reviews sizeHeaderToFit];

    [self.headerTopView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reviews.tableHeaderView);
        make.left.equalTo(self.reviews.tableHeaderView);
        make.right.equalTo(self.reviews.tableHeaderView);
        make.height.equalTo(@(110));
    }];

    [self.submitterView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerTopView.mas_bottom).offset(8);
        make.left.equalTo(self.reviews.tableHeaderView);
        make.right.equalTo(self.reviews.tableHeaderView);
        make.height.equalTo(@(48));
    }];


//
//
//    [self.noReviewsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.headerView.mas_bottom).offset(8);
//        make.centerX.equalTo(self.view);
//        make.width.equalTo(self.view).offset(8);
//    }];
//


    [super updateViewConstraints];

}

@end
