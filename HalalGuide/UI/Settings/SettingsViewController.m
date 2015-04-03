//
// Created by Privat on 20/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIControl+ALActionBlocks.h>
#import <Masonry/View+MASAdditions.h>
#import "SettingsViewController.h"
#import "LocationViewModel.h"
#import "HGSettings.h"
#import "SDImageCache.h"
#import "HGOnboarding.h"
#import "UIView+Extensions.h"
#import "UIAlertController+Blocks.h"
#import "UIViewController+Extension.h"
#import "RMStore.h"

@interface SettingsViewController ()

@property(strong, nonatomic) UITableViewCell *clearCache;
@property(strong, nonatomic) UITableViewCell *support;
@property(strong, nonatomic) UITableViewCell *resetFilter;
@property(strong, nonatomic) UITableViewCell *resetIntro;
@end

@implementation SettingsViewController {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViews];
        [self updateViewConstraints];
    }

    return self;
}

- (void)setupViews {

    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];

    self.clearCache = [[UITableViewCell alloc] init];
    self.clearCache.textLabel.textColor = [UIColor colorWithRed:0.0 green:122.0 / 255.0 blue:1.0 alpha:1.0];
    self.clearCache.textLabel.text = NSLocalizedString(@"SettingsViewController.button.clear.cache", nil);

    self.support = [[UITableViewCell alloc] init];
    self.support.textLabel.textColor = [UIColor colorWithRed:0.0 green:122.0 / 255.0 blue:1.0 alpha:1.0];
    self.support.textLabel.text = NSLocalizedString(@"SettingsViewController.button.support", nil);

    self.resetFilter = [[UITableViewCell alloc] init];
    self.resetFilter.textLabel.textColor = [UIColor colorWithRed:0.0 green:122.0 / 255.0 blue:1.0 alpha:1.0];
    self.resetFilter.textLabel.text = NSLocalizedString(@"SettingsViewController.button.reset.filter", nil);

    self.resetIntro = [[UITableViewCell alloc] init];
    self.resetIntro.textLabel.textColor = [UIColor colorWithRed:0.0 green:122.0 / 255.0 blue:1.0 alpha:1.0];
    self.resetIntro.textLabel.text = NSLocalizedString(@"SettingsViewController.button.reset.intro", nil);

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 3;
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
                    [[SDImageCache sharedImageCache] clearMemory];
                    [[SDImageCache sharedImageCache] clearDisk];
                    break;
            }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return NSLocalizedString(@"SettingsViewController.section.title.support", nil);
        case 1:
            return NSLocalizedString(@"SettingsViewController.section.title.reset", nil);
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