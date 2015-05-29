//
// Created by Privat on 26/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "HGChatService.h"
#import "HGSubject.h"
#import "HGMessage.h"

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
//TODO Offline handling
- (void)saveSubject:(HGSubject *)subject withCompletion:(PFBooleanResultBlock)completion {
    [subject saveInBackgroundWithBlock:completion];
}

//TODO Offline handling
- (void)getSubjectsWithCompletion:(PFArrayResultBlock)completion {

/*    PFQuery *local = [PFQuery queryWithClassName:kSubjectTableName];
    [local fromLocalDatastore];
    [local orderByAscending:@"createdAt"];
    [local findObjectsInBackgroundWithBlock:completion];*/

    PFQuery *query = [PFQuery queryWithClassName:kSubjectTableName];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
//            [PFObject pinAllInBackground:objects];
        }
        completion(objects, error);
    }];


}

//TODO Offline handling
- (void)getMessagesForSubject:(HGSubject *)subject withCompletion:(void (^)(NSArray *, NSError *))completion {

/*    PFQuery *local = [PFQuery queryWithClassName:kMessageTableName];
    [local fromLocalDatastore];
    [local orderByAscending:@"createdAt"];
    [local whereKey:@"subjectId" equalTo:subject.objectId];
    [local findObjectsInBackgroundWithBlock:completion];*/

    PFQuery *query = [PFQuery queryWithClassName:kMessageTableName];
    [query orderByAscending:@"createdAt"];
    [query whereKey:@"subjectId" equalTo:subject.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
//            [PFObject pinAllInBackground:objects];
        }
        completion(objects, error);
    }];
}

//TODO Offline handling
- (void)sendMessage:(NSString *)text forSubject:(HGSubject *)subject withCompletion:(void (^)(HGMessage *message, BOOL succeeded, NSError *error))completion {
    HGMessage *message = [HGMessage object];
    message.userId = [PFUser currentUser].objectId;
    message.text = text;
    message.subjectId = subject.objectId;

    [message pinInBackground];

    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completion(message, succeeded, error);
    }];
}

- (NSString *)keyForSubscription:(HGSubject *)subject {
    return [NSString stringWithFormat:@"%@-%@", @"subject", subject.objectId];
}

- (NSNumber *)subscribingToSubject:(HGSubject *)subject {
    NSArray *channels = [PFInstallation currentInstallation].channels;
    NSString *key = [self keyForSubscription:subject];
    return @([channels containsObject:key]);
}

- (void)toggleSubscription:(HGSubject *)subject {
    PFInstallation *current = [PFInstallation currentInstallation];
    NSArray *channels = current.channels;
    NSString *key = [self keyForSubscription:subject];

    if ([channels containsObject:key]) {
        [current removeObject:key forKey:@"channels"];
    } else {
        [current addUniqueObject:key forKey:@"channels"];
    }
    [current saveEventually];
}
@end