//
//  BaseViewModel.h
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Location.h"
#import "NSArray+LinqExtensions.h"
#import "Common.h"
#import <ParseUI/ParseUI.h>

typedef void (^WaitCompletionBlock)();

static WaitCompletionBlock waitFor = ^void(NSTimeInterval duration, WaitCompletionBlock completion) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC),
            dispatch_get_main_queue(), ^{
                completion();
            });
};

@protocol CategoriesViewModel <NSObject>

@property(nonatomic, retain) NSMutableArray *categories;
@property(nonatomic, retain) NSMutableArray *shopCategories;
@property(nonatomic) Language language;

@end

@interface BaseViewModel : NSObject <PFLogInViewControllerDelegate> {
}
@property(nonatomic) UIImagePickerController *imagePickerController;

+ (CLLocation *)currentLocation;

- (void)locationChanged:(NSNotification *)notification;

- (NSArray *)calculateDistances:(NSArray *)locations sortByDistance:(BOOL)sort;

- (BOOL)isAuthenticated;

- (void)authenticate:(UIViewController *)viewController;

- (void)getPicture:(UIViewController<UINavigationControllerDelegate> *)viewController ;

- (void)savePicture:(UIImage *)image forLocation:(Location *)location ;

- (void)saveMultiplePictures:(NSArray *)images forLocation:(Location *)location;


@end
