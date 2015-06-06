//
// Created by Privat on 11/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "HGDateLabel.h"
#import "ReactiveCocoa/ReactiveCocoa.h"

@interface HGDateLabel ()
@property(strong, nonatomic) NSString *formatString;
@end

@implementation HGDateLabel {

}

@synthesize formatString, date;

- (instancetype)initWithFormat:(NSString *)format {
    self = [super init];
    if (self) {
        self.formatString = format;
        [self setupRC];
    }

    return self;
}

+ (instancetype)labelWithFormat:(NSString *)format {
    return [[self alloc] initWithFormat:format];
}

- (void)setupRC {
    [[RACObserve(self, date) deliverOnMainThread] subscribeNext:^(NSDate *value) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:self.formatString];
        self.text = [formatter stringFromDate:value];
    }];
}

@end