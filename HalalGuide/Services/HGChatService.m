//
// Created by Privat on 26/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "HGChatService.h"
#import "HGSubject.h"

@implementation HGChatService {

}
+ (HGChatService *)instance {
    static HGChatService *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (void)getSubjectsWithCompletion:(PFArrayResultBlock)completion {

    PFQuery *query = [PFQuery queryWithClassName:kSubjectTableName];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:completion];

}
@end