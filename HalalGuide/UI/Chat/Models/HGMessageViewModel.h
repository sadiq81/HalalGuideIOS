//
// Created by Privat on 30/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGBaseViewModel.h"
#import "HGMessage.h"


@interface HGMessageViewModel : HGBaseViewModel

@property(nonatomic, strong, readonly) NSURL *image;
@property(nonatomic, strong, readonly) NSURL *avatar;
@property(nonatomic, strong, readonly) NSString *submitter;
@property(nonatomic, strong, readonly) NSString *text;

@property(nonatomic, strong, readonly) HGMessage *message;

- (instancetype)initWithMessage:(HGMessage *)message;

+ (instancetype)modelWithMessage:(HGMessage *)message;


@end