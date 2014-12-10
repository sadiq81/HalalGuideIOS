//
// Created by Privat on 29/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"

@interface CreateReviewViewModel : BaseViewModel

@property Location *reviewedLocation;

+ (CreateReviewViewModel *)instance;

- (void)saveEntity:(NSString *)reviewText rating:(int)rating onCompletion:(void (^)(CreateEntityResult result))completion;

@end