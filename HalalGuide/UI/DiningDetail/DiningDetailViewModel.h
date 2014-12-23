//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"

@class LocationPicture;


@protocol DiningDetailReviewDelegate <NSObject>

@optional

- (void)reloadCollectionView:(NSUInteger)oldItemsCount insertNewItems:(NSUInteger)newItemsCount;

@end

@protocol DiningDetailPictureDelegate <NSObject>

@optional

- (void)reloadCollectionView;

@end


@interface DiningDetailViewModel : BaseViewModel

@property(nonatomic, retain) id <DiningDetailReviewDelegate> reviewDelegate;
@property(nonatomic, retain) id <DiningDetailPictureDelegate> pictureDelegate;
@property(nonatomic, retain) Location *location;
@property(nonatomic, retain) NSArray *locationPictures;
@property(nonatomic, retain) NSArray *reviews;

+ (DiningDetailViewModel *)instance;

- (LocationPicture *)pictureForRow:(NSUInteger)row;

- (NSNumber *)averageRating;

- (void)report:(UIViewController *)viewController;

@end