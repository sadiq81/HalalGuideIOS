//
//  LocationPicture.h
//  HalalGuide
//
//  Created by Privat on 13/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseEntity.h"

#define kLocationPictureTableName  @"LocationPicture"

@interface LocationPicture : BaseEntity

@property (nonatomic, retain) NSNumber * creationStatus;
@property (nonatomic, retain) PFFile * picture;
@property (nonatomic, retain) PFFile * thumbnail;
@property (nonatomic, retain) PFFile * mediumPicture;
@property (nonatomic, retain) NSString * locationId;
@property (nonatomic, retain) NSString * submitterId;

@end
