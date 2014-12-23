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
#import "HalalGuideSettings.h"


@implementation FilterDiningViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    __weak typeof(self) weakSelf = self;

    [self setUILabels];

    [self.distanceSlider handleControlEvents:UIControlEventValueChanged withBlock:^(UISlider *weakControl) {
        weakControl.value = [@(weakControl.value) intValue];
        [self setDistanceLabelText];
    }];

    [self.reset handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        [[DiningViewModel instance].categories removeAllObjects];
        [weakSelf setCountLabelText];
    }];


    [self.done setBlock:^(id weakSender) {
        [weakSelf dismissViewControllerAnimated:true completion:nil];
    }];
}

- (void)setUILabels {
    [self setCountLabelText];

    self.porkSwitch.on = [DiningViewModel instance].showPork;
    self.alcoholSwitch.on = [DiningViewModel instance].showAlcohol;
    self.halalSwitch.on = [DiningViewModel instance].showNonHalal;
    self.distanceSlider.value = [DiningViewModel instance].maximumDistance;

    [self setDistanceLabelText];
}

- (void)setCountLabelText {
    int count = (int) [[DiningViewModel instance].categories count];
    self.countLabel.text = [NSString stringWithFormat:@"%i", count];
}

- (void)setDistanceLabelText {
    if (self.distanceSlider.value != 20) {
        self.distanceLabel.text = [NSString stringWithFormat:@"%i km", (int) self.distanceSlider.value];
    } else {
        self.distanceLabel.text = NSLocalizedString(@"unlimited", nil);
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [DiningViewModel instance].showPork = [HalalGuideSettings instance].porkFilter = self.porkSwitch.on;
    [DiningViewModel instance].showAlcohol = [HalalGuideSettings instance].alcoholFilter = self.alcoholSwitch.on;
    [DiningViewModel instance].showNonHalal = [HalalGuideSettings instance].halalFilter = self.halalSwitch.on;
    [DiningViewModel instance].maximumDistance = [HalalGuideSettings instance].distanceFilter = (NSUInteger) self.distanceSlider.value;
    [HalalGuideSettings instance].categoriesFilter = [DiningViewModel instance].categories;

    [[DiningViewModel instance] reset];
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
            [self setCountLabelText];
        };
    }
}

#pragma mark - UINavigationBarDelegate

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}


@end
