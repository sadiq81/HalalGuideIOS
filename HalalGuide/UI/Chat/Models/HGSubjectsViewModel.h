//
// Created by Privat on 26/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGBaseViewModel.h"
#import "HGSubject.h"


@interface HGSubjectsViewModel : HGBaseViewModel

@property(nonatomic, strong, readonly) NSArray *subjects;
@property(nonatomic, strong, readonly) HGSubject *subject;

- (void)refreshSubjects;

- (void)createSubject:(NSString *) subjectTitle;
@end