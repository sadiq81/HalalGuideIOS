//
// Created by Privat on 30/01/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "UIImage+Combine.h"


@implementation UIImage (Combine)

- (UIImage *)drawImage:(UIImage *)image InRect:(CGRect)rect {

    UIGraphicsBeginImageContextWithOptions(self.size, false,0);

    // Use existing opacity as is
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    // Apply supplied opacity if applicable
    [image drawInRect:rect blendMode:kCGBlendModeNormal alpha:0.8];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return newImage;
}

@end