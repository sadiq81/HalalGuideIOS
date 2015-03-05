//
//  LocationDetailViewController.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <IQKeyboardManager/IQUIView+Hierarchy.h>
#import "LocationDetailViewController.h"

@interface LocationDetailViewController ()
@property(strong) UIView *headerView;
//-------------------------------------------
@property(strong) UILabel *name;
@property(strong) UILabel *road;
@property(strong) UILabel *postalCode;
@property(strong) UILabel *distance;
@property(strong) UILabel *km;
@property(strong) EDStarRating *rating;
@property(strong) UILabel *category;
@property(strong) UIImageView *porkImage;
@property(strong) UILabel *porkLabel;
@property(strong) UIImageView *alcoholImage;
@property(strong) UILabel *alcoholLabel;
@property(strong) UIImageView *halalImage;
@property(strong) UILabel *halalLabel;
@property(strong) UIImageView *languageImage;
@property(strong) UILabel *languageLabel;
//-------------------------------------------
@property(strong) UILabel *submitterHeadLine;
@property(strong) UILabel *submitterName;
@property(strong) UIImageView *submitterImage;
//-------------------------------------------
@property(strong) UIButton *report;
@property(strong) UIButton *addReview;
@property(strong) UIButton *addPicture;
@property(strong) iCarousel *pictures;
@property(strong, nonatomic) UILabel *noPicturesLabel;
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
        [self setupPictures];
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

    self.headerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.reviews.tableHeaderView = self.headerView;

    self.name = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:17];
    [self.name addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMaps:)]];
    [self.headerView addSubview:self.name];

    self.road = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:14];
    [self.road addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMaps:)]];
    [self.headerView addSubview:self.road];

    self.postalCode = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:14];
    [self.postalCode addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMaps:)]];
    [self.headerView addSubview:self.postalCode];

    self.rating = [[EDStarRating alloc] initWithFrame:CGRectZero];
    self.rating.starImage = [UIImage imageNamed:@"starSmall"];
    self.rating.displayMode = EDStarRatingDisplayHalf;
    self.rating.starHighlightedImage = [UIImage imageNamed:@"starSmallSelected"];
    self.rating.rating = 0;
    [self.headerView addSubview:self.rating];

    self.category = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:13];
    [self.headerView addSubview:self.category];

    self.distance = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:13];
    [self.headerView addSubview:self.distance];
    self.km = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:10];
    [self.headerView addSubview:self.km];

    self.porkImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.headerView addSubview:self.porkImage];
    self.porkLabel = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:9];
    [self.headerView addSubview:self.porkLabel];

    self.alcoholImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.headerView addSubview:self.alcoholImage];
    self.alcoholLabel = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:9];
    [self.headerView addSubview:self.alcoholLabel];

    self.halalImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.headerView addSubview:self.halalImage];
    self.halalLabel = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:9];
    [self.headerView addSubview:self.halalLabel];

    self.submitterImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.headerView addSubview:self.submitterImage];

    self.submitterHeadLine = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:9];
    [self.headerView addSubview:self.submitterHeadLine];
    self.submitterName = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:17];
    [self.headerView addSubview:self.submitterName];

    self.report = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.headerView addSubview:self.report];

    self.pictures = [[iCarousel alloc] initWithFrame:CGRectZero];
    [self.headerView addSubview:self.pictures];

    self.addReview = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.headerView addSubview:self.addReview];

    self.addPicture = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.headerView addSubview:self.addPicture];
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
        [self displayHintForView:self.road withHintKey:kDiningDetailAddressTelephoneOptionsOnBoardingKey preferedPositionOfText:HintPositionBelow];
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

    RAC(self.name, text) = RACObserve(self, viewModel.location.name);
    RAC(self.distance, text) = RACObserve(self, viewModel.distance);
    RAC(self.road, text) = RACObserve(self, viewModel.address);
    RAC(self.postalCode, text) = RACObserve(self, viewModel.postalCode);
    RAC(self.rating, rating) = RACObserve(self, viewModel.rating);


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
        [self.tableView reloadData];
    }];

    CGRect oldFrame = self.tableView.tableFooterView.frame;
    oldFrame.size.height = 63;
    self.tableView.tableFooterView.frame = oldFrame;
    RAC(self.tableView.tableFooterView, hidden) = [reviewSignal map:^(NSArray *reviews) {
        return @([reviews count]);
    }];

    RAC(self.name, text) = RACObserve(self, viewModel.location.name);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.reviews count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ReviewCell *reviewCell = (ReviewCell *) [self.tableView dequeueReusableCellWithIdentifier:@"Review" forIndexPath:indexPath];
    ReviewDetailViewModel *detailViewModel = [self.viewModel getReviewDetailViewModel:indexPath.item];
    reviewCell.viewModel = detailViewModel;
    return reviewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:false];
}

