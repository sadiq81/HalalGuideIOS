//
// Created by Privat on 13/01/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "HalalLogInViewController.h"


@implementation HalalLogInViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.logInView.facebookButton setTitle:NSLocalizedString(@"login", nil) forState:UIControlStateNormal];
    UILabel *logo = [[UILabel alloc] initWithFrame:CGRectMake(10, (self.view.frame.size.height / 2) - 32, self.view.frame.size.width - 20, 64)];
    logo.text = NSLocalizedString(@"authenticateText", nil);
    logo.numberOfLines = 0;
    logo.adjustsFontSizeToFitWidth = true;
    logo.minimumScaleFactor = 0.5;
    logo.textAlignment = NSTextAlignmentCenter;
    [logo sizeToFit];

    self.logInView.logo = logo;
}
@end