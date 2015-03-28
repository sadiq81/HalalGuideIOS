//
// Created by Privat on 12/01/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CTAssetsPickerController.h"
#import "SVProgressHUD.h"

typedef enum HintPosition : int16_t {
    HintPositionAbove = 0,
    HintPositionRight = 1,
    HintPositionBelow = 3,
    HintPositionLeft = 4
} HintPosition;

@interface UIViewController (Extension) <UIImagePickerControllerDelegate, CTAssetsPickerControllerDelegate>

@property(nonatomic, strong) NSArray *images;
@property(readonly) UIViewController *backViewController;

- (NSString *)percentageString:(float)progress;

- (void)finishedPickingImages;

- (void)popToViewControllerClass:(Class)aClass animated:(BOOL)animated;

- (void)hintWasDismissedByUser:(NSString *)hintKey;

- (void)displayHintForView:(UIView *)viewWithHint withHintKey:(NSString *)hintKey preferedPositionOfText:(HintPosition)position;

@end