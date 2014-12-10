//
//  FilterDiningViewController.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ALActionBlocks/ALActionBlocks.h>
#import "FilterDiningViewController.h"
#import "DiningViewModel.h"
#import "MZFormSheetSegue.h"
#import "IQUIView+Hierarchy.h"
#import "CategoriesViewController.h"


@implementation FilterDiningViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUILabels];

    [self.distanceSlider handleControlEvents:UIControlEventValueChanged withBlock:^(UISlider *weakControl) {
        int value = (int) weakControl.value;
        weakControl.value = value;
        if (value != 20) {
            self.distanceLabel.text = [NSString stringWithFormat:@"%i km", value];
        } else {
            self.distanceLabel.text = @"Ubegrænset";
        }

    }];

    [self.reset handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        [[DiningViewModel instance].categories removeAllObjects];
        [self setUILabels];
    }];

    __weak typeof(self) weakSelf = self;
    [self.done setBlock:^(id weakSender) {
        [weakSelf dismissViewControllerAnimated:true completion:nil];
    }];
}

- (void)setUILabels {
    int count = (int)[[DiningViewModel instance].categories count];
    self.countLabel.text = [NSString stringWithFormat:@"%i", count];

    self.porkSwitch.on = [DiningViewModel instance].showPork;
    self.alcoholSwitch.on = [DiningViewModel instance].showAlcohol;
    self.halalSwitch.on = [DiningViewModel instance].showNonHalal;
    self.distanceSlider.value = [DiningViewModel instance].maximumDistance;
    self.distanceLabel.text = [NSString stringWithFormat:@"%i km", [DiningViewModel instance].maximumDistance];
}

- (void)viewDidDisappear:(BOOL)animated {
    [DiningViewModel instance].showPork = self.porkSwitch.on;
    [DiningViewModel instance].showAlcohol = self.alcoholSwitch.on;
    [DiningViewModel instance].showNonHalal = self.halalSwitch.on;
    [DiningViewModel instance].maximumDistance = (int) self.distanceSlider.value;

    [[DiningViewModel instance] refreshLocations:true];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"chooseCategories"]) {
        CategoriesViewController *destination = (CategoriesViewController *) segue.destinationViewController;
        destination.viewModel = [DiningViewModel instance];

        MZFormSheetSegue *formSheetSegue = (MZFormSheetSegue *) segue;
        MZFormSheetController *formSheet = formSheetSegue.formSheetController;
        formSheet.presentedFormSheetSize = CGSizeMake(self.view.size.width * 0.8f, self.view.size.height * 0.8f);
        formSheet.transitionStyle = MZFormSheetTransitionStyleBounce;
        formSheet.cornerRadius = 8.0;
        formSheet.shouldDismissOnBackgroundViewTap = YES;
        formSheet.didDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
            [self setUILabels];
        };
    }
}


#pragma mark - TableView


#pragma mark - UINavigationBarDelegate

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}


@end
