//
// Created by Privat on 27/01/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAGradientLayer+SJSGradients.h"


@implementation CAGradientLayer (SJSGradients)

+ (CAGradientLayer *)redGradientLayer {
    return nil;
}

+ (CAGradientLayer *)blueGradientLayer {
    UIColor *topColor = [UIColor colorWithRed:(120 / 255.0) green:(135 / 255.0) blue:(150 / 255.0) alpha:1.0];
    UIColor *bottomColor = [UIColor colorWithRed:(57 / 255.0) green:(79 / 255.0) blue:(96 / 255.0) alpha:1.0];

    NSArray *gradientColors = [NSArray arrayWithObjects:(id) topColor.CGColor, (id) bottomColor.CGColor, nil];
    NSArray *gradientLocations = [NSArray arrayWithObjects:[NSNumber numberWithInt:0.0], [NSNumber numberWithInt:1.0], nil];

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = gradientColors;
    gradientLayer.locations = gradientLocations;

    return gradientLayer;
}

+ (CAGradientLayer *)turquoiseGradientLayer {
    return nil;
}

+ (CAGradientLayer *)flavescentGradientLayer {

    UIColor *topColor = [UIColor colorWithRed:1 green:0.92 blue:0.56 alpha:1];
    UIColor *bottomColor = [UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1];

    NSArray *gradientColors = [NSArray arrayWithObjects:(id) topColor.CGColor, (id) bottomColor.CGColor, nil];
    NSArray *gradientLocations = [NSArray arrayWithObjects:[NSNumber numberWithInt:0.0], [NSNumber numberWithInt:1.0], nil];

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = gradientColors;
    gradientLayer.locations = gradientLocations;

    return gradientLayer;
}

+ (CAGradientLayer *)whiteGradientLayer {
    return nil;
}

+ (CAGradientLayer *)chocolateGradientLayer {
    return nil;
}

+ (CAGradientLayer *)tangerineGradientLayer {
    return nil;
}

+ (CAGradientLayer *)pastelBlueGradientLayer {
    return nil;
}

+ (CAGradientLayer *)yellowGradientLayer {
    return nil;
}

+ (CAGradientLayer *)purpleGradientLayer {
    return nil;
}

+ (CAGradientLayer *)greenGradientLayer {

    UIColor *topColor = [UIColor colorWithRed:(53 / 255.0) green:(179 / 255.0) blue:(95 / 255.0) alpha:1.0];
    UIColor *bottomColor = [UIColor colorWithRed:(20 / 255.0) green:(230 / 255.0) blue:(90 / 255.0) alpha:1.0];

    NSArray *gradientColors = [NSArray arrayWithObjects:(id) topColor.CGColor, (id) bottomColor.CGColor, nil];
    NSArray *gradientLocations = [NSArray arrayWithObjects:[NSNumber numberWithInt:0.0], [NSNumber numberWithInt:1.0], nil];

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = gradientColors;
    gradientLayer.locations = gradientLocations;

    return gradientLayer;
}

+ (CAGradientLayer*) greyGradient {

    UIColor *colorOne = [UIColor colorWithWhite:0.9 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.85 alpha:1.0];
    UIColor *colorThree     = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.7 alpha:1.0];
    UIColor *colorFour = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.4 alpha:1.0];

    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, colorFour.CGColor, nil];

    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.02];
    NSNumber *stopThree     = [NSNumber numberWithFloat:0.99];
    NSNumber *stopFour = [NSNumber numberWithFloat:1.0];

    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, stopFour, nil];
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;

    return headerLayer;

}


@end