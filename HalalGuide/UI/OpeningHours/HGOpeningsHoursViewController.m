//
// Created by Privat on 21/01/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIControl+ALActionBlocks.h>
#import "UIBarButtonItem+ALActionBlocks.h"
#import "UIAlertController+Blocks.m"
#import <IQKeyboardManager/IQUIView+Hierarchy.h>
#import "HGOpeningsHoursViewController.h"
#import "HGCreateLocationViewModel.h"
#import "HGCreateReviewViewController.h"

@implementation HGOpeningsHoursViewController {
    WeekDay currentWeekDay;
    NSDateFormatter *formatter;
}

@synthesize viewModel;

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
        [self.viewModel.createdLocation setOpen:[NSDate dateWithTimeIntervalSince1970:60 * 60 * 23] andClose:[NSDate dateWithTimeIntervalSince1970:60 * 60 * 23] forWeekDay:currentWeekDay];
        currentWeekDay = abs(currentWeekDay + 1) % 7;
        [self setWeekDayLabel];
        [self setOpenCloseTime];
    }];

    [self.finished handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        [UIView animateWithDuration:1 animations:^{
            [self.datePickerView setY:self.view.height];
        }];
    }];

    [self.rightBarButton setBlock:^(id weakSender) {

        [UIAlertController showAlertInViewController:self withTitle:NSLocalizedString(@"HGOpeningsHoursViewController.alert.title.ok", nil) message:NSLocalizedString(@"HGOpeningsHoursViewController.alert.message.location.saved", nil) cancelButtonTitle:NSLocalizedString(@"HGOpeningsHoursViewController.alert.cancel.done", nil) destructiveButtonTitle:nil otherButtonTitles:@[NSLocalizedString(@"HGOpeningsHoursViewController.alert.add.review", nil)] tapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex) {
            if (UIAlertControllerBlocksCancelButtonIndex == buttonIndex) {
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            } else if (UIAlertControllerBlocksFirstOtherButtonIndex == buttonIndex) {
                [self performSegueWithIdentifier:@"CreateReview" sender:self];
            }
        }];

    }];
}

- (void)saveOpenCloseToLocation {
    //TODO Move to viewmodel
    [self.viewModel.createdLocation setOpen:self.openPicker.date andClose:self.closePicker.date forWeekDay:currentWeekDay];
    [self.viewModel.createdLocation saveInBackground];
}

- (void)setOpenCloseLabel {
    UILabel *label = (UILabel *) [self.view viewWithTag:currentWeekDay + 100];
    label.text = [NSString stringWithFormat:@"%@ - %@", [formatter stringFromDate:self.openPicker.date], [formatter stringFromDate:self.closePicker.date]];
}

- (void)setWeekDayLabel {
    self.day.text = NSLocalizedString(DayString(currentWeekDay), nil);
}

- (void)setOpenCloseTime {
    NSDictionary *openClose = [self.viewModel.createdLocation openCloseForWeekDay:currentWeekDay];
    if (openClose) {
        self.openPicker.date = [openClose valueForKey:@"open"];
        self.closePicker.date = [openClose valueForKey:@"close"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.datePickerView setY:self.view.height];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"CreateReview"]) {
       // HGCreateReviewViewController *viewController = (HGCreateReviewViewController *) segue.destinationViewController;
//        viewController.viewModel = [[HGCreateReviewViewModel alloc] initWithReviewedLocation:self.viewModel.createdLocation];
    }
}


@end