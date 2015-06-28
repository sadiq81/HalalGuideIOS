//
// Created by Privat on 17/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "UIView+HGBorders.h"


@implementation UIView (HGBorders)

- (void)addBorderWithHeight:(CGFloat)width andColor:(UIColor *)color onSides:(NSUInteger)sides {

    if (sides & UIViewSidesLeft) {
        [self addOneSidedBorderWithFrame:CGRectMake(0, 0, width, self.frame.size.height) andColor:color];
    }
    if (sides & UIViewSidesTop) {
        [self addOneSidedBorderWithFrame:CGRectMake(0, 0, self.frame.size.width, width) andColor:color];
    }
    if (sides & UIViewSidesRight) {
        [self addOneSidedBorderWithFrame:CGRectMake(self.frame.size.width-width, 0, width, self.frame.size.height) andColor:color];
    }
    if (sides & UIViewSidesBottom) {
        [self addOneSidedBorderWithFrame:CGRectMake(0, self.frame.size.height-width, self.frame.size.width, width) andColor:color];
    }

}

- (void)addOneSidedBorderWithFrame:(CGRect)frame andColor:(UIColor *)color {
    CALayer *border = [CALayer layer];
    border.frame = frame;
    [border setBackgroundColor:color.CGColor];
    [self.layer addSublayer:border];
}


@end