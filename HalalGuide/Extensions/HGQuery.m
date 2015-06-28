//
// Created by Privat on 05/06/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "HGQuery.h"
#import "HGReachabilityManager.h"

@implementation HGQuery {

}
+ (instancetype)queryWithClassName:(NSString *)className {
    HGQuery *query = [super queryWithClassName:className];


    if ([HGReachabilityManager isUnreachable]) {
        [query fromLocalDatastore];
    }

    return query;

}

@end