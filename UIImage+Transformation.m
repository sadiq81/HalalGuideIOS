//
// Created by Privat on 12/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "UIImage+Transformation.h"


@implementation UIImage (Transformation)

- (UIImage *)compressForUpload {

    float actualHeight = self.size.height;
    float actualWidth = self.size.width;
    float imgRatio = actualWidth / actualHeight;
    bool portrait = actualHeight > actualWidth;
    float maxHeight = portrait ? 2048.0 : 1536;
    float maxWidth = portrait ? 1536.0 : 2048;
    float maxRatio = maxHeight / maxWidth;

    if (imgRatio != maxRatio) {
        if (imgRatio < maxRatio) {
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else {
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);

    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];

    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return img;
}
@end