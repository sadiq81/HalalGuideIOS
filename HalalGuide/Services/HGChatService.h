//
// Created by Privat on 26/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "HGSubject.h"
#import "HGMessage.h"

@interface HGChatService : NSObject

+ (HGChatService *)instance;

- (void)saveSubject:(HGSubject *)subject withCompletion:(PFBooleanResultBlock)completion;

- (void)getSubjectsWithCompletion:(PFArrayResultBlock)completion;

- (void)getMessagesForSubject:(HGSubject *)subject withCompletion:(void (^)(NSArray *, NSError *))completion;

- (void)sendMessage:(NSString *)text forSubject:(HGSubject *)subject withCompletion:(void (^)(HGMessage *message, BOOL succeeded, NSError *error))completion;

- (void)sendImage:(UIImage *)image forSubject:(HGSubject *)subject withCompletion:(void (^)(HGMessage *message, BOOL succeeded, NSError *error))completion;

- (NSNumber *)subscribingToSubject:(HGSubject *)subject;

- (void)toggleSubscription:(HGSubject *)subject;
@end