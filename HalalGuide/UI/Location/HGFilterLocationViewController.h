//
//  HGFilterLocationViewController.h
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HGLocationViewModel;

@interface HGFilterLocationViewController : UIViewController<UINavigationBarDelegate>

@property (strong, nonatomic, readonly) HGLocationViewModel *viewModel;

- (instancetype)initWithViewModel:(HGLocationViewModel *)model;

+ (instancetype)controllerWithViewModel:(HGLocationViewModel *)viewModel;

@end
