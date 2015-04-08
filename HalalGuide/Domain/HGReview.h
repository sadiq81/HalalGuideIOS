//
//  HGReview.h
//  HalalGuide
//
//  Created by Privat on 13/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "HGBaseEntity.h"

#define kReviewTableName @"Review"

@interface HGReview : HGBaseEntity

@property (nonatomic, retain) NSNumber * creationStatus;
@property (nonatomic, retain) NSString * locationId;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * review;
@property (nonatomic, retain) NSString * submitterId;

@end
