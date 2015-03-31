//
// Created by Privat on 15/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "HGPictureService.h"
#import "Location.h"
#import "LocationPicture.h"
#import "UIImage+Transformation.h"
#import "ProfileInfo.h"
#import "FBSession.h"
#import "HGErrorReporting.h"
#import "FBAccessTokenData.h"
#import "FBRequest.h"
#import "PFUser+Extension.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation HGPictureService {

}

+ (HGPictureService *)instance {
    static HGPictureService *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (void)saveMultiplePictures:(NSArray *)images forLocation:(Location *)location completion:(void (^)(BOOL completed, NSError *error, NSNumber *progress))completion {

    NSError *uploadError;
    __block int counter = 0;

    for (int i = 0; i < [images count]; i++) {
        UIImage *image = [images objectAtIndex:i];
        LocationPicture *picture = [self prepareImageForUpload:image forLocation:location];

        @weakify(uploadError)
        [picture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            @strongify(uploadError)

            if ((uploadError = error) || uploadError) {
                completion(true, error, @(100));
            } else {
                counter++;
                int progress = ceil((100 / [images count]) * counter);
                completion(progress == 100, uploadError, @(progress));
            }
        }];
    }

}

- (LocationPicture *)prepareImageForUpload:(UIImage *)image forLocation:(Location *)location {

    UIImage *compressed = [image compressForUpload];
    LocationPicture *picture = [LocationPicture object];
    picture.creationStatus = @(CreationStatusAwaitingApproval);
    picture.locationId = location.objectId;
    picture.submitterId = [PFUser currentUser].objectId;

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