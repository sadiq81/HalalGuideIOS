//
// Created by Privat on 12/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <CMPopTipView/CMPopTipView.h>
#import "UIView+Extensions.h"
#import "HalalGuideOnboarding.h"


@implementation UIView (Extensions)

- (void)resizeToFitSubviews {
    float w = 0;
    float h = 0;

    for (UIView *v in [self subviews]) {
        float fw = v.frame.origin.x + v.frame.size.width;
        float fh = v.frame.origin.y + v.frame.size.height;
        w = MAX(fw, w);
        h = MAX(fh, h);
    }
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, w, h)];
}

- (CMPopTipView *)showOnBoardingWithHintKey:(NSString *)hintKey withDelegate:(id <CMPopTipViewDelegate>)delegate {

    [[HalalGuideOnboarding instance] setOnBoardingShown:hintKey];

    CMPopTipView *tipView = [[CMPopTipView alloc] initWithMessage:NSLocalizedString(hintKey, nil)];
    tipView.backgroundColor = [UIColor whiteColor];
    tipView.textColor = [UIColor darkTextColor];
    [tipView presentPointingAtView:self inView:self.superview animated:true];
    return tipView;

}

-(UITableView *) parentTableView {
    // iterate up the view hierarchy to find the table containing this cell/view
    UIView *aView = self.superview;
    while(aView != nil) {
        if([aView isKindOfClass:[UITableView class]]) {
            return (UITableView *)aView;
        }
        aView = aView.superview;
    }
    return nil; // this view is not within a tableView
}

@end