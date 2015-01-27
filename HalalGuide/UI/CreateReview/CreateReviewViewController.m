//
//  CreateReviewViewController.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIBarButtonItem+ALActionBlocks.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <UIAlertController+Blocks/UIAlertController+Blocks.h>
#import "CreateReviewViewController.h"
#import "EDStarRating.h"
#import "LocationViewController.h"
#import "LocationDetailViewController.h"
#import "CreateReviewViewModel.h"
#import "UIViewController+Extension.h"
#import "OpeningsHoursViewController.h"

@interface CreateReviewViewController ()

@end

@implementation CreateReviewViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupRating];
    [self setupReview];

    [self setupUI];

   [self setupEvents];

}

-(void) setupEvents{

    __weak typeof(self) weakSelf = self;

    [self.regret setBlock:^(id weakSender) {
        [weakSelf finished];
    }];

    [self.save setBlock:^(id weakSender) {

        //TODO Bad flow
        if (![weakSelf areMandatoryDataFilled]) {

            if ([weakSelf.backViewController class] == [LocationDetailViewController class]) {
                [UIAlertController showAlertInViewController:weakSelf withTitle:NSLocalizedString(@"warning", nil) message:NSLocalizedString(@"reviewMinimum", nil) cancelButtonTitle:NSLocalizedString(@"ok", nil) destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:nil];
                return;
            } else {

                if (weakSelf.rating.rating > 0) {
                    [UIAlertController showAlertInViewController:weakSelf withTitle:NSLocalizedString(@"warning", nil) message:NSLocalizedString(@"reviewMinimum", nil) cancelButtonTitle:NSLocalizedString(@"ok", nil) destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:nil];
                    return;
                } else {
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"locationSaved", nil)];
                    [weakSelf finished];
                    return;
                }
            }
        }

        [SVProgressHUD showWithStatus:NSLocalizedString(@"savingToTheCloud", nil) maskType:SVProgressHUDMaskTypeGradient];

        [[CreateReviewViewModel instance] saveEntity:weakSelf.review.text rating:(int) weakSelf.rating.rating onCompletion:^(CreateEntityResult result) {

            dispatch_async(dispatch_get_main_queue(), ^{

                [SVProgressHUD dismiss];

                if (result != CreateEntityResultOk) {
                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(CreateEntityResultString(result), nil) maskType:SVProgressHUDMaskTypeGradient];
                    return;
                } else {

                    if ([weakSelf.backViewController class] == [LocationDetailViewController class]) {
                        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"reviewSaved", nil)];
                    } else {
                        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"locationSaved", nil)];
                    }

                    [weakSelf finished];
                }
            });
        }];
    }];
}

-(void) setupUI{

    if ([self.backViewController class] == [OpeningsHoursViewController class]) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = YES;
    } else {
        [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"save", nil)];
    }
}

- (BOOL)areMandatoryDataFilled {
    return [self.review.text length] > 30 && self.rating.rating > 0;
}

- (void)finished {

    if ([self.backViewController class] == [LocationDetailViewController class]) {
        [self.navigationController popToViewController:self.backViewController animated:true];
    } else {
        [self popToViewControllerClass:[LocationViewController class] animated:true];
    }
}

- (void)setupRating {

    self.rating.starImage = [UIImage imageNamed:@"star"];
    self.rating.starHighlightedImage = [UIImage imageNamed:@"starSelected"];
    self.rating.maxRating = 5.0;
    self.rating.delegate = self;
    self.rating.horizontalMargin = 12;
    self.rating.editable = YES;
    self.rating.displayMode = EDStarRatingDisplayFull;

    if ([self.backViewController class] == [LocationDetailViewController class]) {
        self.rating.rating = 1;
    }
}

- (void)setupReview {
    self.review.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.review.layer.borderWidth = 0.5;
    self.review.layer.cornerRadius = 5;
    self.review.ClipsToBounds = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
}

@end
