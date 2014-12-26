//
// Created by Privat on 06/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "HalalGuideLabels.h"


@implementation HalalGuideLabels
- (void)configureViewForLocation:(Location *)location {
}
@end

@implementation PorkLabel
- (void)configureViewForLocation:(Location *)location {
    NSMutableAttributedString *porkString = [[NSMutableAttributedString alloc] initWithString:[location.pork boolValue] ? NSLocalizedString(@"yes", nil) : NSLocalizedString(@"no", nil)];
    [porkString addAttribute:NSForegroundColorAttributeName value:[location.pork boolValue] ? [UIColor redColor] : [UIColor greenColor] range:NSMakeRange(0, [porkString.mutableString length])];
    self.attributedText = porkString;
}
@end

@implementation AlcoholLabel
- (void)configureViewForLocation:(Location *)location {
    NSMutableAttributedString *alcoholString = [[NSMutableAttributedString alloc] initWithString:[location.alcohol boolValue] ? NSLocalizedString(@"yes", nil) : NSLocalizedString(@"no", nil)];
    [alcoholString addAttribute:NSForegroundColorAttributeName value:[location.alcohol boolValue] ? [UIColor redColor] : [UIColor greenColor] range:NSMakeRange(0, [alcoholString.mutableString length])];
    self.attributedText = alcoholString;
}
@end

@implementation HalalLabel
- (void)configureViewForLocation:(Location *)location {
    NSMutableAttributedString *halalString = [[NSMutableAttributedString alloc] initWithString:[location.nonHalal boolValue] ? NSLocalizedString(@"no", nil) : NSLocalizedString(@"yes", nil)];
    [halalString addAttribute:NSForegroundColorAttributeName value:[location.nonHalal boolValue] ? [UIColor redColor] : [UIColor greenColor] range:NSMakeRange(0, [halalString.mutableString length])];
    self.attributedText = halalString;
}
@end

