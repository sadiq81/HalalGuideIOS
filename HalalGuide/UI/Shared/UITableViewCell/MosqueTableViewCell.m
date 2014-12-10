//
// Created by Privat on 21/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "MosqueTableViewCell.h"
#import "PictureService.h"
#import "LocationPicture.h"
#import "UIImageView+WebCache.h"


@implementation MosqueTableViewCell {

}

- (void)configure:(Location *)location {
    [super configure:location];

    UIImageView *language = (UIImageView *) [self.contentView viewWithTag:102];
    language.image = [UIImage imageNamed:LanguageString([location.language integerValue])];

    UILabel *languageLabel = (UILabel *) [self.contentView viewWithTag:204];
    languageLabel.text = NSLocalizedString(LanguageString([location.language integerValue]), nil);
}

- (NSString *)placeholderImageName {
    return @"mosque";
}

@end