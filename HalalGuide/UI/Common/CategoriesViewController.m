//
// Created by Privat on 29/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "CategoriesViewController.h"
#import "Location.h"
#import "DiningViewModel.h"

//TODO Onboarding - How to dismiss
@implementation CategoriesViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return DiningCategoryWok + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DiningCategory cat = indexPath.row;
    NSString *catString = categoryString(cat);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"category"];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"category"];
    }

    cell.textLabel.text = NSLocalizedString(catString, nil);
    cell.accessoryType = [self.viewModel.categories containsObject:@(cat)] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    DiningCategory cat = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if ([self.viewModel.categories containsObject:@(cat)]) {

        [self.viewModel.categories removeObject:@(cat)];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        [self.viewModel.categories addObject:@(cat)];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end