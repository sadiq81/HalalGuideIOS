//
// Created by Privat on 29/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import "CategoriesViewController.h"
#import "Location.h"
#import "LocationViewModel.h"

//TODO Onboarding - How to dismiss
@implementation CategoriesViewController {

}

@synthesize locationType;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.categoriesTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.locationType) {
        case LocationTypeDining: {
            return DiningCategoryWok + 1;
        }
        case LocationTypeShop: {
            return ShopTypeButcher + 1;
        }
        case LocationTypeMosque: {
            return LanguageEnglish + 1;
        }
        default: {
            return 0;
        }
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *catString = nil;

    switch (self.locationType) {
        case LocationTypeDining: {
            catString = (NSString *) categoryString(indexPath.row);
            break;
        }
        case LocationTypeShop: {
            catString = (NSString *) ShopString(indexPath.row);
            break;
        }
        case LocationTypeMosque: {
            catString = (NSString *) LanguageString(indexPath.row);
            break;
        }
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"category"];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"category"];
    }

    cell.textLabel.text = NSLocalizedString(catString, nil);

    switch (self.locationType) {
        case LocationTypeDining: {
            cell.accessoryType = [self.viewModel.categories containsObject:@(indexPath.row)] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            break;
        }
        case LocationTypeShop: {
            cell.accessoryType = [self.viewModel.shopCategories containsObject:@(indexPath.row)] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            break;
        }
        case LocationTypeMosque: {
            cell.accessoryType = (self.viewModel.language == indexPath.row) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    switch (self.locationType) {
        case LocationTypeDining: {
            if ([self.viewModel.categories containsObject:@(indexPath.row)]) {

                [self.viewModel.categories removeObject:@(indexPath.row)];
                cell.accessoryType = UITableViewCellAccessoryNone;
            } else {
                [self.viewModel.categories addObject:@(indexPath.row)];
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
        case LocationTypeShop: {

            if ([self.viewModel.shopCategories containsObject:@(indexPath.row)]) {

                [self.viewModel.shopCategories removeObject:@(indexPath.row)];
                cell.accessoryType = UITableViewCellAccessoryNone;
            } else {
                [self.viewModel.shopCategories addObject:@(indexPath.row)];
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            break;
        }
        case LocationTypeMosque: {
            for (UITableViewCell *cell in [self.categoriesTableView visibleCells]) {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }

            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.viewModel.language = indexPath.row;
            break;
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:true];

}

@end