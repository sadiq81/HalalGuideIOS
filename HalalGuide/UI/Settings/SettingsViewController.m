//
// Created by Privat on 20/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIControl+ALActionBlocks.h>
#import "SettingsViewController.h"
#import "DiningViewModel.h"
#import "HalalGuideSettings.h"
#import "SDImageCache.h"


@implementation SettingsViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.resetFilter handleControlEvents:UIControlEventTouchUpInside withBlock:^(UIButton *weakSender) {
        [HalalGuideSettings instance].distanceFilter = [DiningViewModel instance].maximumDistance = 5;
        [HalalGuideSettings instance].porkFilter = [DiningViewModel instance].showPork = true;
        [HalalGuideSettings instance].alcoholFilter = [DiningViewModel instance].showAlcohol = true;
        [HalalGuideSettings instance].halalFilter = [DiningViewModel instance].showNonHalal = true;
        [HalalGuideSettings instance].categoriesFilter = [DiningViewModel instance].categories = [NSMutableArray new];
    }];

    [self.restorePurchases handleControlEvents:UIControlEventTouchUpInside withBlock:^(UIButton *weakSender) {
        //TODO
    }];

    [self.clearCache handleControlEvents:UIControlEventTouchUpInside withBlock:^(UIButton *weakSender) {
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDisk];

        //TODO Clear pinned objects from parse
    }];
}
@end