//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGBaseViewModel.h"
#import "HGLocationPicture.h"
#import "HGReviewDetailViewModel.h"

@interface HGLocationDetailViewModel : HGBaseViewModel

@property(nonatomic, readonly, retain) HGLocation *location;
@property(nonatomic, readonly, copy) NSArray *locationPictures;
@property(nonatomic, readonly, copy) NSArray *reviews;
@property(nonatomic, readonly, retain) PFUser *user;

@property(nonatomic, readonly, copy) NSURL *thumbnail;
@property(nonatomic, readonly, copy) NSString *distance;
@property(nonatomic, readonly, copy) NSString *address;
@property(nonatomic, readonly, copy) NSString *postalCode;

@property(nonatomic, readonly) float rating;
@property(nonatomic, readonly, copy) NSString *category;

@property(nonatomic, readonly, copy) UIImage *porkImage;
@property(nonatomic, readonly, copy) NSAttributedString *porkString;
@property(nonatomic, readonly, copy) UIImage *alcoholImage;
@property(nonatomic, readonly, copy) NSAttributedString *alcoholString;
@property(nonatomic, readonly, copy) UIImage *halalImage;
@property(nonatomic, readonly, copy) NSAttributedString *halalString;

@property(nonatomic, readonly, copy) UIImage *languageImage;
@property(nonatomic, readonly, copy) NSString *languageString;

@property(nonatomic, readonly, copy) NSURL *submitterImage;
@property(nonatomic, readonly, copy) NSString *submitterName;

@property(nonatomic, readonly, copy) NSArray *smileys;

@property(nonatomic, readonly, copy) NSNumber *favorite;

- (instancetype)initWithLocation:(HGLocation *)aLocation;

+ (instancetype)modelWithLocation:(HGLocation *)location;

- (HGReviewDetailViewModel *)getReviewDetailViewModel:(NSUInteger)index;

- (void)saveMultiplePictures:(NSArray *)images;

- (void)setFavorised:(BOOL)favorized;

@end