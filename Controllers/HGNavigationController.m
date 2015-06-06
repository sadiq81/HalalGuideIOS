//
// Created by Privat on 22/05/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "HGNavigationController.h"
#import "HGMessagesViewController.h"
#import <Parse/Parse.h>
#import "ReactiveCocoa.h"
#import "BFTask.h"
#import "TSMessage.h"
#import "HGQuery.h"


@implementation HGNavigationController {

}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self setup];
    }

    return self;
}

- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleChatNotification:) name:kChatNotificationConstant object:nil];
}

- (void)handleChatNotification:(NSNotification *)notification {

    UIViewController *currentViewController = self.viewControllers.lastObject;
    NSString *subjectId = (NSString *) notification.object;
    NSString *text = [[notification.userInfo valueForKey:@"aps"] valueForKey:@"alert"];

    UIApplicationState state = (UIApplicationState) ((NSNumber *) [notification.userInfo valueForKey:@"UIApplicationState"]).intValue;

    @weakify(self)
    [[[PFQuery queryWithClassName:kSubjectTableName] getObjectInBackgroundWithId:subjectId] continueWithBlock:^id(BFTask *task) {
        @strongify(self)
        HGSubject *subject = task.result;

        void (^completion)(void) = ^void(void) {
            dispatch_async(dispatch_get_main_queue(), ^{
                HGMessagesViewModel *model = [[HGMessagesViewModel alloc] initWithSubject:subject];
                HGMessagesViewController *messagesViewController = [HGMessagesViewController controllerWithViewModel:model];
                [self pushViewController:messagesViewController animated:true];
            });
        };

        void (^showChatNotification)(void) = ^void(void) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [TSMessage showNotificationInViewController:self
                                                      title:NSLocalizedString(@"HGNavigationController.new.message", nil)
                                                   subtitle:text
                                                      image:nil
                                                       type:TSMessageNotificationTypeMessage
                                                   duration:TSMessageNotificationDurationAutomatic
                                                   callback:^{
                                                       completion();
                                                   }
                                                buttonTitle:nil
                                             buttonCallback:nil
                                                 atPosition:TSMessageNotificationPositionTop
                                       canBeDismissedByUser:YES];
            });
        };

        if (![currentViewController isKindOfClass:[HGMessagesViewController class]]) {
            // Add a button inside the message
            if (state == UIApplicationStateActive) {
                showChatNotification();
            } else {
                completion();
            }
        } else {
            HGMessagesViewModel *viewModel = ((HGMessagesViewController *) currentViewController).viewModel;
            if (![subjectId isEqualToString:viewModel.subject.objectId]) {

                if (state == UIApplicationStateActive) {
                    showChatNotification();
                } else {
                    completion();
                }

            } else {
                [viewModel refreshSubjects];
            }
        }
        return task;
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end