//
// Created by Privat on 09/04/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "UITextField+HGTextFieldStyling.h"


@implementation UITextField (HGTextFieldStyling)

- (void)styleWithPlaceHolder:(NSString *)placeholder andKeyBoardType:(UIKeyboardType)type andAutocapitalizationType:(UITextAutocapitalizationType)cType {

    self.font = [UIFont systemFontOfSize:14];
    self.placeholder = placeholder;
    self.borderStyle = UITextBorderStyleRoundedRect;
    self.keyboardType = type;
    self.autocapitalizationType = cType;

}
@end