//
// Created by Privat on 29/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseViewModel.h"


@interface CategoriesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

}
@property(strong, nonatomic) IBOutlet UITableView *categoriesTableView;
@property(weak, nonatomic) id<CategoriesViewModel> viewModel;

@end