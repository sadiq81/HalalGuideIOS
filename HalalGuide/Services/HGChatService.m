//
// Created by Privat on 26/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "HGChatService.h"
#import "HGSubject.h"
#import "HGMessage.h"
#import "HGQuery.h"
#import "HGUser.h"

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

- (void)getSubjectsWithCompletion:(PFArrayResultBlock)completion {

    HGQuery *query = [HGQuery queryWithClassName:kSubjectTableName];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [PFObject pinAllInBackground:objects];
        }
        completion(objects, error);
    }];
}

- (void)getMessagesForSubject:(HGSubject *)subject withCompletion:(void (^)(NSArray *, NSError *))completion {

    HGQuery *query = [HGQuery queryWithClassName:kMessageTableName];
    [query orderByAscending:@"createdAt"];
    [query whereKey:@"subjectId" equalTo:subject.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [PFObject pinAllInBackground:objects];
        }
        completion(objects, error);
    }];
}

//TODO Offline handling
- (void)sendMessage:(NSString *)text forSubject:(HGSubject *)subject withCompletion:(void (^)(HGMessage *message, BOOL succeeded, NSError *error))completion {
    HGMessage *message = [HGMessage object];
    message.userId = [HGUser currentUser].objectId;
    message.text = text;
    message.subjectId = subject.objectId;

    [message pinInBackground];

    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        completion(message, succeeded, error);
    }];
}

- (void)sendImage:(UIImage *)image forSubject:(HGSubject *)subject withCompletion:(void (^)(HGMessage *message, BOOL succeeded, NSError *error))completion {
    HGMessage *message = [HGMessage object];
    message.userId = [HGUser currentUser].objectId;
    message.subjectId = subject.objectId;
    message.image = [PFFile fileWithName:subject.objectId data:UIImagePNGRepresentation(image)];
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