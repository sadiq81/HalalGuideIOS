//
// Created by Privat on 19/01/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <CMPopTipView/CMPopTipView.h>
#import "UITableViewCell+Extension.h"
#import "HalalGuideOnboarding.h"


@implementation UITableViewCell (Extension)

- (void)displayTipViewFor:(UIView *)view withHintKey:(NSString *)hintKey withDelegate:(id <CMPopTipViewDelegate> )delegate {

    CMPopTipView *tipView = [[CMPopTipView alloc] initWithMessage:NSLocalizedString(hintKey, nil)];
    tipView.delegate = delegate;
    tipView.backgroundColor = [UIColor whiteColor];
    tipView.textColor = [UIColor darkTextColor];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = window.rootViewController.view;
    [tipView presentPointingAtView:view inView:topView animated:true];
    [[HalalGuideOnboarding instance] setOnBoardingShown:hintKey];
}

@end