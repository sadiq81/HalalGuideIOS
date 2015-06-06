//
// Created by Privat on 12/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGSmiley : NSObject

@property(nonatomic, copy) NSString *report;
@property(nonatomic, copy) NSString *smiley;
@property(nonatomic, copy) NSString *date;

- (instancetype)initWithReport:(NSString *)aReport smiley:(NSString *)aSmiley date:(NSString *)aDate;

+ (instancetype)smileyWithReport:(NSString *)report smiley:(NSString *)smiley date:(NSString *)date;

@end