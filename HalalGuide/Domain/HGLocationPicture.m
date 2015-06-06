//
//  HGLocationPicture.m
//  HalalGuide
//
//  Created by Privat on 13/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "HGLocationPicture.h"
#import "HGLocation.h"


@implementation HGLocationPicture

@dynamic creationStatus, picture, thumbnail, mediumPicture, locationId, reviewId,submitterId;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return kLocationPictureTableName;
}

@end
