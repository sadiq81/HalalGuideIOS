//
// Created by Privat on 19/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "HGFavoriteViewController.h"
#import "HGFavoriteViewModel.h"
#import "HGDiningCell.h"
#import "HGMosqueCell.h"
#import "HGShopCell.h"
#import "HGLocationDetailViewController.h"

@interface HGFavoriteViewController () <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) UILabel *noFavorites;
@property(strong, nonatomic) HGFavoriteViewModel *viewModel;

@end


@implementation HGFavoriteViewController {

}

- (instancetype)initWithViewModel:(HGFavoriteViewModel *)viewModel {
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

+ (instancetype)controllerWithViewModel:(HGFavoriteViewModel *)viewModel {
    return [[self alloc] initWithViewModel:viewModel];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.viewModel setupFavorites];
}

- (void)setupViews {

    self.screenName = @"Favorites";

    self.title = NSLocalizedString(@"HGFavoriteViewController.title", nil);

    self.view.backgroundColor = [UIColor whiteColor];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];

    self.noFavorites = [[UILabel alloc] initWithFrame:CGRectZero];
    self.noFavorites.text = NSLocalizedString(@"HGFavoriteViewController.label.no.favorites", nil);
    self.noFavorites.numberOfLines = 0;
    [self.view addSubview:self.noFavorites];

}

- (void)setupViewModel {

    RACSignal *locations = RACObserve(self.viewModel, favorites);

    @weakify(self)
    [[locations ignore:nil] subscribeNext:^(NSArray *favorites) {
        @strongify(self)
        [self.tableView reloadData];
    }];

    RAC(self.noFavorites, hidden) = [locations map:^(NSArray *favorites) {
        return @([favorites count]);
    }];

    [[RACObserve(self.viewModel, fetchCount) throttle:0.5] subscribeNext:^(NSNumber *fetching) {
        if (fetching.intValue == 0) {
            [SVProgressHUD dismiss];
        } else  {
            [SVProgressHUD showWithStatus:NSLocalizedString(@"HGFavoriteViewController.hud.fetching", nil) maskType:SVProgressHUDMaskTypeNone];
        }
    }];

    [[RACObserve(self.viewModel, error) throttle:0.5] subscribeNext:^(NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"HGFavoriteViewController.hud.error", nil)];
        }
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
    return [self.viewModel.favorites count];
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

    [self.noFavorites mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
    }];

    [super updateViewConstraints];
}


@end