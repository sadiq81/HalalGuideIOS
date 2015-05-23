//
// Created by Privat on 26/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "HGSubjectsViewModel.h"
#import "HGErrorReporting.h"
#import "HGChatService.h"

@interface HGSubjectsViewModel ()

@property(nonatomic, strong) NSArray *subjects;
@property(nonatomic, strong) HGSubject *subject;

@end

@implementation HGSubjectsViewModel {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.subjects = [NSArray new];
    }

    return self;
}


- (void)refreshSubjects {

    self.fetchCount++;
    [[HGChatService instance] getSubjectsWithCompletion:^(NSArray *objects, NSError *error) {

        self.fetchCount--;

        if ((self.error = error)) {
            [[HGErrorReporting instance] reportError:error];
        } else {
            self.subjects = objects;
        }
    }];
}

- (void)createSubject:(NSString *)subjectTitle {
    HGSubject *subject = [HGSubject object];
    subject.lastMessage = [NSDate dateWithTimeIntervalSinceNow:0];
    subject.title = subjectTitle;
    subject.count = @0;
    subject.userId = [PFUser currentUser].objectId;

    [[HGChatService instance] saveSubject:(HGSubject *) subject withCompletion:^(BOOL success, NSError *error) {
        if ((self.error = error)) {
            [[HGErrorReporting instance] reportError:error];
        } else {
            self.subject = subject;
            [[HGChatService instance] toggleSubscription:self.subject];
        }

    }];
}
@end