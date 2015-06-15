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
#import "HGCategoryViewController.h"
#import "HGDiningCell.h"
#import "HGCreateLocationViewModel.h"
#import "MKMapView+Extension.h"
#import "HGLocationAnnotation.h"
#import "HGLocationAnnotationView.h"
#import "HGCategoryViewModel.h"
#import "HGOnboarding.h"
#import "HGAppDelegate.h"
#import "HGFilterLocationViewController.h"
#import "HGLocationDetailViewController.h"
#import "HGCreateLocationViewController.h"
#import "HGMosqueCell.h"
#import "HGShopCell.h"
#import "UITableView+Header.h"
#import "HGGeoLocationService.h"
#import "HGCategoriesFilterViewController.h"
#import "HGCategoryViewModel.h"

@interface HGCategoryViewController ()

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) UILabel *noResults;
@property(strong, nonatomic) HGCategoryViewModel *viewModel;

@end


@implementation HGCategoryViewController {
}

- (instancetype)initWithViewModel:(HGCategoryViewModel *)viewModel {
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

+ (instancetype)controllerWithViewModel:(HGCategoryViewModel *)viewModel {
    return [[self alloc] initWithViewModel:viewModel];
}

- (void)setupViews {

    self.screenName = @"Category";

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.view.backgroundColor = [UIColor whiteColor];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];

    self.noResults = [[UILabel alloc] initWithFrame:CGRectZero];
    self.noResults.text = NSLocalizedString(@"HGCategoryViewController.label.no.results", nil);
    [self.tableView addSubview:self.noResults];


};

#pragma mark - ViewModel changes

- (void)setupViewModel {

    @weakify(self)
    [[RACObserve(self.viewModel, fetchCount) throttle:0.5] subscribeNext:^(NSNumber *fetching) {
        @strongify(self)
        if (fetching.intValue == 0) {
            [SVProgressHUD dismiss];

        } else if (fetching.intValue == 1 && !self.tableView.headerLoadingIndicator.isAnimating && !self.tableView.footerLoadingIndicator.isAnimating) {
            [SVProgressHUD showWithStatus:NSLocalizedString(@"HGCategoryViewController.hud.fetching", nil) maskType:SVProgressHUDMaskTypeNone];
        }
    }];

    [[RACObserve(self.viewModel, error) throttle:0.5] subscribeNext:^(NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"HGCategoryViewController.hud.error", nil)];
        }
    }];

    RACSignal *locations = RACObserve(self.viewModel, locations);

    [[locations ignore:nil] subscribeNext:^(NSArray *locations) {
        @strongify(self)
        [self.tableView reloadData];
    }];

    RAC(self.noResults, hidden) = [locations map:^(NSArray *locations) {
        return @([locations count]);
    }];

}

#pragma mark - TableView

- (void)setupTableView {

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

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.locations count];
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


- (void)updateViewConstraints {

    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self.noResults mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
    }];

    [super updateViewConstraints];
}

@end
