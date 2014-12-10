//
// Created by Privat on 15/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
#import "Location.h"
#import "HalalGuideSettings.h"

@class LocationPicture;

@interface PictureService : NSObject

+ (PictureService *)instance;

- (void)savePicture:(UIImage*)image forLocation:(Location *)location onCompletion:(PFBooleanResultBlock)completion;

- (void)locationPicturesByQuery:(PFQuery *)query onCompletion:(PFArrayResultBlock)completion ;

- (void)thumbnailForLocation:(Location*)location onCompletion:(PFArrayResultBlock)completion ;

@end