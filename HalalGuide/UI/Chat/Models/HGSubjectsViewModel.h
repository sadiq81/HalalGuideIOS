//
// Created by Privat on 26/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGBaseViewModel.h"


@interface HGSubjectsViewModel : HGBaseViewModel

@property (nonatomic, strong, readonly) NSArray *subjects;

- (void)refreshSubjects;

@end