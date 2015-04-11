//
// Created by Privat on 21/01/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HGCreateLocationViewModel.h"

@interface HGOpeningsHoursViewController : UIViewController {
}

@property(strong, nonatomic, readonly) HGCreateLocationViewModel *viewModel;

- (instancetype)initWithViewModel:(HGCreateLocationViewModel *)model;

+ (instancetype)controllerWithViewModel:(HGCreateLocationViewModel *)model;


@end