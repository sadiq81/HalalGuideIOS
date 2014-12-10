//
// Created by Privat on 06/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Location.h"

@interface HalalGuideImageViews : UIImageView
- (void)configureViewForLocation:(Location *)location;
@end

@interface PorkImageView : HalalGuideImageViews
@end

@interface AlcoholImageView : HalalGuideImageViews
@end

@interface HalalImageView : HalalGuideImageViews
@end