//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Location.h"
#import <ParseUI/ParseUI.h>

@interface LocationTableViewCell : UITableViewCell

-(void) configure:(Location*)location;

-(NSString *)placeholderImageName;

@end