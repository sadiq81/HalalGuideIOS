//
// Created by Privat on 11/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface HGDateLabel : UILabel


@property(strong, nonatomic) NSDate *date;

- (instancetype)initWithFormat:(NSString *)format;

+ (instancetype)labelWithFormat:(NSString *)format;


@end