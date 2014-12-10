//
//  Review.m
//  HalalGuide
//
//  Created by Privat on 13/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "Review.h"


@implementation Review

@dynamic creationStatus, locationId, rating, review, submitterId;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Review";
}

@end
