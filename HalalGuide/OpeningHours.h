//
// Created by Privat on 02/01/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OpeningHours : NSObject
@property(nonatomic) NSArray *days;

@end

typedef enum WeekDay : int16_t {
    WeekDayMonday = 0,
    WeekDayTuesday = 1,
    WeekDayWednesday = 2,
    WeekDayThursday = 3,
    WeekDayFriday = 4,
    WeekDaySaturday = 5,
    WeekDaySunday = 6
} WeekDay;

@interface Day : NSObject
@property(nonatomic) WeekDay weekDay;
@property(nonatomic) NSDate *opening;
@property(nonatomic) NSDate *closing;
@end