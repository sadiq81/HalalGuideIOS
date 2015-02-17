//
// Created by Privat on 15/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewDetailViewModel.h"
#import "PictureService.h"


@implementation ReviewDetailViewModel {

}

- (instancetype)initWithReview:(Review *)review {
    self = [super init];
    if (self) {
        _review = review;
    }

    return self;
}

+ (instancetype)modelWithReview:(Review *)review {
    return [[self alloc] initWithReview:review];
}


@end