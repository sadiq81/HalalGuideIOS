//
// Created by Privat on 18/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "HGDateFormatter.h"


@implementation HGDateFormatter {

}

+ (NSString *)shortDateFormat:(NSDate *)date {
    NSDateFormatter *shortDateFormat = [[NSDateFormatter alloc] init];
    [shortDateFormat setDateFormat:@"dd-MM-yyyy"];
    return [shortDateFormat stringFromDate:date];
}

+ (NSString *)shortTimeFormat:(NSDate *)date {
    NSDateFormatter *shortTimeFormat = [[NSDateFormatter alloc] init];
    [shortTimeFormat setDateFormat:@"HH:mm"];
    return [shortTimeFormat stringFromDate:date];
}

@end