//
//  DiningViewController.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIControl+ALActionBlocks.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "DiningViewController.h"
#import "DiningTableViewCell.h"
#import "FrontPageViewModel.h"
#import "DiningDetailViewModel.h"

@implementation DiningViewController

@synthesize tableViewController, refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
    [[DiningViewModel instance] refreshLocations:true];
    [DiningViewModel instance].delegate = self;
}

- (void)dealloc {
    [DiningViewModel instance].delegate = nil;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"DiningDetail"]) {
        Location *location = [[DiningViewModel instance] locationForRow:[self.diningTableView indexPathForSelectedRow].row];
        [DiningDetailViewModel instance].location = location;
    }
}

#pragma mark - DiningViewModelDelegate

- (void)refreshTable {
    [self.diningTableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadTable {
    [self.diningTableView reloadData];
    [self.refreshControl endRefreshing];
}

#pragma mark - TableView

- (void)configureTableView {
    self.diningTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableViewController = [[UITableViewController alloc] init];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl handleControlEvents:UIControlEventValueChanged withBlock:^(id weakControl) {
        [[DiningViewModel instance] refreshLocations:false];
    }];

    self.tableViewController.tableView = self.diningTableView;
    self.tableViewController.refreshControl = self.refreshControl;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[DiningViewModel instance] numberOfLocations];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    Location *location = [[DiningViewModel instance] locationForRow:indexPath.row];

    NSString *identifier = @"dining";
    DiningTableViewCell *cell = [self.diningTableView dequeueReusableCellWithIdentifier:identifier];

    [cell configure:location];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}


@end
