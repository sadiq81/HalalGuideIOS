//
// Created by Privat on 09/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HGErrorReporting : NSObject
+ (HGErrorReporting *)instance;

- (void)reportError:(NSError *)error;

@end