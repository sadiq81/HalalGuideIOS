//
// Created by Privat on 12/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "UILabel+Extensions.h"


@implementation UILabel (Extensions)

- (CGSize)sizeOfMultiLineLabel {

    NSAssert(self, @"UILabel was nil");

    //Label text
    NSString *aLabelTextString = [self text];

    //Label font
    UIFont *aLabelFont = [self font];

    //Width of the Label
    CGFloat aLabelSizeWidth = self.frame.size.width;

#ifdef NSFoundationVersionNumber_iOS_7_0
    return [aLabelTextString boundingRectWithSize:CGSizeMake(aLabelSizeWidth, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{
                                               NSFontAttributeName : aLabelFont
                                       }
                                          context:nil].size;
#else
    return [aLabelTextString sizeWithFont:aLabelFont
                        constrainedToSize:CGSizeMake(aLabelSizeWidth, MAXFLOAT)
                            lineBreakMode:NSLineBreakByWordWrapping];
#endif

}

- (CGSize)getSizeForText:(NSString *)text maxWidth:(CGFloat)width {
    CGSize constraintSize;
    constraintSize.height = MAXFLOAT;
    constraintSize.width = width;
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
            self.font, NSFontAttributeName,
                    nil];

    CGRect frame = [text boundingRectWithSize:constraintSize
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:attributesDictionary
                                      context:nil];

    CGSize stringSize = frame.size;
    return stringSize;
}
@end