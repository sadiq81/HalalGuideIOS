//
//  HGBaseEntity.m
//  HalalGuide
//
//  Created by Privat on 07/12/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "HGBaseEntity.h"


@implementation HGBaseEntity

- (BOOL) isEqual:(id)object
{
    if ([object isKindOfClass:[PFObject class]])
    {
        PFObject* pfObject = object;
        return [self.objectId isEqualToString:pfObject.objectId];
    }

    return NO;
}

- (NSUInteger)hash {
    return self.objectId.hash;
}

@end
