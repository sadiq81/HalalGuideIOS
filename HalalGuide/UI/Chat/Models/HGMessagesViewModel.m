//
// Created by Privat on 28/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "HGMessagesViewModel.h"
#import "HGChatService.h"
#import "HGErrorReporting.h"
#import "HGSubject.h"

@interface HGMessagesViewModel()

@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) HGSubject *subject ;

@end

@implementation HGMessagesViewModel {

}

- (instancetype)initWithSubject:(HGSubject *)subject {
    self = [super init];
    if (self) {
        self.messages = [NSArray new];
        self.subject = subject;
    }

    return self;
}


- (void)refreshSubjects {

    self.fetchCount++;
    [[HGChatService instance] getMessagesForSubject:self.subject withCompletion:^(NSArray *objects, NSError *error) {

        self.fetchCount--;

        if ((self.error = error)) {
            [[HGErrorReporting instance] reportError:error];
        } else {
            self.messages = objects;
        }
    }];
}
@end