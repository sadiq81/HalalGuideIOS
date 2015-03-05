//
// Created by Privat on 02/03/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "HGTextField.h"


@implementation HGTextField {

}
- (instancetype)initWithFrame:(CGRect)frame andFontSize:(int)size {
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:size];
    }
    return self;
}
@end