//
//  CreateReviewViewController.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIBarButtonItem+ALActionBlocks.h>
#import "CreateReviewViewController.h"
#import "LocationViewController.h"
#import "Review.h"

@interface CreateReviewViewController ()

@end

@implementation CreateReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupViewModel];
    [self setupEvents];
    [self setupRating];
    [self setupReview];

}

- (void)setupViewModel {

    [RACObserve(self.viewModel, saving) subscribeNext:^(NSNumber *saving) {
        if (saving.boolValue) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"savingToTheCloud", nil) maskType:SVProgressHUDMaskTypeBlack];
        } else {
            [SVProgressHUD dismiss];
        }
    }];

    [[RACObserve(self.viewModel, error) throttle:0.5] subscribeNext:^(NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"error", nil)];
        }
    }];
}

- (void)setupEvents {

    @weakify(self)
    [self.regret setBlock:^(id weakSender) {
        @strongify(self)
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }];

    RACSignal *review = [RACSignal merge:@[[self.review rac_textSignal], RACObserve(self.review, text),]];
    RACSignal *rating = RACObserve(self.rating, rating);
    RAC(self.save, enabled) = [RACSignal combineLatest:@[review, rating]
                                                reduce:^(NSString *reviewText, NSNumber *rating) {
                                                    return @([reviewText length] > 30 && rating > 0);
                                                }];

    [[RACObserve(self.viewModel, createdReview) skip:1] subscribeNext:^(Review *review) {
        if (!self.viewModel.error && review.objectId) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"reviewSaved", nil)];
        }
    }];

    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:SVProgressHUDDidDisappearNotification object:nil] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(NSNotification *notification) {
        NSString *hudText = [[notification userInfo] valueForKey:SVProgressHUDStatusUserInfoKey];
        if ([hudText isEqualToString:NSLocalizedString(@"reviewSaved", nil)]) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }];

    [self.save setBlock:^(id weakSender) {
        @strongify(self)
        [self.viewModel saveEntity:self.review.text rating:self.rating.rating];
    }];

}

- (void)setupRating {

    self.rating.starImage = [UIImage imageNamed:@"star"];
    self.rating.starHighlightedImage = [UIImage imageNamed:@"starSelected"];
    self.rating.maxRating = 5.0;
    self.rating.delegate = self;
    self.rating.horizontalMargin = 12;
    self.rating.editable = YES;
    self.rating.rating = 1;
    self.rating.displayMode = EDStarRatingDisplayFull;

}

- (void)setupReview {
    self.review.placeholder = NSLocalizedString(@"reviewMinimum", nil);

    self.review.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.review.layer.borderWidth = 0.5;
    self.review.layer.cornerRadius = 5;
    self.review.ClipsToBounds = true;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
}

@end
