//
// Created by Privat on 19/01/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UITableViewCell (Extension)

- (void)displayTipViewFor:(UIView *)view withHintKey:(NSString *)hintKey withDelegate:(id <CMPopTipViewDelegate> )delegate;

@end