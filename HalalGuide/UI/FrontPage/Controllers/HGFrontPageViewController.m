//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "HGFrontPageViewController.h"
#import "HGDiningCell.h"
#import "HGLocationDetailViewModel.h"
#import "HGLocationViewModel.h"
#import "HGLocationViewController.h"
#import "HGLocationDetailViewController.h"
#import "ZLPromptUserReview.h"
#import "HGMosqueCell.h"
#import "HGShopCell.h"
#import "Masonry/Masonry.h"
#import "HGButtonView.h"
#import "HGImagePickerController.h"
#import "HGENumberViewController.h"
#import "HGSettingsViewController.h"
#import "HGFavoriteViewModel.h"
#import "HGFavoriteViewController.h"
#import "HGFloatingChatButton.h"

@interface HGFrontPageViewController () <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) HGButtonView *shopView;
@property(nonatomic, strong) HGButtonView *eNumberView;
@property(nonatomic, strong) HGButtonView *eatView;
@property(nonatomic, strong) HGButtonView *mosqueView;
@property(nonatomic, strong) HGButtonView *favoritesView;
@property(nonatomic, strong) HGButtonView *settingsView;

@property(nonatomic, strong) UILabel *latest;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UITableViewController *tableViewController;
@property(nonatomic, strong) UIRefreshControl *refreshControl;

@property(strong, nonatomic) HGFrontPageViewModel *viewModel;

@end

@implementation HGFrontPageViewController {

}

- (instancetype)initWithViewModel:(HGFrontPageViewModel *)viewModel {
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

+ (instancetype)controllerWithViewModel:(HGFrontPageViewModel *)viewModel {
    return [[self alloc] initWithViewModel:viewModel];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.viewModel refreshLocations];
}

- (void)setupViews {

    self.title = NSLocalizedString(@"HGFrontPageViewController.title", nil);
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.view.backgroundColor = [UIColor whiteColor];

    self.topView = [[UIView alloc] initWithFrame:CGRectZero];
    self.topView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.topView.layer.borderWidth = 0.5;
    [self.view addSubview:self.topView];

    self.shopView = [[HGButtonView alloc] initWithButtonImageName:@"HGFrontPageViewController.button.shop" andLabelText:@"HGFrontPageViewController.label.shop" andTapHandler:[self tapHandlerForType:LocationTypeShop]];
    [self.topView addSubview:self.shopView];

    self.eNumberView = [[HGButtonView alloc] initWithButtonImageName:@"HGFrontPageViewController.button.enumber" andLabelText:@"HGFrontPageViewController.label.enumber" andTapHandler:^{
        HGENumberViewController *controller = [[HGENumberViewController alloc] init];
        [self.navigationController pushViewController:controller animated:true];
    }];
    [self.topView addSubview:self.eNumberView];

    self.eatView = [[HGButtonView alloc] initWithButtonImageName:@"HGFrontPageViewController.button.dining" andLabelText:@"HGFrontPageViewController.label.eat" andTapHandler:[self tapHandlerForType:LocationTypeDining]];
    [self.topView addSubview:self.eatView];

    self.mosqueView = [[HGButtonView alloc] initWithButtonImageName:@"HGFrontPageViewController.button.mosque" andLabelText:@"HGFrontPageViewController.label.mosque" andTapHandler:[self tapHandlerForType:LocationTypeMosque]];
    [self.topView addSubview:self.mosqueView];

    self.favoritesView = [[HGButtonView alloc] initWithButtonImageName:@"HGFrontPageViewController.button.favorite" andLabelText:@"HGFrontPageViewController.label.favorite" andTapHandler:^{
        HGFavoriteViewModel *model = [[HGFavoriteViewModel alloc] init];
        HGFavoriteViewController *viewController = [HGFavoriteViewController controllerWithViewModel:model];
        [self.navigationController pushViewController:viewController animated:true];
    }];
    [self.topView addSubview:self.favoritesView];

    self.settingsView = [[HGButtonView alloc] initWithButtonImageName:@"HGFrontPageViewController.button.settings" andLabelText:@"HGFrontPageViewController.label.settings" andTapHandler:^{
        HGSettingsViewController *controller = [[HGSettingsViewController alloc] init];
        [self.navigationController pushViewController:controller animated:true];
    }];
    [self.topView addSubview:self.settingsView];

    self.latest = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:13];
    self.latest.text = NSLocalizedString(@"HGFrontPageViewController.label.latest.updates", nil);
    [self.topView addSubview:self.latest];

    [self.view addSubview:self.topView];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:self.tableView];


}

- (ButtonViewTapHandler)tapHandlerForType:(LocationType)type {

    @weakify(self)
    ButtonViewTapHandler handler = ^void(void) {
        @strongify(self)
        HGLocationViewModel *shopModel = [HGLocationViewModel modelWithLocationType:type];
        HGLocationViewController *viewController = [HGLocationViewController controllerWithViewModel:shopModel];
        [self.navigationController pushViewController:viewController animated:true];
    };
    return handler;
}

#pragma mark - ViewModel changes

- (void)setupViewModel {

    @weakify(self)
    [[RACObserve(self.viewModel, fetchCount) throttle:0.5] subscribeNext:^(NSNumber *fetching) {
        @strongify(self)
        if (fetching.intValue == 0) {
            [SVProgressHUD dismiss];
        } else if (fetching.intValue == 1 && !self.refreshControl.refreshing) {
            [SVProgressHUD showWithStatus:NSLocalizedString(@"HGFrontPageViewController.hud.fetching", nil) maskType:SVProgressHUDMaskTypeNone];
        }
    }];

    [[RACObserve(self.viewModel, error) throttle:0.5] subscribeNext:^(NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"HGFrontPageViewController.hud.error", nil)];
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

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableViewController = [[UITableViewController alloc] init];
    self.refreshControl = [[UIRefreshControl alloc] init];

    self.refreshControl = [UIRefreshControl new];

    @weakify(self)
    RACSignal *locations = RACObserve(self.viewModel, locations);
    [locations subscribeNext:^(NSArray *locations) {
        @strongify(self)
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];

    [[self.refreshControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel refreshLocations];
    }];

    self.tableViewController.tableView = self.tableView;
    self.tableViewController.refreshControl = self.refreshControl;
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

#pragma mark - Appearance

- (void)updateViewConstraints {


    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(220));
    }];

    [self.shopView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@48);
        make.centerX.equalTo(self.topView).centerOffset(CGPointMake(-(self.view.frame.size.width / 4 + 24), 0));
        make.top.equalTo(self.topView).offset(20);
    }];

    [self.eNumberView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@48);
        make.centerX.equalTo(self.topView);
        make.top.equalTo(self.topView).offset(20);
    }];

    [self.eatView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@48);
        make.centerX.equalTo(self.topView).centerOffset(CGPointMake(self.view.frame.size.width / 4 + 24, 0));
        make.top.equalTo(self.topView).offset(20);
    }];

    [self.mosqueView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@48);
        make.centerX.equalTo(self.shopView);
        make.top.equalTo(self.shopView.mas_bottom).offset(20);
    }];

    [self.favoritesView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@48);
        make.centerX.equalTo(self.eNumberView);
        make.top.equalTo(self.eNumberView.mas_bottom).offset(20);
    }];

    [self.settingsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@48);
        make.centerX.equalTo(self.eatView);
        make.top.equalTo(self.eatView.mas_bottom).offset(20);
    }];

    [self.latest mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).offset(standardCellSpacing);
        make.bottom.equalTo(self.topView);
    }];

    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

    [super updateViewConstraints];

}


@end