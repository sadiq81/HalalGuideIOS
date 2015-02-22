//
// Created by Privat on 06/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Location.h"


@interface HalalGuideLabel : UILabel

- (instancetype)initWithFrame:(CGRect)frame andFontSize:(CGFloat)size;

- (void)configureViewForLocation:(Location *)location;

@end

@interface PorkLabel : HalalGuideLabel
@end

@interface AlcoholLabel : HalalGuideLabel
@end

@interface HalalLabel : HalalGuideLabel
@end

@interface OpenLabel : HalalGuideLabel
@end

