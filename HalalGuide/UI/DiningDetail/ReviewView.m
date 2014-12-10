//
// Created by Privat on 06/12/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "ReviewView.h"


@implementation ReviewView {

}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [[NSBundle mainBundle] loadNibNamed:@"Review" owner:self options:nil];
    [self addSubview:self.view];
}
@end