//
// Created by Privat on 24/02/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HGBaseEntity.h"

typedef void (^ButtonViewTapHandler)(void);

@interface HGButtonView : UIView

- (instancetype)initWithButtonImageName:(NSString *)name andLabelText:(NSString *)labelText andTapHandler:(ButtonViewTapHandler )tapHandler;

@end