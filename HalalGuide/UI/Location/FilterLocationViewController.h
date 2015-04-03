//
//  FilterLocationViewController.h
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LocationViewModel;

@interface FilterLocationViewController : UIViewController<UINavigationBarDelegate>

@property (strong, nonatomic, readonly) LocationViewModel *viewModel;

- (instancetype)initWithViewModel:(LocationViewModel *)model;

+ (instancetype)controllerWithViewModel:(LocationViewModel *)viewModel;

@end
