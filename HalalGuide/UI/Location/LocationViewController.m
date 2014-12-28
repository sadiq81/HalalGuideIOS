//
//  LocationViewController.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIControl+ALActionBlocks.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "LocationViewController.h"
#import "DiningTableViewCell.h"
#import "UIView+Extensions.h"
#import "UIBarButtonItem+Extension.h"
#import "LocationDetailViewModel.h"
#import "CMPopTipView.h"
#import "HalalGuideOnboarding.h"
#import "RACSignal.h"
#import "CreateLocationViewModel.h"
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>

//TODO Search bar for string searching fx name.
//TODO On first load, distance filter is not working - Only after first dismissing filter.
@implementation LocationViewController {

}

@synthesize tableViewController, diningTableView, refreshControl, bottomRefreshControl, filter, toolbar;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
    [[LocationViewModel instance] refreshLocations:true];
    [LocationViewModel instance].delegate = self;

    self.navigationItem.title = NSLocalizedString(LocationTypeString([LocationViewModel instance].locationType), nil);
}

- (void)dealloc {
    [[LocationViewModel instance] reset];
}

- (void)viewDidAppear:(BOOL)animated {
    [self setupHints];
}

#pragma mark Onboarding

- (void)setupHints {

    if (![[HalalGuideOnboarding instance] wasOnBoardingShow:kAddNewOnBoardingButtonKey]) {

        [self.navigationItem.rightBarButtonItem showOnBoardingWithHintKey:kAddNewOnBoardingButtonKey withDelegate:self];

    } else if (![[HalalGuideOnboarding instance] wasOnBoardingShow:kFilterOnBoardingButtonKey]) {

        [self.filter showOnBoardingWithHintKey:kFilterOnBoardingButtonKey withDelegate:self];

    }
}

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {

    if (popTipView.targetObject == self.navigationItem.rightBarButtonItem) {
        [self.filter showOnBoardingWithHintKey:kFilterOnBoardingButtonKey withDelegate:self];
    }

    else if (popTipView.targetObject == self.filter) {

        LocationTableViewCell *cell = (LocationTableViewCell *) [[self.diningTableView visibleCells] firstObject];
        if ([cell class] == [DiningTableViewCell class]) {
            [((DiningTableViewCell *) cell) showToolTip];
        }
    }
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"DiningDetail"] || [segue.identifier isEqualToString:@"ShopDetail"] || [segue.identifier isEqualToString:@"MosqueDetail"]) {
        Location *location = [[LocationViewModel instance] locationForRow:[self.diningTableView indexPathForSelectedRow].row];
        [LocationDetailViewModel instance].location = location;
    } else if ([segue.identifier isEqualToString:@"CreateLocation"]) {
        [CreateLocationViewModel instance].locationType = [LocationViewModel instance].locationType;
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

    self.noResults.hidden = ![[LocationViewModel instance].locations count] == 0;
}

#pragma mark - TableView

- (void)configureTableView {
    self.diningTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.tableViewController = [[UITableViewController alloc] init];
    self.tableViewController.tableView = self.diningTableView;

    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl handleControlEvents:UIControlEventValueChanged withBlock:^(id weakControl) {
        [LocationViewModel instance].page = 0;
        [[LocationViewModel instance] refreshLocations:false];
    }];
    self.tableViewController.refreshControl = self.refreshControl;

    self.bottomRefreshControl = [UIRefreshControl new];
    self.diningTableView.bottomRefreshControl = self.bottomRefreshControl;
    [self.bottomRefreshControl handleControlEvents:UIControlEventValueChanged withBlock:^(id weakControl) {
        [LocationViewModel instance].page++;
        [[LocationViewModel instance] refreshLocations:false];
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[LocationViewModel instance] numberOfLocations];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    Location *location = [[LocationViewModel instance] locationForRow:indexPath.row];


    NSString *identifier = LocationTypeString([LocationViewModel instance].locationType);
    LocationTableViewCell *cell = [self.diningTableView dequeueReusableCellWithIdentifier:identifier];

    [cell configure:location];

    if ([cell class] == [DiningTableViewCell class]) {
        //If onBoarding was dismissed before cells where displayed
        if (![[HalalGuideOnboarding instance] wasOnBoardingShow:kDiningCellPorkOnBoardingKey] && [[HalalGuideOnboarding instance] wasOnBoardingShow:kFilterOnBoardingButtonKey]) {
            [((DiningTableViewCell *) cell) showToolTip];
        }

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}


@end
