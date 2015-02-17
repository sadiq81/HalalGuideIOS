//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "FrontPageViewController.h"
#import "DiningTableViewCell.h"
#import "LocationDetailViewModel.h"
#import "LocationViewModel.h"
#import "LocationViewController.h"
#import "LocationDetailViewController.h"

@implementation FrontPageViewController {

}

@synthesize latestUpdated, tableViewController, refreshControl, viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewModel];
    [self configureTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.viewModel refreshLocations];
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
    self.latestUpdated.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableViewController = [[UITableViewController alloc] init];
    self.refreshControl = [[UIRefreshControl alloc] init];

    self.refreshControl = [UIRefreshControl new];

    @weakify(self)
    RACSignal *locations = RACObserve(self.viewModel, locations);
    [locations subscribeNext:^(NSArray *locations) {
        @strongify(self)
        [self.latestUpdated reloadData];
        [self.refreshControl endRefreshing];
    }];

    [[self.refreshControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel refreshLocations];
    }];

    self.tableViewController.tableView = self.latestUpdated;
    self.tableViewController.refreshControl = self.refreshControl;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    Location *location = [self.viewModel.locations objectAtIndex:indexPath.row];

    NSString *identifier = LocationTypeString([location.locationType integerValue]);
    DiningTableViewCell *cell = [self.latestUpdated dequeueReusableCellWithIdentifier:identifier];

    [cell configure:location];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"DiningDetail"] || [segue.identifier isEqualToString:@"ShopDetail"] || [segue.identifier isEqualToString:@"MosqueDetail"]) {
        Location *location = [self.viewModel.locations objectAtIndex:[self.latestUpdated indexPathForSelectedRow].row];
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


@end