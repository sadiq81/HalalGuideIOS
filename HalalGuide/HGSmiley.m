//
// Created by Privat on 12/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "HGSmiley.h"


@implementation HGSmiley {

}


@synthesize report, smiley, date;

- (instancetype)initWithReport:(NSString *)aReport smiley:(NSString *)aSmiley date:(NSString *)aDate {
    self = [super init];
    if (self) {
        self.report = aReport;
        self.smiley = aSmiley;
        self.date = aDate;
    }

    return self;
}

+ (instancetype)smileyWithReport:(NSString *)report smiley:(NSString *)smiley date:(NSString *)date {
    return [[self alloc] initWithReport:report smiley:smiley date:date];
}


@end