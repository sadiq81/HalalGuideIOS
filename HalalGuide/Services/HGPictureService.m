//
// Created by Privat on 15/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "HGPictureService.h"
#import "HGLocationPicture.h"
#import "UIImage+Transformation.h"
#import "HGReview.h"
#import "HGQuery.h"
#import "HGUser.h"
#import "Constants.h"
#import "NSString+Extensions.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <Bolts/BFTask.h>
#import <Parse/PFSubclassing.h>

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

//TODO Offline handling
- (void)saveMultiplePictures:(NSArray *)images forLocation:(HGLocation *)location completion:(void (^)(BOOL completed, NSError *error, NSNumber *progress))completion {

    NSError *uploadError;
    __block int counter = 0;

    for (int i = 0; i < [images count]; i++) {
        UIImage *image = [images objectAtIndex:i];
        HGLocationPicture *picture = [self prepareImageForUpload:image forLocation:location];

        @weakify(uploadError)
        [picture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            @strongify(uploadError)
            if ((uploadError = error) || uploadError) {
                completion(true, error, @(100));
            } else {
                counter++;
                int progress = ceil((100 / [images count]) * counter);
                if (progress == 99) progress = 100;
                completion(progress == 100, uploadError, @(progress));
            }
        }];
    }
}

- (NSURLSession *)urlSessionWithIdentifier:(NSString *)identifier {

    NSURLSessionConfiguration *backgroundConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier];
    backgroundConfiguration.networkServiceType = NSURLNetworkServiceTypeBackground;
    backgroundConfiguration.discretionary = true;

    NSURLSession *session = [NSURLSession sessionWithConfiguration:backgroundConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];

    return session;
}

- (void)saveMultiplePictures:(NSArray *)images forReview:(HGReview *)review {

    NSURLSession *session = [self urlSessionWithIdentifier:review.objectId];

    for (int i = 0; i < images.count; i++) {
        NSString *fileName = [[NSString alloc] initWithFormat:@"%@-%i.png", review.objectId, i];
        NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.parse.com/1/files/%@", fileName];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        [request setValue:kParseApplicationId forHTTPHeaderField:@"X-Parse-Application-Id"];
        [request setValue:kParseRestKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
        [request setValue:@"image/png" forHTTPHeaderField:@"Content-Type"];

        UIImage *image = images[0];
        image = [image compressForUpload];
        NSData *data = UIImagePNGRepresentation(image);

        NSString *tmpDirectory = [NSTemporaryDirectory() stringByAppendingPathComponent:review.objectId];
        NSString *tmpFile = [tmpDirectory stringByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] createDirectoryAtPath:tmpDirectory withIntermediateDirectories:YES attributes:nil error:nil];

        [data writeToFile:tmpFile atomically:true];

        NSURL *tmpFileURL = [NSURL fileURLWithPath:tmpFile];
        NSURLSessionUploadTask *task = [session uploadTaskWithRequest:request fromFile:tmpFileURL];

        [task resume];
    }

    [session finishTasksAndInvalidate];
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
    NSString *tmpDirectory = [NSTemporaryDirectory() stringByAppendingPathComponent:session.configuration.identifier];
    [[NSFileManager defaultManager] removeItemAtPath:tmpDirectory error:nil];
}

#define kAssociationSessionKey @"dk.eazyit.halalguide.association.session"

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {

    NSString *sessionId = session.configuration.identifier;
    if (![sessionId hasPrefix:kAssociationSessionKey]) {

        NSString *identifier = [NSString stringWithFormat:@"%@-%@", kAssociationSessionKey, sessionId];
        NSURLSession *associationSession = [self urlSessionWithIdentifier:identifier];

        NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.parse.com/1/classes/%@/%@", kLocationPictureTableName, sessionId];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:urlString]];
        [request setHTTPMethod:@"PUT"];
        [request setValue:kParseApplicationId forHTTPHeaderField:@"X-Parse-Application-Id"];
        [request setValue:kParseRestKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

        NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
        NSDictionary *httpResponse = [response allHeaderFields];
        NSString *url = [httpResponse valueForKey:@"Locatio"];

        NSDictionary *dic = @{@"picture" : @{@"name" : url, @"__type" : @"File"}};
    }

}

//TODO Offline handling
- (void)saveMultiplePictures:(NSArray *)images forReview:(HGReview *)review completion:(void (^)(BOOL completed, NSError *error, NSNumber *progress))completion {

    NSError *uploadError;
    __block int counter = 0;

    for (int i = 0; i < [images count]; i++) {
        UIImage *image = [images objectAtIndex:i];
        HGLocationPicture *picture = [self prepareImageForUpload:image forReview:review];

        @weakify(uploadError)
        [picture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            @strongify(uploadError)

            if ((uploadError = error) || uploadError) {
                completion(true, error, @(100));
            } else {
                counter++;
                int progress = ceil((100 / [images count]) * counter);
                if (progress == 99) progress = 100;
                completion(progress == 100, uploadError, @(progress));
            }
        }];
    }
}

