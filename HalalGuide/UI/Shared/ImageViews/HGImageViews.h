//
// Created by Privat on 06/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Location.h"

@interface HGImageViews : UIImageView
- (void)configureViewForLocation:(Location *)location;
@end

@interface PorkImageView : HGImageViews
@end

@interface AlcoholImageView : HGImageViews
@end

@interface HalalImageView : HGImageViews
@end