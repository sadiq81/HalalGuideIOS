//
// Created by Privat on 15/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "ReviewDetailViewModel.h"
#import "PictureService.h"
#import "Review.h"
#import "ProfileInfo.h"


@implementation ReviewDetailViewModel {

}

+ (ReviewDetailViewModel *)instance {
    static ReviewDetailViewModel *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}


@end