//
// Created by Privat on 13/03/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGBaseViewModel.h"

@interface HGImagePickerController : UIViewController

@property(strong, nonatomic, readonly) HGBaseViewModel *viewModel;

- (instancetype)initWithViewModel:(HGBaseViewModel *)viewModel;

+ (instancetype)controllerWithViewModel:(HGBaseViewModel *)viewModel;


@end