- (HGLocationPicture *)prepareImageForUpload:(UIImage *)image forLocation:(HGLocation *)location {

    UIImage *compressed = [image compressForUpload];
    HGLocationPicture *picture = [HGLocationPicture object];
    picture.creationStatus = @(CreationStatusAwaitingApproval);
    picture.locationId = location.objectId;
    picture.submitterId = [HGUser currentUser].objectId;

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

- (HGLocationPicture *)prepareImageForUpload:(UIImage *)image forReview:(HGReview *)review {

    UIImage *compressed = [image compressForUpload];
    HGLocationPicture *picture = [HGLocationPicture object];
    picture.creationStatus = @(CreationStatusAwaitingApproval);
    picture.reviewId = review.objectId;
    picture.locationId = review.locationId;
    picture.submitterId = [HGUser currentUser].objectId;

    //TODO Move to category
    NSMutableString *asciiCharacters = [NSMutableString string];
    for (int i = 32; i < 127; i++) {
        if (i == 32 || (i >= 48 && i <= 57) || (i >= 65 && i <= 90) || (i >= 97 && i <= 122)) {
            [asciiCharacters appendFormat:@"%c", i];
        }
    }
    NSCharacterSet *nonAsciiCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:asciiCharacters] invertedSet];
    NSString *allowedLocationName = [[review.objectId componentsSeparatedByCharactersInSet:nonAsciiCharacterSet] componentsJoinedByString:@""];

    NSString *fileName = [NSString stringWithFormat:@"%@.png", allowedLocationName];

    picture.picture = [PFFile fileWithName:fileName data:UIImagePNGRepresentation(compressed)];

    return picture;
}


//- (void)locationPicturesByQuery:(PFQuery *)query onCompletion:(PFArrayResultBlock)completion {
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            [PFObject pinAllInBackground:objects];
//        }
//        completion(objects, error);
//    }];
//}

- (void)locationPicturesForLocation:(HGLocation *)location onCompletion:(PFArrayResultBlock)completion {

    HGQuery *query = [HGQuery queryWithClassName:kLocationPictureTableName];
    [query whereKey:@"creationStatus" equalTo:@(CreationStatusApproved)];
    [query whereKey:@"locationId" equalTo:location.objectId];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [PFObject pinAllInBackground:objects withName:@"locationPicturesForLocation"];
        }
        completion(objects, error);
    }];
}

- (void)locationPicturesForReview:(HGReview *)review onCompletion:(PFArrayResultBlock)completion {

    HGQuery *query = [HGQuery queryWithClassName:kLocationPictureTableName];
    [query whereKey:@"creationStatus" equalTo:@(CreationStatusApproved)];
    [query whereKey:@"locationId" equalTo:review.locationId];
    [query whereKey:@"reviewId" equalTo:review.objectId];
    query.limit = 4;

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [PFObject pinAllInBackground:objects withName:@"locationPicturesForReview"];
        }
        completion(objects, error);
    }];
}


- (void)thumbnailForLocation:(HGLocation *)location onCompletion:(PFArrayResultBlock)completion {

    HGQuery *query = [HGQuery queryWithClassName:kLocationPictureTableName];
    [query whereKey:@"creationStatus" equalTo:@(CreationStatusApproved)];
    [query whereKey:@"locationId" equalTo:location.objectId];
    query.limit = 1;

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [PFObject pinAllInBackground:objects withName:@"thumbnailForLocation"];
        }
        completion(objects, error);
    }];
}
@end