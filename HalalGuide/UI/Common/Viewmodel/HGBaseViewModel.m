//
//  HGBaseViewModel.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import <Crashlytics/Crashlytics.h>

#import "HGBaseViewModel.h"
#import "HGLocationService.h"
#import "HGReviewService.h"
#import "HGPictureService.h"
#import "HGKeyChainService.h"
#import "HGErrorReporting.h"
#import "UIAlertController+Blocks.h"
#import "UIViewController+Extension.h"
#import "HGLogInViewController.h"
#import "HGAppDelegate.h"

@implementation HGBaseViewModel {
    UIViewController *presentingViewController;
}


@synthesize progress, fetchCount, error;

- (instancetype)init {
    self = [super init];
    if (self) {
        fetchCount = 0;
    }
    return self;
}

- (BOOL)isAuthenticated {
    return [[HGKeyChainService instance] isAuthenticated];
}



@end
