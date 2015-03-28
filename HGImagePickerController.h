//
// Created by Privat on 13/03/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"

@interface HGImagePickerController : UIViewController

@property(strong, nonatomic, readonly) BaseViewModel *viewModel;

- (instancetype)initWithViewModel:(BaseViewModel *)viewModel;

+ (instancetype)controllerWithViewModel:(BaseViewModel *)viewModel;


@end