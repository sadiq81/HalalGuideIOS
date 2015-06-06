//
// Created by Privat on 12/01/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import "CTAssetsPickerController.h"
#import "SVProgressHUD.h"
#import "HGImagePickerController.h"
#import "UIImage+Transformation.h"
#import "HGOnboarding.h"
#import "UILabel+Extensions.h"
#import "HGLogInViewController.h"
#import <Parse/Parse.h>
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "HGImagePickerController.h"
#import "HGSubject.h"
#import <Crashlytics/Crashlytics.h>
#import <objc/runtime.h>
#import <ALActionBlocks/UIGestureRecognizer+ALActionBlocks.h>

typedef enum HintPosition : int16_t {
    HintPositionAbove = 0,
    HintPositionRight = 1,
    HintPositionBelow = 3,
    HintPositionLeft = 4
} HintPosition;

@interface UIViewController (Extension)<PFLogInViewControllerDelegate>

- (NSString *)percentageString:(float)progress;

- (void)createReviewForLocation:(HGLocation *)location viewModel:(HGBaseViewModel *)viewModel pushToStack:(BOOL)push;

- (void)getPicturesWithDelegate:(id <HGImagePickerControllerDelegate>)delegate viewModel:(HGBaseViewModel *)viewModel;

- (void)authenticate:(void (^)(void))loginHandler;

- (void)hintWasDismissedByUser:(NSString *)hintKey;

- (void)displayHintForView:(UIView *)viewWithHint withHintKey:(NSString *)hintKey preferedPositionOfText:(HintPosition)position;

//- (void) handleChatNotification:(NSNotification *) notification;

@end