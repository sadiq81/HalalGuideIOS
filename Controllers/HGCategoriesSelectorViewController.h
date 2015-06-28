//
// Created by Privat on 29/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GoogleAnalytics/GAITrackedViewController.h>
#import "HGBaseViewModel.h"


@interface HGCategoriesSelectorViewController : GAITrackedViewController {

}
- (instancetype)initWithViewModel:(id <CategoriesViewModel>)viewModel;

+ (instancetype)controllerWithViewModel:(id <CategoriesViewModel>)viewModel;


@end