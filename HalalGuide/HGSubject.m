//
// Created by Privat on 26/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "HGSubject.h"


@implementation HGSubject {

}

@dynamic userId, title, count, lastMessage;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return kSubjectTableName;
}
@end