//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import "FrontPageViewController.h"
#import "DiningTableViewCell.h"
#import "ALActionBlocks.h"
#import "DiningDetailViewModel.h"

@implementation FrontPageViewController {

}

//TODO Onboarding - What does latest mean
@synthesize latestUpdated, tableViewController, refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];

    [FrontPageViewModel instance].delegate = self;
    [[FrontPageViewModel instance] refreshLocations:true];
}

- (void)dealloc {
    [FrontPageViewModel instance].delegate = nil;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"DiningDetail"]) {
        Location *location = [[FrontPageViewModel instance] locationForRow:[self.latestUpdated indexPathForSelectedRow].row];
        [DiningDetailViewModel instance].location = location;
    }
}

#pragma mark - FrontPageViewModelDelegate

- (void)refreshTable {
    [self.latestUpdated reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadTable {
    [self.latestUpdated reloadData];
    [self.refreshControl endRefreshing];
}

#pragma mark - TableView

- (void)configureTableView {
    self.latestUpdated.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableViewController = [[UITableViewController alloc] init];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl handleControlEvents:UIControlEventValueChanged withBlock:^(id weakControl) {
        [[FrontPageViewModel instance] refreshLocations:false];
    }];
    self.tableViewController.tableView = self.latestUpdated;
    self.tableViewController.refreshControl = self.refreshControl;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[FrontPageViewModel instance] numberOfLocations];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    Location *location = [[FrontPageViewModel instance] locationForRow:indexPath.row];

    NSString *identifier = LocationTypeString([location.locationType integerValue]);
    DiningTableViewCell *cell = [self.latestUpdated dequeueReusableCellWithIdentifier:identifier];

    [cell configure:location];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}


@end