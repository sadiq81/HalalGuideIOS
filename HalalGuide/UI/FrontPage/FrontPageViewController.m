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
#import "UIButton+VerticalLayout.h"
#import "View+MASAdditions.h"
#import "MosqueCell.h"
#import "ShopCell.h"

@interface FrontPageViewController () <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UIButton *shop;
@property(nonatomic, strong) UIButton *eNumber;
@property(nonatomic, strong) UIButton *eat;
@property(nonatomic, strong) UIButton *mosque;
@property(nonatomic, strong) UIButton *settings;

@property(nonatomic, strong) UILabel *latest;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UITableViewController *tableViewController;
@property(nonatomic, strong) UIRefreshControl *refreshControl;

@property(strong, nonatomic) FrontPageViewModel *viewModel;

@end

@implementation FrontPageViewController {

}

- (instancetype)initWithViewModel:(FrontPageViewModel *)aViewModel {
    self = [super init];
    if (self) {
        self.viewModel = aViewModel;
        [self setupViews];
        [self setupViewModel];
        [self configureTableView];
        [self updateViewConstraints];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.viewModel refreshLocations];
}

- (void)setupViews {

    self.title = NSLocalizedString(@"FrontPageViewController.title", nil);

    self.topView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.topView];

    self.shop = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.shop setImage:[UIImage imageNamed:@"shop"] forState:UIControlStateNormal];
    [self.shop setTitle:NSLocalizedString(@"FrontPageViewController.button.shop", nil) forState:UIControlStateNormal];
    [self.shop setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.shop centerVertically];
    [self.topView addSubview:self.shop];

    self.eNumber = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.eNumber setImage:[UIImage imageNamed:@"ENumber"] forState:UIControlStateNormal];
    [self.eNumber setTitle:NSLocalizedString(@"FrontPageViewController.button.enumber", nil) forState:UIControlStateNormal];
    [self.eNumber setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.eNumber centerVertically];
    [self.topView addSubview:self.eNumber];

    self.eat = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.eat setImage:[UIImage imageNamed:@"dining"] forState:UIControlStateNormal];
    [self.eat setTitle:NSLocalizedString(@"FrontPageViewController.button.eat", nil) forState:UIControlStateNormal];
    [self.eat setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.eat centerVertically];
    [self.topView addSubview:self.eat];

    self.mosque = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.mosque setImage:[UIImage imageNamed:@"mosque"] forState:UIControlStateNormal];
    [self.mosque setTitle:NSLocalizedString(@"FrontPageViewController.button.mosque", nil) forState:UIControlStateNormal];
    [self.mosque setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.mosque centerVertically];
    [self.topView addSubview:self.mosque];

    self.settings = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.settings setImage:[UIImage imageNamed:@"Indstillinger"] forState:UIControlStateNormal];
    [self.settings setTitle:NSLocalizedString(@"FrontPageViewController.button.settings", nil) forState:UIControlStateNormal];
    [self.settings setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.settings centerVertically];
    [self.topView addSubview:self.settings];

    self.latest = [[HalalGuideLabel alloc] initWithFrame:CGRectZero andFontSize:13];
    self.latest.text = NSLocalizedString(@"FrontPageViewController.label.latest.updates", nil);
    [self.topView addSubview:self.latest];

    [self.view addSubview:self.topView];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:self.tableView];

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

- (void)configureTableView {

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

    [cell configureForViewModel: cellModel];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"DiningDetail"] || [segue.identifier isEqualToString:@"ShopDetail"] || [segue.identifier isEqualToString:@"MosqueDetail"]) {
        Location *location = [self.viewModel.locations objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        LocationDetailViewModel *detailViewModel = [[LocationDetailViewModel alloc] initWithLocation:location];

        LocationDetailViewController *detailViewController = (LocationDetailViewController *) segue.destinationViewController;
        detailViewController.viewModel = detailViewModel;

    } else if ([segue.identifier isEqualToString:@"Shop"]) {

        LocationViewController *controller = (LocationViewController *) segue.destinationViewController;
        controller.viewModel = [LocationViewModel modelWithLocationType:LocationTypeShop];

    } else if ([segue.identifier isEqualToString:@"Dining"]) {

        LocationViewController *controller = (LocationViewController *) segue.destinationViewController;
        controller.viewModel = [LocationViewModel modelWithLocationType:LocationTypeDining];

    } else if ([segue.identifier isEqualToString:@"Mosque"]) {

        LocationViewController *controller = (LocationViewController *) segue.destinationViewController;
        controller.viewModel = [LocationViewModel modelWithLocationType:LocationTypeMosque];
    }
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(20 + 48 + 40 + 48 + 20));
    }];

    [self.shop mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@48);
        make.height.equalTo(@48);
       make.centerX.equalTo(self.topView).centerOffset(CGPointMake(-(self.view.frame.size.width/4+24), 0));
        make.top.equalTo(self.topView).offset(20);
    }];

    [self.eNumber mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@48);
        make.height.equalTo(@48);
        make.centerX.equalTo(self.topView);
        make.top.equalTo(self.topView).offset(20);
    }];

    [self.eat mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@48);
        make.height.equalTo(@48);
        make.centerX.equalTo(self.topView).centerOffset(CGPointMake(self.view.frame.size.width/4+24, 0));
        make.top.equalTo(self.topView).offset(20);
    }];

    [self.mosque mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@48);
        make.height.equalTo(@48);
        make.centerX.equalTo(self.topView).centerOffset(CGPointMake(-(self.view.frame.size.width/4+24), 0));
        make.top.equalTo(self.shop.mas_bottom).offset(40);
    }];

    [self.settings mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@48);
        make.height.equalTo(@48);
        make.centerX.equalTo(self.topView).centerOffset(CGPointMake(self.view.frame.size.width/4+24, 0));
        make.top.equalTo(self.eat.mas_bottom).offset(40);
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

}


@end