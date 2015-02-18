//
// Created by Privat on 20/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIControl+ALActionBlocks.h>
#import "SettingsViewController.h"
#import "LocationViewModel.h"
#import "HalalGuideSettings.h"
#import "SDImageCache.h"
#import "HalalGuideOnboarding.h"
#import "UIView+Extensions.h"
#import "UIAlertController+Blocks.h"
#import "UIViewController+Extension.h"
#import "RMStore.h"

@implementation SettingsViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[self.resetFilter rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [HalalGuideSettings instance].distanceFilter = 5;
        [HalalGuideSettings instance].porkFilter = true;
        [HalalGuideSettings instance].alcoholFilter = true;
        [HalalGuideSettings instance].halalFilter = true;
        [HalalGuideSettings instance].categoriesFilter = [NSMutableArray new];
        [HalalGuideSettings instance].shopCategoriesFilter = [NSMutableArray new];
    }];

    [[self.restorePurchases rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        [[RMStore defaultStore] addPayment:@"Support" success:^(SKPaymentTransaction *transaction) {
            //[SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"thankText", nil)];
        }                          failure:^(SKPaymentTransaction *transaction, NSError *error) {
            //[SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }];

    [[self.clearCache rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDisk];
    }];


    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

@end