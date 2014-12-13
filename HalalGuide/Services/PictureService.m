//
// Created by Privat on 15/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "PictureService.h"
#import "Location.h"
#import "LocationPicture.h"
#import "UIImage+Transformation.h"


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

- (void)savePicture:(UIImage *)image forLocation:(Location *)location onCompletion:(PFBooleanResultBlock)completion {

    //Parse can only store files of 10 mb
    image = [image compressForUpload];

    LocationPicture *picture = [LocationPicture object];
    picture.creationStatus = @(CreationStatusAwaitingApproval);
    picture.locationId = location.objectId;
    picture.submitterId = [PFUser currentUser].objectId;
    picture.width = image.size.width;
    picture.height = image.size.height;

    //TODO Move to category
    NSMutableString *asciiCharacters = [NSMutableString string];
    for (NSInteger i = 32; i < 127; i++) {
        if (i == 32 || (i >= 48 && i <= 57) || (i >= 65 && i <= 90) || (i >= 97 && i <= 122)) {
            [asciiCharacters appendFormat:@"%c", i];
        }
    }
    NSCharacterSet *nonAsciiCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:asciiCharacters] invertedSet];
    NSString *allowedLocationName = [[location.name componentsSeparatedByCharactersInSet:nonAsciiCharacterSet] componentsJoinedByString:@""];

    NSString *fileName = [NSString stringWithFormat:@"%@.png", allowedLocationName];

    picture.picture = [PFFile fileWithName:fileName data:UIImagePNGRepresentation(image)];
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