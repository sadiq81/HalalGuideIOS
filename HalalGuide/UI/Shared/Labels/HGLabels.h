//
// Created by Privat on 06/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Location.h"


@interface HGLabel : UILabel

- (instancetype)initWithFrame:(CGRect)frame andFontSize:(CGFloat)size;

- (void)configureViewForLocation:(Location *)location;

@end

@interface PorkLabel : HGLabel
@end

@interface AlcoholLabel : HGLabel
@end

@interface HalalLabel : HGLabel
@end

@interface OpenLabel : HGLabel
@end

