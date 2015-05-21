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

@property(nonatomic, strong) NSMutableArray *messages;
@property(nonatomic, strong) HGMessage *sentMessage;
@property(nonatomic, strong) HGSubject *subject;
@property(nonatomic, strong) NSNumber *subscribing;

@property(nonatomic, strong) HGMessage *receivedMessage;
@property(strong, nonatomic) NSTimer *updatingTimer;

@end

@implementation HGMessagesViewModel {

}

- (instancetype)initWithSubject:(HGSubject *)subject {
    self = [super init];
    if (self) {
        self.messages = [NSMutableArray new];
        self.subject = subject;
        self.subscribing = [[HGChatService instance] subscribingToSubject:subject];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleChatNotification:) name:kChatNotificationConstant object:nil];

        if (![[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
            self.updatingTimer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(handleChatNotification:) userInfo:nil repeats:YES];
        }
    }

    return self;
}

- (HGMessageViewModel *)viewModelForMessage:(NSUInteger)index {
    return [HGMessageViewModel modelWithMessage:self.messages[index]];
}

- (void)handleChatNotification:(NSNotification *)notification {

    @weakify(self)
    UpdateMessagesHandler handler = ^void(void) {
        @strongify(self)
        [[HGChatService instance] getMessagesForSubject:self.subject withCompletion:^(NSArray *objects, NSError *error) {
            if ((self.error = error)) {
                [[HGErrorReporting instance] reportError:error];
            } else {
                for (HGMessage *message in objects) {
                    if (![self.messages containsObject:message]) {
                        [self.messages addObject:message];
                        self.receivedMessage = message;
                    }
                }
            }
        }];
    };

    if (notification == nil) {
        handler();
    } else {
        //TODO Optimize to only fetch messages after last message
        NSString *subjectId = (NSString *) notification.object;
        if ([subjectId isEqualToString:self.subject.objectId]){
            handler();
        }
    }
}

- (void)refreshSubjects {

    self.fetchCount++;
    [[HGChatService instance] getMessagesForSubject:self.subject withCompletion:^(NSArray *objects, NSError *error) {

        self.fetchCount--;

        if ((self.error = error)) {
            [[HGErrorReporting instance] reportError:error];
        } else {
            self.messages = [[NSMutableArray alloc] initWithArray:objects];
        }
    }];
}

- (void)sendMessage:(NSString *)text {

    [[HGChatService instance] sendMessage:text forSubject:self.subject withCompletion:^(HGMessage *message, BOOL succeeded, NSError *error) {

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


- (void)dealloc {
    [self.updatingTimer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end