//
// Created by Privat on 12/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGSmiley : NSObject

@property(nonatomic, strong) NSString *report;
@property(nonatomic, strong) NSString *smiley;
@property(nonatomic, strong) NSString *date;

- (instancetype)initWithReport:(NSString *)report smiley:(NSString *)smiley date:(NSString *)date;

+ (instancetype)smileyWithReport:(NSString *)report smiley:(NSString *)smiley date:(NSString *)date;

@end