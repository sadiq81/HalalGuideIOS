//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"


@interface DiningDetailViewModel : BaseViewModel

@property(nonatomic, retain) Location *location;

+ (DiningDetailViewModel *)instance;

-(void) report:(UIViewController *)viewController;

@end