//
//  FilterLocationViewController.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ALActionBlocks/ALActionBlocks.h>
#import "FilterLocationViewController.h"
#import "LocationViewModel.h"
#import "MZFormSheetSegue.h"
#import "IQUIView+Hierarchy.h"
#import "CategoriesViewController.h"
#import "HGSettings.h"
#import "CreateLocationViewModel.h"


@implementation FilterLocationViewController {

}

@synthesize viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUILabels];

    @weakify(self)
    [[self.distanceSlider rac_newValueChannelWithNilValue:nil] subscribeNext:^(NSNumber * value) {
        @strongify(self)
        self.distanceSlider.value = value.intValue;
        [self setDistanceLabelText];
    }];

    [[self.reset rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(NSNumber * value) {
        @strongify(self)
                switch (self.viewModel.locationType){
            case LocationTypeDining:{
                [self.viewModel.categories removeAllObjects];
                break;
            }
            case LocationTypeShop:{
                [self.viewModel.shopCategories removeAllObjects];
                break;
            }
            case LocationTypeMosque:{
                break;
            }
        }
        [self setCountLabelText];
    }];

    [[self.distanceSlider rac_newValueChannelWithNilValue:nil] subscribeNext:^(NSNumber * value) {
        @strongify(self)
        self.distanceSlider.value = value.intValue;
        [self setDistanceLabelText];
    }];

    self.done.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        [self dismissViewControllerAnimated:true completion:nil];
        return [RACSignal empty];
    }];

    [self setupLocationType];
}

- (void)setupLocationType {

    if (self.viewModel.locationType != LocationTypeDining) {
        [self.switchView removeFromSuperview];
        self.categoryView.frame = CGRectMake(self.categoryView.x, self.distanceSlider.y + self.distanceSlider.height + 8, self.categoryView.width, self.categoryView.height);

        if (self.viewModel.locationType == LocationTypeMosque) {
            [self.reset removeFromSuperview];
            self.categories.text = @"";
            self.categories.text = NSLocalizedString(@"language", nil);
        } else if (self.viewModel.locationType == LocationTypeShop) {

        }
    }
}

- (void)setUILabels {
    [self setCountLabelText];

    self.porkSwitch.on = self.viewModel.showPork;
    self.alcoholSwitch.on = self.viewModel.showAlcohol;
    self.halalSwitch.on = self.viewModel.showNonHalal;
    self.distanceSlider.value = self.viewModel.maximumDistance;

    [self setDistanceLabelText];
}

- (void)setCountLabelText {

    if (self.viewModel.locationType == LocationTypeMosque) {
        self.countLabel.text = NSLocalizedString(LanguageString(self.viewModel.language), nil);
    } else if (self.viewModel.locationType == LocationTypeShop) {
        int count = (int) [self.viewModel.shopCategories count];
        self.countLabel.text = [NSString stringWithFormat:@"%i", count];
    } else if (self.viewModel.locationType == LocationTypeDining) {
        int count = (int) [self.viewModel.categories count];
        self.countLabel.text = [NSString stringWithFormat:@"%i", count];
    }
}

- (void)setDistanceLabelText {
    if (self.distanceSlider.value != 20) {
        self.distanceLabel.text = [NSString stringWithFormat:@"%i km", (int) self.distanceSlider.value];
    } else {
        self.distanceLabel.text = NSLocalizedString(@"unlimited", nil);
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    self.viewModel.showPork = [HGSettings instance].porkFilter = self.porkSwitch.on;
    self.viewModel.showAlcohol = [HGSettings instance].alcoholFilter = self.alcoholSwitch.on;
    self.viewModel.showNonHalal = [HGSettings instance].halalFilter = self.halalSwitch.on;
    self.viewModel.maximumDistance = [HGSettings instance].distanceFilter = (NSUInteger) self.distanceSlider.value;
    [HGSettings instance].categoriesFilter = self.viewModel.categories;

    [self.viewModel refreshLocations];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];

    __weak typeof(self) weakSelf = self;

    if ([segue.identifier isEqualToString:@"chooseCategories"]) {
        CategoriesViewController *destination = (CategoriesViewController *) segue.destinationViewController;
        destination.viewModel = self.viewModel;
        destination.locationType = self.viewModel.locationType;

        MZFormSheetSegue *formSheetSegue = (MZFormSheetSegue *) segue;
        MZFormSheetController *formSheet = formSheetSegue.formSheetController;
        formSheet.presentedFormSheetSize = CGSizeMake(self.view.size.width * 0.8f, self.view.size.height * 0.8f);
        formSheet.transitionStyle = MZFormSheetTransitionStyleBounce;
        formSheet.cornerRadius = 8.0;
        formSheet.shouldDismissOnBackgroundViewTap = YES;
        formSheet.didDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
            [weakSelf setCountLabelText];
        };
    }
}

#pragma mark - UINavigationBarDelegate

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}


@end
