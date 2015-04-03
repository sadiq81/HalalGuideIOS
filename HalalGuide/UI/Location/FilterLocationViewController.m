//
//  FilterLocationViewController.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ALActionBlocks/ALActionBlocks.h>
#import <Masonry/View+MASAdditions.h>
#import <MZFormSheetController/MZFormSheetController.h>
#import "FilterLocationViewController.h"
#import "LocationViewModel.h"
#import "HGCategoriesView.h"
#import "HGSwitchView.h"
#import "CategoriesViewController.h"

@interface FilterLocationViewController ()

@property(strong, nonatomic) UIToolbar *toolbar;
@property(strong, nonatomic) UIBarButtonItem *dismiss;

@property(strong, nonatomic) UILabel *distanceHeadline;
@property(strong, nonatomic) UILabel *distanceLabel;
@property(strong, nonatomic) UISlider *distanceSlider;


@property(strong, nonatomic) HGSwitchView *switchView;
@property(strong, nonatomic) HGCategoriesView *categoryView;
@property(strong, nonatomic) UIBarButtonItem *done;

@property(strong, nonatomic) LocationViewModel *viewModel;

@end

@implementation FilterLocationViewController {

}


@synthesize viewModel;

- (instancetype)initWithViewModel:(LocationViewModel *)model {
    self = [super init];
    if (self) {
        self.viewModel = model;
        [self setupViews];
        [self setupToolbar];
        [self setupViewModel];
        [self updateViewConstraints];
    }

    return self;
}

- (void)setupViews {

    self.view.backgroundColor = [UIColor whiteColor];

    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.toolbar];

    self.dismiss = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"FilterLocationViewController.button.dismiss", nil) style:UIBarButtonItemStylePlain block:nil];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [self.toolbar setItems:@[self.dismiss, spacer]];

    self.distanceHeadline = [[UILabel alloc] initWithFrame:CGRectZero];
    self.distanceHeadline.text = NSLocalizedString(@"FilterLocationViewController.label.max.distance", nil);
    [self.view addSubview:self.distanceHeadline];

    self.distanceSlider = [[UISlider alloc] initWithFrame:CGRectZero];
    self.distanceSlider.minimumValue = 1;
    self.distanceSlider.maximumValue = 20;
    self.distanceSlider.value = self.viewModel.maximumDistance.floatValue;
    [self.view addSubview:self.distanceSlider];

    self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.distanceLabel];
    [self setDistanceLabelText];

    self.switchView = [[HGSwitchView alloc] initWithViewModel:self.viewModel];
    [self.view addSubview:self.switchView];

    self.categoryView = [[HGCategoriesView alloc] initWithViewModel:self.viewModel];
    [self.view addSubview:self.categoryView];
}

- (void)setupToolbar {

    @weakify(self)
    [self.dismiss setBlock:^(id weakSender) {
        @strongify(self);
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
            [self.viewModel refreshLocations];
        }];
    }];
}

- (void)setupViewModel {

    @weakify(self)
    [[[[[self.distanceSlider rac_signalForControlEvents:UIControlEventValueChanged] skip:1] map:^id(UISlider *slider) {
        @strongify(self)
        [self setDistanceLabelText];
        return @(slider.value);
    }] throttle:1] subscribeNext:^(NSNumber *value) {
        @strongify(self)
        [self.viewModel setMaximumDistance:value];
    }];

    [[self.categoryView.choose rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)

        CategoriesViewController *viewController = [CategoriesViewController controllerWithViewModel:self.viewModel];
        MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:viewController];
        formSheet.presentedFSViewController.view.clipsToBounds = false;

        CGRect screenRect = [[UIScreen mainScreen] bounds];
        formSheet.presentedFormSheetSize= CGSizeMake(CGRectGetWidth(screenRect)*0.8, CGRectGetHeight(screenRect)*0.8);
        formSheet.transitionStyle = MZFormSheetTransitionStyleBounce;
        formSheet.cornerRadius = 8.0;
        formSheet.shouldDismissOnBackgroundViewTap = true;
        formSheet.didDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
            [self.categoryView setCountLabelText];
        };

        [self mz_presentFormSheetController:formSheet animated:YES completionHandler:nil];
    }];

}

+ (instancetype)controllerWithViewModel:(LocationViewModel *)viewModel {
    return [[self alloc] initWithViewModel:viewModel];
}


- (void)setDistanceLabelText {
        if (self.distanceSlider.value != 20) {
            self.distanceLabel.text = [NSString stringWithFormat:@"%i km", (int) self.distanceSlider.value];
        } else {
            self.distanceLabel.text = NSLocalizedString(@"unlimited", nil);
        }
}

- (void)updateViewConstraints {


    [self.toolbar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(64));
    }];

    [self.distanceHeadline mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolbar.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(8);
        make.right.equalTo(self.view.mas_centerX);
    }];

    [self.distanceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolbar.mas_bottom).offset(20);
        make.right.equalTo(self.view).offset(-8);
    }];

    [self.distanceSlider mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distanceLabel.mas_bottom).offset(8);
        make.left.equalTo(self.view).offset(8);
        make.right.equalTo(self.view).offset(-8);
    }];

    [self.switchView mas_updateConstraints:^(MASConstraintMaker *make) {

        if (self.viewModel.locationType != LocationTypeDining) {
            make.top.equalTo(self.view.mas_bottom);
        } else {
            make.top.equalTo(self.distanceSlider.mas_bottom).offset(8);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
        }
    }];

    [self.categoryView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.viewModel.locationType != LocationTypeDining) {
            make.top.equalTo(self.distanceSlider.mas_bottom).offset(8);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
        } else {
            make.top.equalTo(self.switchView.mas_bottom).offset(8);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
        }
    }];

    [super updateViewConstraints];
}


@end

