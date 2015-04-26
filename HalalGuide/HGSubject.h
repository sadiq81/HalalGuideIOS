//
// Created by Privat on 26/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGBaseEntity.h"

#define kSubjectTableName @"Subject"

@interface HGSubject : HGBaseEntity

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSDate *lastMessage;

@end