//
// Created by Privat on 26/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGBaseEntity.h"

#define kMessageTableName @"Message"

@interface HGMessage : HGBaseEntity<PFSubclassing>

@property (nonatomic, strong) NSString *subjectId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) PFFile *image;
@property (nonatomic, strong) PFFile *video;

@end