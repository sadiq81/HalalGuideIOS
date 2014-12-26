//
// Created by Privat on 23/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <CMPopTipView/CMPopTipView.h>
#import "UIBarButtonItem+Extension.h"
#import "HalalGuideOnboarding.h"


@implementation UIBarButtonItem (Extension)

- (CMPopTipView *)showOnBoardingWithHintKey:(NSString *)hintKey withDelegate:(id <CMPopTipViewDelegate>)delegate {

    [[HalalGuideOnboarding instance] setOnBoardingShown:hintKey];

    CMPopTipView *tipView = [[CMPopTipView alloc] initWithMessage:NSLocalizedString(hintKey, nil)];
    tipView.backgroundColor = [UIColor whiteColor];
    tipView.textColor = [UIColor darkTextColor];
    tipView.delegate = delegate;
    [tipView presentPointingAtBarButtonItem:self animated:YES];
    return tipView;
}

@end