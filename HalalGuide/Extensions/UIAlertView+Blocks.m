//
// Created by Privat on 23/05/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <objc/runtime.h>
#import "UIAlertView+Blocks.h"


@implementation UIAlertView (Blocks)

static const char *HANDLER_KEY = "com.mattrajca.alertview.handler";

+ (UIAlertView *)withTitle:(NSString *)title
                   message:(NSString *)message
                   buttons:(NSArray *)buttons
             buttonHandler:(void (^)(NSUInteger))handler {

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil];

    [alert setDelegate:alert];

    [buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [alert addButtonWithTitle:obj];
    }];

    if (handler) {
        objc_setAssociatedObject(alert, HANDLER_KEY, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return alert;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    id handler = objc_getAssociatedObject(alertView, HANDLER_KEY);
    if (handler) {
        ((void (^)()) handler)(buttonIndex);
    }

}

@end