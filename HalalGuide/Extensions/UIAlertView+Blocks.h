//
// Created by Privat on 23/05/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIAlertView (Blocks)
+ (UIAlertView *)withTitle:(NSString *)title
                   message:(NSString *)message
                   buttons:(NSArray *)buttons
             buttonHandler:(void (^)(NSUInteger))handler;
@end