//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "ShopTableViewCell.h"
#import "LocationPicture.h"
#import "PictureService.h"
#import "UIImageView+WebCache.h"


@implementation ShopTableViewCell {

}

- (void)configure:(Location *)location {
    [super configure:location];
}

- (NSString *)placeholderImageName {
    return @"shop";
}


@end