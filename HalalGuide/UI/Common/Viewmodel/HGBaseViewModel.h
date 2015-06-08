//
//  HGBaseViewModel.h
//  HalalGuide
//
//  Created by Privat on 09/11/14.
//  Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "HGLocation.h"
#import "NSArray+LinqExtensions.h"
#import "HGCommon.h"
#import <ParseUI/ParseUI.h>

@protocol CategoriesViewModel <NSObject>

@property(nonatomic, strong) NSMutableArray *categories;
@property(nonatomic, strong) NSMutableArray *shopCategories;
@property(nonatomic, readonly) LocationType locationType;
@property(nonatomic) Language language;

@end

@interface HGBaseViewModel : NSObject <PFLogInViewControllerDelegate> {
}

@property(nonatomic) int progress;
@property(nonatomic) NSUInteger fetchCount;
@property(nonatomic) NSError *error;

- (BOOL)isAuthenticated;



@end
