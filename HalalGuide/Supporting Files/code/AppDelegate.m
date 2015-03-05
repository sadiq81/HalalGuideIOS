//
//  AppDelegate.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//


#import "AppDelegate.h"
#import "Location.h"
#import "LocationService.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "MZFormSheetBackgroundWindow.h"
#import "IQKeyboardManager.h"
#import "KeyChainService.h"
#import "ErrorReporting.h"
#import "PictureService.h"
#import "UIAlertController+Blocks.h"
#import "IQUIWindow+Hierarchy.h"
#import "LocationPicture.h"
#import "RACTuple.h"
#import "FrontPageViewController.h"
#import "HalalGuideIAPHelper.h"
#import "ZLPromptUserReview.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "Constants.h"

@interface AppDelegate ()

@property(strong, nonatomic) UINavigationController *navigationController;

@end

/*



*/

@implementation AppDelegate

@synthesize locationManager, navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //AFNetworking
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    //Location Services
    [self startStandardUpdates];

    //Appearance
    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
    [[MZFormSheetBackgroundWindow appearance] setBlurRadius:5.0];
    [[MZFormSheetBackgroundWindow appearance] setBackgroundColor:[UIColor clearColor]];

    //IQKeyboard
    [IQKeyboardManager sharedManager].toolbarManageBehaviour = IQAutoToolbarByTag;

    //Configure Parse
    //[Parse enableLocalDatastore]; //TODO
    [Parse setApplicationId:kParseApplicationId clientKey:kParseClientKey];
#if !DEBUG
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
#endif
    [PFFacebookUtils initializeFacebook];
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [defaultACL setWriteAccess:true forRoleWithName:@"admin"];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:true];

#if !DEBUG
    //Push notifications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];

    if (application.applicationState != UIApplicationStateBackground) {
        // Track an app open here if we launch with a push, unless
        // "content_available" was used to trigger a background push (introduced
        // in iOS 7). In that case, we skip tracking here to avoid double
        // counting the app-open.
        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        }
    }
#endif

    //In-App Purchases
    [HalalGuideIAPHelper sharedInstance];

    //App Store review
    [[ZLPromptUserReview sharedInstance] setAppID:kZLPromptUserReviewAppId];
    [[ZLPromptUserReview sharedInstance] setNumberOfDaysToWaitBeforeRemindingUser:15];
    [[ZLPromptUserReview sharedInstance] setTitle:NSLocalizedString(@"ZLPromptUserReview.title", nil)];
    [[ZLPromptUserReview sharedInstance] setMessage:NSLocalizedString(@"ZLPromptUserReview.message", nil)];
    [[ZLPromptUserReview sharedInstance] setConfirmButtonText:NSLocalizedString(@"ZLPromptUserReview.confirm", nil)];
    [[ZLPromptUserReview sharedInstance] setCancelButtonText:NSLocalizedString(@"ZLPromptUserReview.cancel", nil)];
    [[ZLPromptUserReview sharedInstance] setRemindButtonText:NSLocalizedString(@"ZLPromptUserReview.remind", nil)];

    //Crashlytics
#if !DEBUG
    [Fabric with:@[CrashlyticsKit]];
#endif

    //Setup view controller
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    self.window.backgroundColor = [UIColor whiteColor];
    FrontPageViewController *viewController = [FrontPageViewController controllerWithViewModel:[[FrontPageViewModel alloc] init]];
    UINavigationController *nav = [[UINavigationController alloc]  initWithRootViewController:viewController];
    nav.navigationBar.translucent = NO;
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[@"global"];
    [currentInstallation saveInBackground];

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];

    if (application.applicationState == UIApplicationStateInactive) {
        // The application was just brought from the background to the foreground,
        // so we consider the app as having been "opened by a push notification."
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}

- (void)startStandardUpdates {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = 500;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation *currentLocation = [locations lastObject];
    NSDate *eventDate = currentLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"locationManager:didUpdateLocations" object:self userInfo:@{@"lastObject" : currentLocation}];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];

    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveInBackground];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark URL handling

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
}



@end
