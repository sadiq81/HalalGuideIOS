//
// Created by Privat on 20/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIControl+ALActionBlocks.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "SettingsViewController.h"
#import "LocationViewModel.h"
#import "HalalGuideSettings.h"
#import "SDImageCache.h"
#import "HalalGuideOnboarding.h"
#import "UIView+Extensions.h"
#import "UIAlertController+Blocks.h"

@implementation SettingsViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    __weak typeof(self) weakSelf = self;

    [self.resetFilter handleControlEvents:UIControlEventTouchUpInside withBlock:^(UIButton *weakSender) {
        [HalalGuideSettings instance].distanceFilter = [LocationViewModel instance].maximumDistance = 5;
        [HalalGuideSettings instance].porkFilter = [LocationViewModel instance].showPork = true;
        [HalalGuideSettings instance].alcoholFilter = [LocationViewModel instance].showAlcohol = true;
        [HalalGuideSettings instance].halalFilter = [LocationViewModel instance].showNonHalal = true;
        [HalalGuideSettings instance].categoriesFilter = [LocationViewModel instance].categories = [NSMutableArray new];
        [HalalGuideSettings instance].shopCategoriesFilter = [LocationViewModel instance].shopCategories = [NSMutableArray new];
    }];


    [self.restorePurchases handleControlEvents:UIControlEventTouchUpInside withBlock:^(UIButton *weakSender) {

        [PFPurchase buyProduct:@"Support" block:^(NSError *error) {
            if (!error) {
                [UIAlertController showInViewController:weakSelf withTitle:NSLocalizedString(@"thank", nil) message:NSLocalizedString(@"thankText", nil) preferredStyle:UIAlertControllerStyleAlert cancelButtonTitle:NSLocalizedString(@"ok", nil) destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:nil];
            } else {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }
        }];

    }];

    [self.clearCache handleControlEvents:UIControlEventTouchUpInside withBlock:^(UIButton *weakSender) {
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDisk];

        //TODO Clear pinned objects from parse
    }];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

- (void)viewDidAppear:(BOOL)animated {

    [self onBoarding];

}

- (void)onBoarding {

    if (![[HalalGuideOnboarding instance] wasOnBoardingShow:kSupportOnBoardingKey]) {
        [self.restorePurchases showOnBoardingWithHintKey:kSupportOnBoardingKey withDelegate:nil];
    }

}
@end