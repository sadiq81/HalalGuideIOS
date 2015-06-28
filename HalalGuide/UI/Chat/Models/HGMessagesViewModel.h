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

@property(nonatomic, retain, readonly) NSMutableArray *messages;
@property(nonatomic, retain, readonly) HGMessage *sentMessage;
@property(nonatomic, retain, readonly) HGSubject *subject;
@property(nonatomic, retain, readonly) NSNumber *subscribing;

@property(nonatomic, retain, readonly) NSMutableArray  *receivedMessages;

- (HGMessageViewModel *)viewModelForMessage:(NSUInteger)index;

- (void)refreshSubjects;

- (void)sendMessage:(NSString *)text;

- (void)sendImage:(UIImage*)image;

- (void)toggleSubscription;

- (void)startTimer;

- (void)stopTimer;
@end