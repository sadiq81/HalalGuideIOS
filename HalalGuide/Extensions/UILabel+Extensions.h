#import <UIKit/UIKit.h>

@interface UILabel (Extensions)

#pragma mark - Calculate the size the Multi line Label
/*====================================================================*/

/* Calculate the size of the Multi line Label */

/*====================================================================*/
/**
*  Returns the size of the Label
*
*  @param aLabel To be used to calculate the height
*
*  @return size of the Label
*/
-(CGSize)sizeOfMultiLineLabel;

/*! Returns the size of the label to display the text provided
    @param text
        The string to be displayed
    @param width
        The width required for displaying the string
    @param fontName
        The font name for the label
    @param fontSize
        The font size for the label
 */
- (CGSize)getSizeForText:(NSString *)text maxWidth:(CGFloat)width;

@end