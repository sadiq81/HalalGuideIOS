//
//  HGAppDelegate.h
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "HGCommon.h"
#import <Parse/Parse.h>

typedef void (^NotificationHandler)(NSString *message);

@interface HGAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) UINavigationController *navigationController;

@end

