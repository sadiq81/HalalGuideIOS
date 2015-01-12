//
// Created by Privat on 12/01/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CTAssetsPickerController.h"

@interface UIViewController (Extension) <UIImagePickerControllerDelegate, CTAssetsPickerControllerDelegate>

@property(nonatomic, strong) NSArray *images;

- (void)finishedPickingImages;

@end