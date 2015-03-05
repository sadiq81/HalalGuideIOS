//
// Created by Privat on 28/02/15.
// Copyright (c) 2015 Eazy It. All rights reserved.
//

#import "UITableView+Header.h"


@implementation UITableView (Header)

- (void) sizeHeaderToFit {
    UIView *headerView = self.tableHeaderView;

    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    CGFloat height = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

    headerView.frame = ({
        CGRect headerFrame = headerView.frame;
        headerFrame.size.height = height;
        headerFrame;
    });

    self.tableHeaderView = headerView;
}

@end