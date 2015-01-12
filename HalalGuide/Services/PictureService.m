//
// Created by Privat on 15/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "PictureService.h"
#import "Location.h"
#import "LocationPicture.h"
#import "UIImage+Transformation.h"
#import "ProfileInfo.h"
#import "FBSession.h"
#import "ErrorReporting.h"
#import "FBAccessTokenData.h"
#import "FBRequest.h"
#import "PFUser+Extension.h"


@implementation PictureService {

}

+ (PictureService *)instance {
    static PictureService *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (void)saveMultiplePictures:(NSArray *)images forLocation:(Location *)location onCompletion:(PFBooleanResultBlock)completion {

    NSMutableArray *pictures = [NSMutableArray new];
    for (UIImage *image in images) {
        LocationPicture *picture = [self prepareImageForUpload:image forLocation:location];
        [pictures addObject:picture];
    }

    [PFObject saveAllInBackground:pictures block:completion];
}

- (LocationPicture *)prepareImageForUpload:(UIImage *)image forLocation:(Location *)location {

    UIImage *compressed = [image compressForUpload];
    LocationPicture *picture = [LocationPicture object];
    picture.creationStatus = @(CreationStatusAwaitingApproval);
    picture.locationId = location.objectId;
    picture.submitterId = [PFUser currentUser].objectId;
    picture.width = image.size.width;
    picture.height = image.size.height;

    //TODO Move to category
    NSMutableString *asciiCharacters = [NSMutableString string];
    for (int i = 32; i < 127; i++) {
        if (i == 32 || (i >= 48 && i <= 57) || (i >= 65 && i <= 90) || (i >= 97 && i <= 122)) {
            [asciiCharacters appendFormat:@"%c", i];
        }
    }
    NSCharacterSet *nonAsciiCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:asciiCharacters] invertedSet];
    NSString *allowedLocationName = [[location.name componentsSeparatedByCharactersInSet:nonAsciiCharacterSet] componentsJoinedByString:@""];

    NSString *fileName = [NSString stringWithFormat:@"%@.png", allowedLocationName];

    picture.picture = [PFFile fileWithName:fileName data:UIImagePNGRepresentation(compressed)];

    return picture;
}

- (void)savePicture:(UIImage *)image forLocation:(Location *)location onCompletion:(PFBooleanResultBlock)completion {

    LocationPicture *picture = [self prepareImageForUpload:image forLocation:location];

    [picture saveInBackgroundWithBlock:completion];
}


- (void)locationPicturesByQuery:(PFQuery *)query onCompletion:(PFArrayResultBlock)completion {
    //query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query findObjectsInBackgroundWithBlock:completion];
}

- (void)locationPicturesForLocation:(Location *)location onCompletion:(PFArrayResultBlock)completion {
    PFQuery *query = [PFQuery queryWithClassName:kLocationPictureTableName];
    //query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query whereKey:@"creationStatus" equalTo:@(CreationStatusApproved)];
    [query whereKey:@"locationId" equalTo:location.objectId];
    [query findObjectsInBackgroundWithBlock:completion];
}

- (void)thumbnailForLocation:(Location *)location onCompletion:(PFArrayResultBlock)completion {
    PFQuery *query = [PFQuery queryWithClassName:kLocationPictureTableName];
    //query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query whereKey:@"creationStatus" equalTo:@(CreationStatusApproved)];
    [query whereKey:@"locationId" equalTo:location.objectId];
    query.limit = 1;
    [query findObjectsInBackgroundWithBlock:completion];
}
@end