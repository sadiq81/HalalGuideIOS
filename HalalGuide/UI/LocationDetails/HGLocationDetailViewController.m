//
//  HGLocationDetailViewController.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIBarButtonItem+ALActionBlocks.h>
#import "HGLocationDetailViewController.h"
#import "UITableView+Header.h"
#import "HGLocationDetailsInfoView.h"
#import "HGLocationDetailsPictureView.h"
#import "HGLocationDetailsHeaderView.h"

@interface HGLocationDetailViewController () <HGImagePickerControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate>
//-------------------------------------------
@property(strong) HGLocationDetailsHeaderView *header;

//-------------------------------------------
//-------------------------------------------
@property(strong) UITableView *reviews;
@property(strong, nonatomic) UILabel *noReviewsLabel;
//-------------------------------------------
@property(strong, nonatomic) HGLocationDetailViewModel *viewModel;
@end

@implementation HGLocationDetailViewController {
}

- (instancetype)initWithViewModel:(HGLocationDetailViewModel *)viewModel {
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

+ (instancetype)controllerWithViewModel:(HGLocationDetailViewModel *)viewModel {
    return [[self alloc] initWithViewModel:viewModel];
}

- (void)setupViews {

    self.title = self.viewModel.location.name;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.view.backgroundColor = [UIColor whiteColor];

    self.reviews = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.reviews];

    self.header = [HGLocationDetailsHeaderView viewWithViewModel:self.viewModel];
    [self.header.headerTopView.name addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMaps:)]];
    [self.header.headerTopView.road addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMaps:)]];
    [self.header.headerTopView.postalCode addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMaps:)]];
    self.reviews.tableHeaderView = self.header;

    self.noReviewsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.noReviewsLabel.text = NSLocalizedString(@"HGLocationDetailViewController.label.footer", nil);
    self.noReviewsLabel.numberOfLines = 0;
    self.noReviewsLabel.textAlignment = NSTextAlignmentCenter;
    self.reviews.tableFooterView = self.noReviewsLabel;


}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupHints];
}

#pragma mark - Hints

- (void)setupHints {
    if (![[HGOnboarding instance] wasOnBoardingShow:kDiningDetailAddressTelephoneOptionsOnBoardingKey]) {
        [self displayHintForView:self.header.headerTopView.road withHintKey:kDiningDetailAddressTelephoneOptionsOnBoardingKey preferedPositionOfText:HintPositionBelow];
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
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"HGLocationDetailViewController.hud.images.saved", nil)];
        } else {
            [SVProgressHUD dismiss];
        }
    }];

    [[[RACObserve(self.viewModel, fetchCount) skip:1] throttle:0.5] subscribeNext:^(NSNumber *fetching) {
        if (fetching.intValue == 0) {
            [SVProgressHUD dismiss];
        } else if (fetching.intValue == 1) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"HGLocationDetailViewController.hud.fetching", nil)];
        }
    }];

    [[RACObserve(self.viewModel, error) throttle:0.5] subscribeNext:^(NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"HGLocationDetailViewController.hud.error", nil)];
        }
    }];

}

- (void)HGImagePickerControllerDidCancel:(HGImagePickerController *)controller {
    [controller.presentingViewController dismissViewControllerAnimated:true completion:nil];
}

- (void)HGImagePickerControllerDidConfirm:(HGImagePickerController *)controller pictures:(NSArray *)pictures {
    [controller.presentingViewController dismissViewControllerAnimated:true completion:^{
        [self.viewModel saveMultiplePictures:pictures];
    }];
}


#pragma mark - Reviews

- (void)setupTableView {

    self.reviews.delegate = self;
    self.reviews.dataSource = self;

    [self.reviews registerClass:[HGReviewCell class] forCellReuseIdentifier:@"HGReview"];

    @weakify(self)
    RACSignal *reviewSignal = RACObserve(self.viewModel, reviews);

    [[reviewSignal skip:1] subscribeNext:^(NSArray *locations) {
        @strongify(self)
        [self.reviews reloadData];
    }];

    RAC(self.reviews.tableFooterView, hidden) = [reviewSignal map:^(NSArray *reviews) {
        return @([reviews count]);
    }];

    [self.header.pictureView.addReview handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        @strongify(self)
        [self createReviewForLocation:self.viewModel.location viewModel:self.viewModel];
    }];

    [[self.header.pictureView.addPicture rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self getPicturesWithDelegate:self viewModel:self.viewModel];
    }];

    [self.header.pictureView.report handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        @strongify(self)

        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        [mailController setToRecipients:@[@"tommy@eazyit.dk"]];
        [mailController setSubject:[NSString stringWithFormat:@"%@", self.viewModel.location.objectId]];
        [mailController setMessageBody:NSLocalizedString(@"HGLocationDetailViewController.mail.text", nil) isHTML:false];
        mailController.mailComposeDelegate = self;
        [self presentViewController:mailController animated:true completion:nil];
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.reviews count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HGReviewCell *reviewCell = (HGReviewCell *) [self.reviews dequeueReusableCellWithIdentifier:@"HGReview" forIndexPath:indexPath];
    HGReviewDetailViewModel *detailViewModel = [self.viewModel getReviewDetailViewModel:indexPath.item];
    reviewCell.viewModel = detailViewModel;
    return reviewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self.reviews deselectRowAtIndexPath:indexPath animated:false];

    HGReviewDetailViewModel *reviewModel = [self.viewModel getReviewDetailViewModel:indexPath.item];
    HGReviewDetailViewController *controller = [HGReviewDetailViewController controllerWithViewModel:reviewModel];
    [self.navigationController pushViewController:controller animated:true];
}

- (void)openMaps:(UITapGestureRecognizer *)recognizer {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"HGLocationDetailViewController.alert.action", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *directions = [UIAlertAction actionWithTitle:NSLocalizedString(@"HGLocationDetailViewController.alert.directions", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
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
        UIAlertAction *call = [UIAlertAction actionWithTitle:NSLocalizedString(@"HGLocationDetailViewController.alert.call", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

            NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", self.viewModel.location.telephone]];

            if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
                [[UIApplication sharedApplication] openURL:phoneUrl];
            } else {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"HGLocationDetailViewController.alert.warning", nil) message:NSLocalizedString(@"HGLocationDetailViewController.alert.call.not.availeble", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"HGLocationDetailViewController.alert.ok", nil) otherButtonTitles:nil, nil] show];
            }

        }];
        [alertController addAction:call];
    }
    if (self.viewModel.location.homePage && [self.viewModel.location.homePage length] > 0) {
        UIAlertAction *homepage = [UIAlertAction actionWithTitle:NSLocalizedString(@"HGLocationDetailViewController.alert.homepage", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //TODO Add http if missing
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", self.viewModel.location.homePage]];
            [[UIApplication sharedApplication] openURL:url];
        }];
        [alertController addAction:homepage];
    }

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"HGLocationDetailViewController.alert.regret", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:cancel];

    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Mail composer

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {

    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateViewConstraints {

    [self.header mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reviews);
        make.right.equalTo(self.reviews);
        make.left.equalTo(self.reviews);
        make.width.equalTo(self.view);
        make.height.equalTo(@(428));
    }];

    [self.reviews sizeHeaderToFit];

    [self.reviews mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self.noReviewsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.reviews).offset(-8);
        make.left.equalTo(self.reviews).offset(8);
        make.top.equalTo(self.header.mas_bottom);
        make.height.equalTo(@(60));
    }];


    [super updateViewConstraints];

}

@end
