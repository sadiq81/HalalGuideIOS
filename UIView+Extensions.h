//
// Created by Privat on 12/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CMPopTipView.h"

@interface UIView (Extensions)

-(void)resizeToFitSubviews;

- (CMPopTipView *)showOnBoardingWithHintKey:(NSString *)hintKey withDelegate:(id <CMPopTipViewDelegate>)delegate superView:(UIView *)superView;

- (CMPopTipView *)showOnBoardingWithHintKey:(NSString *)hintKey withDelegate:(id <CMPopTipViewDelegate>)delegate;

-(UITableView *) parentTableView;

@end