//
//  LocationPicture.m
//  HalalGuide
//
//  Created by Privat on 13/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "LocationPicture.h"
#import "Location.h"


@implementation LocationPicture

@dynamic creationStatus, picture, height, width, locationId, submitterId;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return kLocationPictureTableName;
}

@end
