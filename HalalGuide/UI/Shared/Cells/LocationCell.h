//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Location.h"
#import <ParseUI/ParseUI.h>
#import "LocationDetailViewModel.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "HalalGuideLabels.h"

static const int standardCellSpacing = 8;

@interface LocationCell : UITableViewCell {

}

@property(nonatomic, strong, readonly) UIImageView *thumbNail;
@property(nonatomic, strong, readonly) UILabel *distance;
@property(nonatomic, strong, readonly) UILabel *name;
@property(nonatomic, strong, readonly) UILabel *address;
@property(nonatomic, strong, readonly) UILabel *postalCode;
@property(nonatomic, strong, readonly) UILabel *open;
@property (nonatomic, strong, readonly) LocationDetailViewModel *viewModel;

- (void)configureForViewModel:(LocationDetailViewModel *)viewModel;

+ (NSString *)placeholderImageName;

@end