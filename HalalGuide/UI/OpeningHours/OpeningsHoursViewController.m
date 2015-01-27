//
// Created by Privat on 21/01/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIControl+ALActionBlocks.h>
#import <IQKeyboardManager/IQUIView+Hierarchy.h>
#import "OpeningsHoursViewController.h"
#import "CreateLocationViewModel.h"

@implementation OpeningsHoursViewController {
    WeekDay currentWeekDay;
    NSDateFormatter *formatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    currentWeekDay = WeekDayMonday;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];

    [self.navigationItem setHidesBackButton:true animated:false];

    [self.chooseButton handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        [UIView animateWithDuration:1 animations:^{
            [self.datePickerView setY:self.view.height - self.datePickerView.height];
        }];
    }];

    [self.previous handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        [self setOpenCloseLabel];
        [self saveOpenCloseToLocation];
        currentWeekDay = abs(currentWeekDay + 6) % 7;
        [self setWeekDayLabel];
        [self setOpenCloseTime];
    }];

    [self.next handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        [self setOpenCloseLabel];
        [self saveOpenCloseToLocation];
        currentWeekDay = abs(currentWeekDay + 1) % 7;
        [self setWeekDayLabel];
        [self setOpenCloseTime];
    }];

    [self.closed handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        UILabel *label = (UILabel *) [self.view viewWithTag:currentWeekDay + 100];
        label.text = NSLocalizedString(@"closed", nil);
        [[CreateLocationViewModel instance].createdLocation setOpen:[NSDate dateWithTimeIntervalSince1970:60*60*23] andClose:[NSDate dateWithTimeIntervalSince1970:60*60*23] forWeekDay:currentWeekDay];
        currentWeekDay = abs(currentWeekDay + 1) % 7;
        [self setWeekDayLabel];
        [self setOpenCloseTime];
    }];

    [self.finished handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        [UIView animateWithDuration:1 animations:^{
            [self.datePickerView setY:self.view.height];
        }];
    }];
}

- (void)saveOpenCloseToLocation {
    //TODO Move to viewmodel
    [[CreateLocationViewModel instance].createdLocation setOpen:self.openPicker.date andClose:self.closePicker.date forWeekDay:currentWeekDay];
    [[CreateLocationViewModel instance].createdLocation saveInBackground];
}

- (void)setOpenCloseLabel {
    UILabel *label = (UILabel *) [self.view viewWithTag:currentWeekDay + 100];
    label.text = [NSString stringWithFormat:@"%@ - %@", [formatter stringFromDate:self.openPicker.date], [formatter stringFromDate:self.closePicker.date]];
}

- (void)setWeekDayLabel {
    self.day.text = NSLocalizedString(DayString(currentWeekDay), nil);
}

- (void)setOpenCloseTime {
    NSDictionary *openClose = [[CreateLocationViewModel instance].createdLocation openCloseForWeekDay:currentWeekDay];
    if (openClose){
        self.openPicker.date = [openClose valueForKey:@"open"];
        self.closePicker.date = [openClose valueForKey:@"close"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.datePickerView setY:self.view.height];
}

@end