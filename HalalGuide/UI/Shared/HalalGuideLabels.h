//
// Created by Privat on 06/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Location.h"


@interface HalalGuideLabels : UILabel
- (void)configureViewForLocation:(Location *)location;
@end

@interface PorkLabel : HalalGuideLabels
@end

@interface AlcoholLabel : HalalGuideLabels
@end

@interface HalalLabel : HalalGuideLabels
@end