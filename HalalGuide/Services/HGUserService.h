//
// Created by Privat on 06/06/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HGUserService : NSObject
+ (HGUserService *)instance;

-(void) getUserInBackGround:(NSString *)id onCompletion:(PFObjectResultBlock)completion;

@end