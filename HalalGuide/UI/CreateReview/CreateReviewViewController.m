//
//  CreateReviewViewController.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ALActionBlocks/UIBarButtonItem+ALActionBlocks.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "CreateReviewViewController.h"
#import "EDStarRating.h"
#import "DiningViewController.h"
#import "DiningDetailViewController.h"
#import "CreateReviewViewModel.h"

@interface CreateReviewViewController ()

@end

@implementation CreateReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupRating];
    [self setupReview];

    __weak typeof(self) weakSelf = self;
    [self.regret setBlock:^(id weakSender) {
        [weakSelf finished];
    }];

    [self.save setBlock:^(id weakSender) {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"savingToTheCloud", nil) maskType:SVProgressHUDMaskTypeGradient];

        [[CreateReviewViewModel instance] saveEntity:weakSelf.review.text rating:(int) weakSelf.rating.rating onCompletion:^(CreateEntityResult result) {

            dispatch_async(dispatch_get_main_queue(), ^{

                [SVProgressHUD dismiss];
                if (result != CreateEntityResultOk) {
                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(CreateEntityResultString(result), nil) maskType:SVProgressHUDMaskTypeGradient];
                    return;
                } else {

                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"reviewSaved", nil)];
                    [weakSelf finished];
                }
            });
        }];
    }];

}

-(void) finished{

    //TODO Bad design
    NSArray *controllers = self.navigationController.viewControllers;
    for (int i = (int ) [controllers count] - 1; i >= 0; i--) {
        UIViewController *controller = [controllers objectAtIndex:i];
        if ([controller class] == [DiningViewController class]) {
            [self.navigationController popToViewController:controller animated:true];
            return;
        } else if ([controller class] == [DiningDetailViewController class]) {
            [self.navigationController popToViewController:controller animated:true];
            return;
        }
    }
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (void)setupRating {

    self.rating.starImage = [UIImage imageNamed:@"star"];
    self.rating.starHighlightedImage = [UIImage imageNamed:@"starSelected"];
    self.rating.maxRating = 5.0;
    self.rating.delegate = self;
    self.rating.horizontalMargin = 12;
    self.rating.editable = YES;
    self.rating.displayMode = EDStarRatingDisplayFull;

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
