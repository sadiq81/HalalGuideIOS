//
// Created by Privat on 26/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "HGMessage.h"


@implementation HGMessage {

}

@dynamic subjectId, userId, text, image, video;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return kMessageTableName;
}

@end