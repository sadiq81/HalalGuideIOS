//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HGLocation.h"
#import <ParseUI/ParseUI.h>
#import "HGLocationDetailViewModel.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "HGLabels.h"
#import "AsyncImageView.h"

static const int standardCellSpacing = 8;

@interface HGLocationCell : UITableViewCell {

}

@property(nonatomic, strong, readonly) AsyncImageView *thumbnail;
@property(nonatomic, strong, readonly) UILabel *distance;
@property(nonatomic, strong, readonly) UILabel *name;
@property(nonatomic, strong, readonly) UILabel *address;
@property(nonatomic, strong, readonly) UILabel *postalCode;
@property(nonatomic, strong, readonly) UILabel *open;
@property(nonatomic, strong, readonly) HGLocationDetailViewModel *viewModel;

- (void)setupViews;

- (void)setupViewModel;

- (void)configureForViewModel:(HGLocationDetailViewModel *)viewModel;

+ (NSString *)placeholderImageName;

- (void)updateLocationDistance;

+ (NSString *)reuseIdentifier;

@end