#pragma mark - UI

- (void)setupUI {

    Location *loc = self.viewModel.location;



    if ([loc.locationType isEqualToNumber:@(LocationTypeDining)]) {
        self.category.text = [loc categoriesString];
//        [self.porkImage configureViewForLocation:loc];
//        [self.alcoholImage configureViewForLocation:loc];
//        [self.halalImage configureViewForLocation:loc];
//        [self.porkLabel configureViewForLocation:loc];
//        [self.alcoholLabel configureViewForLocation:loc];
//        [self.halalLabel configureViewForLocation:loc];
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
    [RACObserve(self, viewModel.user) subscribeNext:^(PFUser *user) {
        @strongify(self)
        [self.submitterImage sd_setImageWithURL:user.facebookProfileUrlSmall];
        self.submitterName.text = user.facebookName;
    }];

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
        NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
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


- (void)updateViewConstraints {

    [self.name mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(8);
        make.left.equalTo(self.headerView).offset(8);
    }];

    [self.road mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom).offset(4);
        make.left.equalTo(self.headerView).offset(8);
    }];
    [self.postalCode mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.road.mas_bottom).offset(4);
        make.left.equalTo(self.headerView).offset(8);
    }];

    [self.rating mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.category.mas_top).offset(-8);
        make.left.equalTo(self.headerView).offset(8);
        make.height.equalTo(@(20));
    }];

    [self.category mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headerView).offset(-8);
        make.left.equalTo(self.headerView).offset(8);
    }];

    [self.distance mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerView).offset(-8);
        make.top.equalTo(self.headerView).offset(8);
    }];

    [self.km mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerView).offset(-8);
        make.top.equalTo(self.distance.mas_bottom).offset(4);
    }];

    [self.porkImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.alcoholImage.mas_left).offset(-8);
        make.width.equalTo(@(31));
        make.height.equalTo(@(31));
    }];

    [self.porkLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headerView).offset(-8);
        make.centerX.equalTo(self.porkImage);
        make.top.equalTo(self.porkImage.mas_bottom).offset(-8);
    }];

    [self.alcoholImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.halalImage.mas_left).offset(-8);
        make.width.equalTo(@(31));
        make.height.equalTo(@(31));
    }];

    [self.alcoholLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headerView).offset(-8);
        make.centerX.equalTo(self.alcoholImage);
        make.top.equalTo(self.alcoholImage.mas_bottom).offset(-8);
    }];

    [self.halalImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerView).offset(-8);
        make.width.equalTo(@(31));
        make.height.equalTo(@(31));
    }];

    [self.halalLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headerView).offset(-8);
        make.centerX.equalTo(self.halalImage);
        make.top.equalTo(self.halalImage.mas_bottom).offset(-8);
    }];

    [self.submitterImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.category.mas_bottom).offset(8);
        make.left.equalTo(self.headerView).offset(8);
        make.width.equalTo(@(31));
        make.height.equalTo(@(31));
    }];

    [self.submitterHeadLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.submitterImage);
        make.left.equalTo(self.submitterImage.mas_right).offset(8);
    }];

    [self.submitterName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.submitterHeadLine.mas_bottom).offset(4);
        make.left.equalTo(self.submitterImage.mas_right).offset(8);
        make.bottom.equalTo(self.submitterImage);
    }];

    [self.report mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.submitterImage.mas_bottom).offset(8);
        make.left.equalTo(self.headerView).offset(8);
        make.right.equalTo(self.headerView).offset(-8);
        make.height.equalTo(@(30));
    }];

    [self.pictures mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.report.mas_bottom).offset(8);
        make.right.equalTo(self.headerView);
        make.left.equalTo(self.headerView);
        make.height.equalTo(@(200));
    }];

    [self.noPicturesLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.pictures);
        make.centerY.equalTo(self.pictures);
        make.width.equalTo(self.headerView).offset(8);
    }];

    [self.addReview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pictures.mas_bottom).offset(8);
        make.left.equalTo(self.headerView).offset(8);
        make.right.equalTo(self.headerView.mas_centerX);
        make.height.equalTo(@(30));
        make.bottom.equalTo(self.headerView);
    }];

    [self.addPicture mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pictures.mas_bottom).offset(8);
        make.left.equalTo(self.headerView.mas_centerX).offset(8);
        make.right.equalTo(self.headerView).offset(-8);
        make.height.equalTo(@(30));
        make.bottom.equalTo(self.headerView);
    }];

    [self.reviews mas_updateConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self.view);
    }];

    [self.noReviewsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(8);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view).offset(8);
    }];

    [super updateViewConstraints];

}

@end
