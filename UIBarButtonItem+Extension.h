//
// Created by Privat on 23/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

- (CMPopTipView *)showOnBoardingWithHintKey:(NSString *)hintKey withDelegate:(id<CMPopTipViewDelegate>) delegate;

@end