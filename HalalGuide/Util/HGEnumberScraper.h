//
// Created by Privat on 16/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGLocation.h"


@interface HGENumberScraper : NSObject

+ (void)eNumbersOnCompletion:(void (^)(NSArray *numbers))completion;

@end