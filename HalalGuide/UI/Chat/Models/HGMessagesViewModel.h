//
// Created by Privat on 28/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGBaseViewModel.h"
#import "HGSubject.h"
#import "HGMessageViewModel.h"


@interface HGMessagesViewModel : HGBaseViewModel

- (instancetype)initWithSubject:(HGSubject *)subject;

@property (nonatomic, strong, readonly) NSArray *messages;

-(HGMessageViewModel *)viewModelForMessage:(NSUInteger) index;

- (void)refreshSubjects;


@end