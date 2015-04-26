//
// Created by Privat on 26/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface HGChatService : NSObject

+ (HGChatService *)instance;

- (void)getSubjectsWithCompletion:(PFArrayResultBlock)completion;
@end