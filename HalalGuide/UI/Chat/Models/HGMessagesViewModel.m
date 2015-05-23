//
// Created by Privat on 28/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "HGMessagesViewModel.h"
#import "HGChatService.h"
#import "HGErrorReporting.h"
#import "HGSubject.h"
#import "HGMessageViewModel.h"
#import "ReactiveCocoa.h"

@interface HGMessagesViewModel ()

@property(nonatomic, retain) NSMutableArray *messages;
@property(nonatomic, retain) HGMessage *sentMessage;
@property(nonatomic, retain) HGSubject *subject;
@property(nonatomic, retain) NSNumber *subscribing;

@property(nonatomic, retain) NSMutableArray *receivedMessages;
@property(nonatomic, retain) NSTimer *updatingTimer;

@end

//TODO never gets de-allocated, memory leak somewhere!!!!!
@implementation HGMessagesViewModel {

}

- (instancetype)initWithSubject:(HGSubject *)subject {
    self = [super init];
    if (self) {
        _messages = [NSMutableArray new];
        _subject = subject;
        _subscribing = [[HGChatService instance] subscribingToSubject:subject];


    }

    return self;
}

- (HGMessageViewModel *)viewModelForMessage:(NSUInteger)index {
    return [HGMessageViewModel modelWithMessage:self.messages[index]];
}

- (void)handleChatNotification:(NSNotification *)notification {

    NSString *subjectId = (NSString *) notification.object;
    if ([subjectId isEqualToString:self.subject.objectId]) {
        [self refreshSubjects];
    }
}

- (void)refreshSubjects {

    //TODO Optimize to only fetch messages after last message
    self.fetchCount++;
    @weakify(self)
    [[HGChatService instance] getMessagesForSubject:self.subject withCompletion:^(NSArray *objects, NSError *error) {
        @strongify(self)
        self.fetchCount--;

        if ((self.error = error)) {
            [[HGErrorReporting instance] reportError:error];
        } else {
            NSMutableArray *new = [[NSMutableArray alloc] init];
            for (HGMessage *message in objects) {
                if (![self.messages containsObject:message]) {
                    [new addObject:message];
                }
            }
            [self.messages addObjectsFromArray:new];
            self.receivedMessages = new;

        }
    }];
}

- (void)sendMessage:(NSString *)text {

    if ([self.subscribing isEqualToNumber:@0]) {
        [[HGChatService instance] toggleSubscription:self.subject];
        self.subscribing = @1;
    }

    @weakify(self)
    [[HGChatService instance] sendMessage:text forSubject:self.subject withCompletion:^(HGMessage *message, BOOL succeeded, NSError *error) {
        @strongify(self)
        if ((self.error = error)) {
            [[HGErrorReporting instance] reportError:error];
        } else {
            [self.messages addObject:message];
            self.sentMessage = message;
        }
    }];
}

- (void)toggleSubscription {
    [[HGChatService instance] toggleSubscription:self.subject];
    self.subscribing = [[HGChatService instance] subscribingToSubject:self.subject];
}

- (void)startTimer {
    if (![[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
        _updatingTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(refreshSubjects) userInfo:nil repeats:YES];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleChatNotification:) name:kChatNotificationConstant object:nil];
    }
}

- (void)stopTimer {
    [self.updatingTimer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end