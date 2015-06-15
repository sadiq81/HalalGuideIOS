//
// Created by Privat on 29/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GoogleAnalytics/GAITrackedViewController.h>
#import "HGLocationViewModel.h"


@interface HGCategoriesFilterViewController : GAITrackedViewController {

}

- (instancetype)initWithLocationType:(LocationType)locationType;

+ (instancetype)controllerWithLocationType:(LocationType)locationType;

@end