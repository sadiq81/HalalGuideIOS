//
// Created by Privat on 30/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "HGMessageViewModel.h"
#import "HGUser.h"
#import "ReactiveCocoa.h"
#import "HGUserService.h"

@interface HGMessageViewModel ()

@property(nonatomic, strong) NSURL *image;
@property(nonatomic, strong) NSURL *avatar;
@property(nonatomic, strong) NSString *submitter;
@property(nonatomic, strong) NSString *text;

@property(nonatomic, strong) HGMessage *message;

@end

@implementation HGMessageViewModel {

}

- (instancetype)initWithMessage:(HGMessage *)message {
    self = [super init];
    if (self) {
        self.message = message;


        if (message.image) {
            self.image = [[NSURL alloc] initWithString:message.image.url];
        }

        @weakify(self)
        [[HGUserService instance] getUserInBackGround:message.userId onCompletion:^(PFObject *object, NSError *error) {
            @strongify(self)
            HGUser *user = (HGUser *) object;
            self.avatar = user.facebookProfileUrlSmall;
            self.submitter = user.facebookName;
        }];

        self.text = message.text;
    }
    return self;
}

+ (instancetype)modelWithMessage:(HGMessage *)message {
    return [[self alloc] initWithMessage:message];
}


@end