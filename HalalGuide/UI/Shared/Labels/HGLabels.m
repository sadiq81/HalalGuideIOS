//
// Created by Privat on 06/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "HGLabels.h"


@implementation HGLabel

- (instancetype)initWithFrame:(CGRect)frame andFontSize:(CGFloat)size {
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:size];
    }
    return self;
}
@end

@implementation OpenLabel

- (void)configureViewForLocation:(Location *)location {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *now = [[NSDate alloc] init];
    NSDateComponents *components = [cal components:NSCalendarUnitWeekday fromDate:now];
    NSInteger weekday = [components weekday]; // 1 = Sunday, 2 = Monday, etc.
    NSDictionary *openClose = [location openCloseForWeekDay:(weekday + 5) % 7];

    if (openClose) {
        NSDate *openTime = [openClose objectForKey:@"open"];
        NSDate *closeTime = [openClose objectForKey:@"close"];
        //set date components
        NSDateComponents *dateComponents = [cal components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:now];
        [dateComponents setDay:1];
        [dateComponents setMonth:1];
        [dateComponents setYear:2000];
        //save date relative from date
        NSDate *nowIn2000 = [cal dateFromComponents:dateComponents];
        BOOL open = [openTime compare:nowIn2000] == NSOrderedAscending && [nowIn2000 compare:closeTime] == NSOrderedAscending;
        NSMutableAttributedString *openString = [[NSMutableAttributedString alloc] initWithString:open ? NSLocalizedString(@"open", nil) : NSLocalizedString(@"closed", nil)];
        [openString addAttribute:NSForegroundColorAttributeName value:open ? [UIColor greenColor] : [UIColor redColor] range:NSMakeRange(0, [openString.mutableString length])];
        self.attributedText = openString;
    } else {
        self.text = @"";
    }

}
@end


