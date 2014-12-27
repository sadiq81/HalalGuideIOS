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
#import "UIKit/UIImagePickerController.h"
#import "Common.h"

typedef void (^PickImageBlockType)(id <UIImagePickerControllerDelegate>, UIViewController *, UIImagePickerControllerSourceType);

static PickImageBlockType pickImageBlock = ^void(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate> delegate, UIViewController *viewController, UIImagePickerControllerSourceType sourceType) {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = delegate;

    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        imagePickerController.showsCameraControls = true;
    }
    [viewController presentViewController:imagePickerController animated:YES completion:nil];
};

typedef void (^WaitCompletionBlock)();

static WaitCompletionBlock waitFor  = ^void (NSTimeInterval duration, WaitCompletionBlock completion) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC),
            dispatch_get_main_queue(), ^{
                completion();
            });
};

@protocol CategoriesViewModel <NSObject>

@property(nonatomic, retain) NSMutableArray *categories;
@property(nonatomic) Language language;

@end

@interface BaseViewModel : NSObject {
}
@property(nonatomic) UIImagePickerController *imagePickerController;

+ (CLLocation *)currentLocation;

- (void)locationChanged:(NSNotification *)notification;

- (NSArray *)calculateDistances:(NSArray *)locations sortByDistance:(BOOL)sort;

- (BOOL)isAuthenticated;

- (void)authenticate:(UIViewController *)viewController onCompletion:(PFBooleanResultBlock)completion;

- (void)getPicture:(UIViewController *)viewController withDelegate:(id <UIImagePickerControllerDelegate>)delegate;


@end
