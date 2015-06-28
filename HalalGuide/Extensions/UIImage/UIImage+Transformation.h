//
// Created by Privat on 12/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (Transformation)

- (UIImage *)compressForUpload;

- (UIImage *)compressImage;

- (UIImage *)scaleDown:(UIImage *)img withSize:(CGSize)newSize;

- (UIImage *)crop:(CGRect)rect;

- (UIImage *)cropCircular:(CGRect)rect;

@end