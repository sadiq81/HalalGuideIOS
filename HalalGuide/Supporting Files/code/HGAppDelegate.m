//
//  HGAppDelegate.m
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//


#import "HGAppDelegate.h"
#import "HGLocation.h"
#import "HGLocationService.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "MZFormSheetBackgroundWindow.h"
#import "IQKeyboardManager.h"
#import "HGKeyChainService.h"
#import "HGErrorReporting.h"
#import "HGPictureService.h"
#import "UIAlertController+Blocks.h"
#import "IQUIWindow+Hierarchy.h"
#import "HGLocationPicture.h"
#import "RACTuple.h"
#import "HGFrontPageViewController.h"
#import "HGAPHelper.h"
#import "ZLPromptUserReview.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "Constants.h"
#import "PFFacebookUtils.h"
#import "FBSDKAppEvents.h"
#import "FBSDKApplicationDelegate.h"
#import "HGFrontPageViewModel.h"
#import "HGSmileyScraper.h"

@interface HGAppDelegate ()

@property(strong, nonatomic) UINavigationController *navigationController;

@end

@implementation HGAppDelegate

@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //AFNetworking
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    //Location Services
    [HGLocationService instance];

    //Appearance
    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
    [[MZFormSheetBackgroundWindow appearance] setBlurRadius:5.0];
    [[MZFormSheetBackgroundWindow appearance] setBackgroundColor:[UIColor clearColor]];

    [[UIView appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTranslucent:false];

    //IQKeyboard
    [IQKeyboardManager sharedManager].toolbarManageBehaviour = IQAutoToolbarByTag;

    //Configure Parse
    [Parse enableLocalDatastore]; //TODO
    [Parse setApplicationId:kParseApplicationId clientKey:kParseClientKey];
#if !DEBUG
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
#endif
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
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
    [HGAPHelper sharedInstance];

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

    //Defaults
    NSString *defaultPrefsFile = [[NSBundle mainBundle] pathForResource:@"dk.eazyit.halalguide.preferences" ofType:@"plist"];
    NSDictionary *defaultPreferences = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPreferences];

    //Setup view controller
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    HGFrontPageViewController *viewController = [HGFrontPageViewController controllerWithViewModel:[[HGFrontPageViewModel alloc] init]];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
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
    [FBSDKAppEvents activateApp];

    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveInBackground];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

#pragma mark URL handling

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}


@end
