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
#import "UIView+Extensions.h"
#import "UIBarButtonItem+Extension.h"
#import "DiningDetailViewModel.h"
#import "CMPopTipView.h"
#import "HalalGuideOnboarding.h"
#import "RACSignal.h"
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>

//TODO Search bar for string searching fx name.
//TODO On first load, distance filter is not working - Only after first dismissing filter.
@implementation DiningViewController {

}

@synthesize tableViewController, diningTableView, refreshControl, bottomRefreshControl, filter, toolbar;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
    [[DiningViewModel instance] refreshLocations:true];
    [DiningViewModel instance].delegate = self;

    [self setupHints];
}

- (void)dealloc {
    [[DiningViewModel instance] reset];
}

#pragma mark Onboarding

- (void)setupHints {

    if (![[HalalGuideOnboarding instance] wasOnBoardingShow:kAddNewDiningOnBoardingButtonKey]) {

        [self.navigationItem.rightBarButtonItem showOnBoardingWithHintKey:kAddNewDiningOnBoardingButtonKey withDelegate:self];

    } else if (![[HalalGuideOnboarding instance] wasOnBoardingShow:kFilterDiningOnBoardingButtonKey]) {

        [self.filter showOnBoardingWithHintKey:kFilterDiningOnBoardingButtonKey withDelegate:self];

    }
}

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {

    if (popTipView.targetObject == self.navigationItem.rightBarButtonItem) {
        [self.filter showOnBoardingWithHintKey:kFilterDiningOnBoardingButtonKey withDelegate:self];
    }

    else if (popTipView.targetObject == self.filter) {
        DiningTableViewCell *cell = (DiningTableViewCell *) [[self.diningTableView visibleCells] firstObject];
        [cell showToolTip];
    }
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"DiningDetail"]) {

        if ([[HalalGuideOnboarding instance] wasOnBoardingShow:kDiningCellHalalOnBoardingKey]) {
            return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
        } else {
            return false;
        }

    } else {
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    }
}

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
    [self.bottomRefreshControl endRefreshing];
}

#pragma mark - TableView

- (void)configureTableView {
    self.diningTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.tableViewController = [[UITableViewController alloc] init];
    self.tableViewController.tableView = self.diningTableView;

    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl handleControlEvents:UIControlEventValueChanged withBlock:^(id weakControl) {
        [DiningViewModel instance].page = 0;
        [[DiningViewModel instance] refreshLocations:false];
    }];
    self.tableViewController.refreshControl = self.refreshControl;

    self.bottomRefreshControl = [UIRefreshControl new];
    self.diningTableView.bottomRefreshControl = self.bottomRefreshControl;
    [self.bottomRefreshControl handleControlEvents:UIControlEventValueChanged withBlock:^(id weakControl) {
        [DiningViewModel instance].page++;
        [[DiningViewModel instance] refreshLocations:false];
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[DiningViewModel instance] numberOfLocations];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    Location *location = [[DiningViewModel instance] locationForRow:indexPath.row];

    NSString *identifier = @"dining";
    DiningTableViewCell *cell = [self.diningTableView dequeueReusableCellWithIdentifier:identifier];

    [cell configure:location];

    //If onBoarding was dismissed before cells where displayed
    if (![[HalalGuideOnboarding instance] wasOnBoardingShow:kDiningCellPorkOnBoardingKey] && [[HalalGuideOnboarding instance] wasOnBoardingShow:kFilterDiningOnBoardingButtonKey]) {
        [cell showToolTip];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}


@end
