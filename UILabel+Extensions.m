//
// Created by Privat on 12/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "UILabel+Extensions.h"


@implementation UILabel (Extensions)

#pragma mark - Calculate the size,bounds,frame of the Multi line Label
/*====================================================================*/

/* Calculate the size,bounds,frame of the Multi line Label */

/*====================================================================*/
/**
*  Returns the size of the Label
*
*  @param aLabel To be used to calculte the height
*
*  @return size of the Label
*/
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
@end