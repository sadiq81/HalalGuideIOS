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
    UIApplication *application = [UIApplication sharedApplication];
    NSString *subjectId = (NSString *) notification.object;

    if (application.applicationState == UIApplicationStateActive) {

        if (![currentViewController isKindOfClass:[HGMessagesViewController class]]) {
            // Add a button inside the message
            [TSMessage showNotificationInViewController:currentViewController
                                                  title:@"Update available"
                                               subtitle:@"Please update the app"
                                                  image:nil
                                                   type:TSMessageNotificationTypeMessage
                                               duration:TSMessageNotificationDurationAutomatic
                                               callback:^{
                                                   NSLog(@"User tapped the button");
                                               }
                                            buttonTitle:nil
                                         buttonCallback:nil
                                             atPosition:TSMessageNotificationPositionTop
                                   canBeDismissedByUser:YES];

        }

    } else if (application.applicationState == UIApplicationStateInactive) {

        if ([currentViewController isKindOfClass:[HGMessagesViewController class]]) {
            HGMessagesViewModel *viewModel = ((HGMessagesViewController *) currentViewController).viewModel;
            if ([subjectId isEqualToString:viewModel.subject.objectId]) {
                [viewModel refreshSubjects];
            }
        } else {
            [[[PFQuery queryWithClassName:kSubjectTableName] getObjectInBackgroundWithId:subjectId] continueWithBlock:^id(BFTask *task) {
                HGSubject *subject = task.result;
                HGMessagesViewModel *model = [[HGMessagesViewModel alloc] initWithSubject:subject];
                HGMessagesViewController *messagesViewController = [HGMessagesViewController controllerWithViewModel:model];
                [self pushViewController:messagesViewController animated:true];
                return task;
            }];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end