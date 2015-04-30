//
// Created by Privat on 21/01/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIControl+ALActionBlocks.h>
#import "UIBarButtonItem+ALActionBlocks.h"

#import <IQKeyboardManager/IQUIView+Hierarchy.h>
#import "HGOpeningsHoursViewController.h"
#import "HGCreateLocationViewModel.h"
#import "HGCreateReviewViewController.h"
#import "HGDateFormatter.h"
#import "UIViewController+Extension.h"

@interface HGOpeningsHoursViewController ()

@property(strong, nonatomic) UIBarButtonItem *rightBarButton;
@property(strong, nonatomic) UIButton *chooseButton;

@property(strong, nonatomic) UIVisualEffectView *datePickerView;

@property(strong, nonatomic) UIDatePicker *openPicker;
@property(strong, nonatomic) UIDatePicker *closePicker;
@property(strong, nonatomic) UIButton *next;
@property(strong, nonatomic) UIButton *previous;
@property(strong, nonatomic) UIButton *closed;
@property(strong, nonatomic) UIButton *finished;
@property(strong, nonatomic) UILabel *day;

@property(nonatomic) WeekDay currentWeekDay;

@property(strong, nonatomic) HGCreateLocationViewModel *viewModel;

@end


@implementation HGOpeningsHoursViewController {

}

@synthesize viewModel;

- (instancetype)initWithViewModel:(HGCreateLocationViewModel *)model {
    self = [super init];
    if (self) {
        self.viewModel = model;

    }

    return self;
}

+ (instancetype)controllerWithViewModel:(HGCreateLocationViewModel *)model {
    return [[self alloc] initWithViewModel:model];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupViews];
    [self setupNavigationBar];
    [self setupViewModel];
    [self updateViewConstraints];

    self.currentWeekDay = WeekDayMonday;


    [self.chooseButton handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        [UIView animateWithDuration:1 animations:^{
            //[self.datePickerView setY:self.view.frame.size.height - self.datePickerView.frame.size.height];
        }];
    }];

    [self.previous handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        [self setOpenCloseLabel];
        [self saveOpenCloseToLocation];
        self.currentWeekDay = abs(self.currentWeekDay + 6) % 7;
        [self setWeekDayLabel];
        [self setOpenCloseTime];
    }];

    [self.next handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        [self setOpenCloseLabel];
        [self saveOpenCloseToLocation];
        self.currentWeekDay = abs(self.currentWeekDay + 1) % 7;
        [self setWeekDayLabel];
        [self setOpenCloseTime];
    }];

    [self.closed handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        UILabel *label = (UILabel *) [self.view viewWithTag:self.currentWeekDay + 100];
        label.text = NSLocalizedString(@"closed", nil);
        [self.viewModel.createdLocation setOpen:[NSDate dateWithTimeIntervalSince1970:60 * 60 * 23] andClose:[NSDate dateWithTimeIntervalSince1970:60 * 60 * 23] forWeekDay:self.currentWeekDay];
        self.currentWeekDay = abs(self.currentWeekDay + 1) % 7;
        [self setWeekDayLabel];
        [self setOpenCloseTime];
    }];

    [self.finished handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        [UIView animateWithDuration:1 animations:^{
            //[self.datePickerView setY:self.view.height];
        }];
    }];


}

- (void)setupViews {

}

- (void)setupNavigationBar {

    [self.navigationItem setHidesBackButton:true animated:false];

    [self.rightBarButton setBlock:^(id weakSender) {


    }];
}

- (void)setupViewModel {

}

- (void)saveOpenCloseToLocation {
    //TODO Move to viewmodel
    [self.viewModel.createdLocation setOpen:self.openPicker.date andClose:self.closePicker.date forWeekDay:self.currentWeekDay];
    [self.viewModel.createdLocation saveInBackground];
}

- (void)setOpenCloseLabel {
    UILabel *label = (UILabel *) [self.view viewWithTag:self.currentWeekDay + 100];
    label.text = [NSString stringWithFormat:@"%@ - %@", [HGDateFormatter shortTimeFormat:self.openPicker.date], [HGDateFormatter shortTimeFormat:self.closePicker.date]];
}

- (void)setWeekDayLabel {
    self.day.text = NSLocalizedString(DayString(self.currentWeekDay), nil);
}

- (void)setOpenCloseTime {
    NSDictionary *openClose = [self.viewModel.createdLocation openCloseForWeekDay:self.currentWeekDay];
    if (openClose) {
        self.openPicker.date = [openClose valueForKey:@"open"];
        self.closePicker.date = [openClose valueForKey:@"close"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //[self.datePickerView setY:self.view.height];
}

- (void)updateViewConstraints {


    [super updateViewConstraints];
}


@end