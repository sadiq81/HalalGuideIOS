//
// Created by Privat on 26/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "HGSubjectsViewModel.h"
#import "HGErrorReporting.h"
#import "HGChatService.h"

@interface HGSubjectsViewModel ()

@property (nonatomic, strong) NSArray *subjects;

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
@end