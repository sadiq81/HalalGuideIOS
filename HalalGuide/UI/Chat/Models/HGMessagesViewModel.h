//
// Created by Privat on 28/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGBaseViewModel.h"
#import "HGSubject.h"
#import "HGMessageViewModel.h"

typedef void (^UpdateMessagesHandler)(void);

@interface HGMessagesViewModel : HGBaseViewModel

- (instancetype)initWithSubject:(HGSubject *)subject;

@property(nonatomic, strong, readonly) NSMutableArray *messages;
@property(nonatomic, strong, readonly) HGMessage *sentMessage;
@property(nonatomic, strong, readonly) HGSubject *subject;
@property(nonatomic, strong, readonly) NSNumber *subscribing;

@property(nonatomic, strong, readonly) HGMessage *receivedMessage;

- (HGMessageViewModel *)viewModelForMessage:(NSUInteger)index;

- (void)refreshSubjects;

- (void)sendMessage:(NSString *)text;

- (void)toggleSubscription;
@end