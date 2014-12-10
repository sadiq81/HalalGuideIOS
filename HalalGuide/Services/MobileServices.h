//
// Created by Privat on 12/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

@interface MobileServices : NSObject

@property (strong, nonatomic) MSClient *client;

+ (MobileServices *)instance;

@end