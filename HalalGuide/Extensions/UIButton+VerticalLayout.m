//
// Created by Privat on 20/02/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "UIButton+VerticalLayout.h"


@implementation UIButton (VerticalLayout)

- (void)centerVerticallyWithPadding:(float)padding
{
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;

    CGFloat totalHeight = (imageSize.height + titleSize.height + padding);

    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height),
            0.0f,
            0.0f,
            - titleSize.width);

    self.titleEdgeInsets = UIEdgeInsetsMake(0.0f,
            - imageSize.width,
            - (totalHeight - titleSize.height),
            0.0f);

}


- (void)centerVertically
{
    const CGFloat kDefaultPadding = 6.0f;

    [self centerVerticallyWithPadding:kDefaultPadding];
}
@end