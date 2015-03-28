//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "FrontPageViewController.h"
#import "DiningCell.h"
#import "LocationDetailViewModel.h"
#import "LocationViewModel.h"
#import "LocationViewController.h"
#import "LocationDetailViewController.h"
#import "ZLPromptUserReview.h"
#import "MosqueCell.h"
#import "ShopCell.h"
#import "Masonry/Masonry.h"
#import "ButtonView.h"
#import "HGImagePickerController.h"

@interface FrontPageViewController () <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) ButtonView *shopView;
@property(nonatomic, strong) ButtonView *eNumberView;
@property(nonatomic, strong) ButtonView *eatView;
@property(nonatomic, strong) ButtonView *mosqueView;
@property(nonatomic, strong) ButtonView *settingsView;

@property(nonatomic, strong) UILabel *latest;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UITableViewController *tableViewController;
@property(nonatomic, strong) UIRefreshControl *refreshControl;

@property(strong, nonatomic) FrontPageViewModel *viewModel;

@end

@implementation FrontPageViewController {

}

- (instancetype)initWithViewModel:(FrontPageViewModel *)viewModel {
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

+ (instancetype)controllerWithViewModel:(FrontPageViewModel *)viewModel {
    return [[self alloc] initWithViewModel:viewModel];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.viewModel refreshLocations];
}

- (void)setupViews {

    self.title = NSLocalizedString(@"FrontPageViewController.title", nil);
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.view.backgroundColor = [UIColor whiteColor];

    self.topView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.topView];

    self.shopView = [[ButtonView alloc] initWithButtonImageName:@"shop" andLabelText:@"FrontPageViewController.label.shop" andTapHandler:[self tapHandlerForType:LocationTypeShop]];
    [self.topView addSubview:self.shopView];

    self.eNumberView = [[ButtonView alloc] initWithButtonImageName:@"ENumber" andLabelText:@"FrontPageViewController.label.enumber" andTapHandler:nil];
    [self.topView addSubview:self.eNumberView];

    self.eatView = [[ButtonView alloc] initWithButtonImageName:@"dining" andLabelText:@"FrontPageViewController.label.eat" andTapHandler:[self tapHandlerForType:LocationTypeDining]];
    [self.topView addSubview:self.eatView];

    self.mosqueView = [[ButtonView alloc] initWithButtonImageName:@"mosque" andLabelText:@"FrontPageViewController.label.mosque" andTapHandler:[self tapHandlerForType:LocationTypeShop]];
    [self.topView addSubview:self.mosqueView];

    self.settingsView = [[ButtonView alloc] initWithButtonImageName:@"Indstillinger" andLabelText:@"FrontPageViewController.label.settings" andTapHandler:nil];
    [self.topView addSubview:self.settingsView];

    self.latest = [[HGLabel alloc] initWithFrame:CGRectZero andFontSize:13];
    self.latest.text = NSLocalizedString(@"FrontPageViewController.label.latest.updates", nil);
    [self.topView addSubview:self.latest];

    [self.view addSubview:self.topView];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:self.tableView];

}

- (ButtonViewTapHandler)tapHandlerForType:(LocationType)type {

    @weakify(self)
    ButtonViewTapHandler handler = ^void(void) {
        @strongify(self)
        LocationViewModel *shopModel = [LocationViewModel modelWithLocationType:type];
        LocationViewController *viewController = [LocationViewController controllerWithViewModel:shopModel];
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
            [SVProgressHUD showWithStatus:NSLocalizedString(@"fetching", nil) maskType:SVProgressHUDMaskTypeNone];
        }
    }];

    [[RACObserve(self.viewModel, error) throttle:0.5] subscribeNext:^(NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"error", nil)];
        }
    }];

}

#pragma mark - TableView

- (void)setupTableView {

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.tableView registerClass:[DiningCell class] forCellReuseIdentifier:[DiningCell placeholderImageName]];
    [self.tableView registerClass:[MosqueCell class] forCellReuseIdentifier:[MosqueCell placeholderImageName]];
    [self.tableView registerClass:[ShopCell class] forCellReuseIdentifier:[ShopCell placeholderImageName]];

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

    LocationDetailViewModel *cellModel = [self.viewModel viewModelForLocationAtIndex:indexPath.row];

    NSString *identifier = LocationTypeString([cellModel.location.locationType integerValue]);

    LocationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];

    [cell configureForViewModel:cellModel];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    LocationCell *cell = (LocationCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    LocationDetailViewController *detailViewController = [LocationDetailViewController controllerWithViewModel:cell.viewModel];
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