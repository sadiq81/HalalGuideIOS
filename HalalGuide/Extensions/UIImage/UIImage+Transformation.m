//
// Created by Privat on 12/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#define kMaxUploadSize 1024.0f * 1024.0f * 2.0f
#define kMinUploadResolution 1136.0f * 640.0f

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

- (UIImage *)compressImage {

    UIImage *img;
    //Resize the image
    float factor;
    float resol = self.size.height * self.size.width;

    if (resol > kMinUploadResolution) {
        factor = sqrt(resol / kMinUploadResolution) * 2;
        img = [self scaleDown:img withSize:CGSizeMake(img.size.width / factor, img.size.height / factor)];
    }

    //Compress the image
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;

    NSData *imageData = UIImageJPEGRepresentation(img, compression);

    while ([imageData length] > kMaxUploadSize && compression > maxCompression) {
        compression -= 0.10;
        imageData = UIImageJPEGRepresentation(img, compression);
        NSLog(@"Compress : %lu", (unsigned long) imageData.length);
    }
    return img;
}

- (UIImage *)scaleDown:(UIImage *)img withSize:(CGSize)newSize {

    UIGraphicsBeginImageContextWithOptions(newSize, YES, 0.0);
    [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return scaledImage;
}

- (UIImage *)crop:(CGRect)rect {

    if (self.scale > 1.0f) {
        rect = CGRectMake(rect.origin.x * self.scale,
                rect.origin.y * self.scale,
                rect.size.width * self.scale,
                rect.size.height * self.scale);
    }

    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

- (UIImage *)cropCircular:(CGRect)rect {

    float a = rect.size.width / 2;
    float b = rect.size.height / 2;
    float c = sqrtf(powf(a, 2) + powf(b, 2));
    rect = CGRectInset(rect, -(c - a), -(c - b));

    if (self.scale > 1.0f) {
        rect = CGRectMake(rect.origin.x * self.scale,
                rect.origin.y * self.scale,
                rect.size.width * self.scale,
                rect.size.height * self.scale);

    }

    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}


@end