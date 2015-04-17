//
// Created by Privat on 17/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum {
    UIViewSidesLeft = 1 << 0,
    UIViewSidesTop = 1 << 1,
    UIViewSidesRight = 1 << 2,
    UIViewSidesBottom = 1 << 3

};
typedef NSUInteger UIViewSides;

@interface UIView (HGBorders)

- (void)addBorderWithHeight:(CGFloat)width andColor:(UIColor *)color onSides:(NSUInteger)sides;

@end