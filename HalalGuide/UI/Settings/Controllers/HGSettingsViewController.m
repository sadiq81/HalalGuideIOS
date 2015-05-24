//
// Created by Privat on 20/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIControl+ALActionBlocks.h>
#import <Masonry/View+MASAdditions.h>
#import <AsyncImageView/AsyncImageView.h>
#import "HGSettingsViewController.h"
#import "HGLocationViewModel.h"
#import "HGSettings.h"
#import "HGOnboarding.h"
#import "UIAlertController+Blocks.h"
#import "UIViewController+Extension.h"
#import "RMStore.h"
#import "HGENumberViewController.h"

@interface HGSettingsViewController ()

@property(strong, nonatomic) UITableViewCell *clearCache;
@property(strong, nonatomic) UITableViewCell *support;
@property(strong, nonatomic) UITableViewCell *resetFilter;
@property(strong, nonatomic) UITableViewCell *resetIntro;
@property(strong, nonatomic) UITableViewCell *logOut;
@property(strong, nonatomic) UITableViewCell *enumber;
@end

@implementation HGSettingsViewController {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViews];
        [self updateViewConstraints];

        [PFAnalytics trackEvent:@"SettingsView" dimensions:nil];
    }

    return self;
}

- (void)setupViews {

    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];

    self.clearCache = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    self.clearCache.textLabel.text = NSLocalizedString(@"HGSettingsViewController.button.clear.cache", nil);

    self.support = [[UITableViewCell alloc] init];
    self.support.textLabel.text = NSLocalizedString(@"HGSettingsViewController.button.support", nil);

    self.resetFilter = [[UITableViewCell alloc] init];
    self.resetFilter.textLabel.text = NSLocalizedString(@"HGSettingsViewController.button.reset.filter", nil);

    self.resetIntro = [[UITableViewCell alloc] init];
    self.resetIntro.textLabel.text = NSLocalizedString(@"HGSettingsViewController.button.reset.intro", nil);

    self.logOut = [[UITableViewCell alloc] init];
    self.logOut.selectionStyle = [[PFUser currentUser] isAuthenticated] ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
    self.logOut.textLabel.textColor = [[PFUser currentUser] isAuthenticated] ? [UIColor blackColor] : [UIColor lightGrayColor];
    self.logOut.textLabel.text = NSLocalizedString(@"HGSettingsViewController.button.log.out", nil);

    self.enumber = [[UITableViewCell alloc] init];
    self.enumber.textLabel.text = NSLocalizedString(@"HGSettingsViewController.button.enumber", nil);

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 3;
        case 2:
            return 1;
        case 3:
            return 1;
        default:
            return 0;
    };
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    return self.support;
            }
        case 1:
            switch (indexPath.row) {
                case 0:
                    return self.resetFilter;
                case 1:
                    return self.resetIntro;
                case 2:
                    return self.clearCache;
            }
        case 2:
            switch (indexPath.row) {
                case 0:
                    return self.logOut;
            }
        case 3:
            switch (indexPath.row) {
                case 0:
                    return self.enumber;
            }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [[RMStore defaultStore] addPayment:@"Support" success:nil failure:nil];
            }
        case 1:
            switch (indexPath.row) {
                case 0:
                    [HGSettings instance].maximumDistanceShop= @(5);
                    [HGSettings instance].maximumDistanceDining= @(5);
                    [HGSettings instance].maximumDistanceMosque= @(5);
                    [HGSettings instance].porkFilter = @(false);
                    [HGSettings instance].alcoholFilter = @(false);
                    [HGSettings instance].halalFilter = @(false);
                    [HGSettings instance].categoriesFilter = [NSMutableArray new];
                    [HGSettings instance].shopCategoriesFilter = [NSMutableArray new];
                    break;
                case 1:
                    [[HGOnboarding instance] resetOnBoarding];
                    break;
                case 2:
                    [[AsyncImageLoader sharedLoader].cache removeAllObjects];
                    break;
            }
        case 2:
            switch (indexPath.row) {
                case 0:
                    [PFUser logOut];
            }
        case 3:
            switch (indexPath.row) {
                case 0:{
                    HGENumberViewController *controller = [[HGENumberViewController alloc] init];
                    [self.navigationController pushViewController:controller animated:true];
                }
            }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return NSLocalizedString(@"HGSettingsViewController.section.title.support", nil);
        case 1:
            return NSLocalizedString(@"HGSettingsViewController.section.title.reset", nil);
        case 2:
            return NSLocalizedString(@"HGSettingsViewController.section.title.profile", nil);
        case 3:
            return NSLocalizedString(@"HGSettingsViewController.section.title.misc", nil);
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22;
}

- (void)updateViewConstraints {

//    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];

    [super updateViewConstraints];
}


@end