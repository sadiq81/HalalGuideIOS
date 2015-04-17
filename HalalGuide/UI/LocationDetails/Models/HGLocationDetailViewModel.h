//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HGBaseViewModel.h"
#import "HGLocationPicture.h"
#import "HGReviewDetailViewModel.h"

@interface HGLocationDetailViewModel : HGBaseViewModel

@property(nonatomic, retain, readonly) HGLocation *location;
@property(nonatomic, readonly) NSArray *locationPictures;
@property(nonatomic, readonly) NSArray *reviews;
@property (nonatomic, readonly) PFUser *user;

@property (nonatomic, strong, readonly) NSURL *thumbnail;
@property (nonatomic, strong, readonly) NSString *distance;
@property (nonatomic, strong, readonly) NSString *address;
@property (nonatomic, strong, readonly) NSString *postalCode;

@property (nonatomic, readonly) float rating;
@property (nonatomic, strong, readonly) NSString *category;

@property (nonatomic, readonly,strong) UIImage *porkImage;
@property (nonatomic, readonly,strong) NSAttributedString *porkString;
@property (nonatomic, readonly,strong) UIImage *alcoholImage;
@property (nonatomic, readonly,strong) NSAttributedString *alcoholString;
@property (nonatomic, readonly,strong) UIImage *halalImage;
@property (nonatomic, readonly,strong) NSAttributedString *halalString;

@property(nonatomic, readonly, strong) UIImage *languageImage;
@property(nonatomic, readonly, strong) NSString *languageString;

@property(nonatomic, readonly, strong) NSURL *submitterImage;
@property(nonatomic, readonly, strong) NSString *submitterName;

@property (nonatomic, strong, readonly) NSArray *smileys;

- (instancetype)initWithLocation:(HGLocation *)aLocation;

+ (instancetype)modelWithLocation:(HGLocation *)location;

- (HGReviewDetailViewModel *)getReviewDetailViewModel:(NSUInteger)index;

- (void)saveMultiplePictures:(NSArray *)images;

@end