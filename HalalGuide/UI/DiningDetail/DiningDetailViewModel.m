//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "DiningDetailViewModel.h"

@import MessageUI;

@implementation DiningDetailViewModel {

}

+ (DiningDetailViewModel *)instance {

    static DiningDetailViewModel *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[super alloc] init];
        }
    }

    return _instance;
}

- (void)report:(UIViewController<MFMailComposeViewControllerDelegate> *)viewController {

    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    [mailController setToRecipients:@[@"tommy@eazyit.dk"]];
    [mailController setSubject:[NSString stringWithFormat:@"%@",self.location.objectId]];
    [mailController setMessageBody:@"Der er følgende forkerte oplysninger: \nUDDYB HER!" isHTML:false];
    mailController.mailComposeDelegate = viewController;
    [viewController presentViewController:mailController animated:true completion:nil];

}

- (void)locationChanged:(NSNotification *)notification {
                        //TODO reload distance
}

@end