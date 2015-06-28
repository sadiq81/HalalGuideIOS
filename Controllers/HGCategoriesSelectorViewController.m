//
// Created by Privat on 29/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import <ALActionBlocks/UIControl+ALActionBlocks.h>
#import <MZFormSheetController/MZFormSheetController.h>
#import "HGCategoriesSelectorViewController.h"
#import "HGLocation.h"
#import "HGLocationViewModel.h"

@interface HGCategoriesSelectorViewController () <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UIButton *close;

@property(strong, nonatomic) UITableView *categories;
@property(strong, nonatomic) id <CategoriesViewModel> viewModel;

@end

@implementation HGCategoriesSelectorViewController {

}

- (instancetype)initWithViewModel:(id <CategoriesViewModel>)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
        [self setupViews];
        [self setupTableView];
        [self updateViewConstraints];
    }

    return self;
}

+ (instancetype)controllerWithViewModel:(id <CategoriesViewModel>)viewModel {
    return [[self alloc] initWithViewModel:viewModel];
}


- (void)setupViews {

    self.screenName = @"Categories selector";

    self.categories = [[UITableView alloc] initWithFrame:CGRectZero];
    self.categories.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.categories];

    self.close = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.close setImage:[UIImage imageNamed:@"HGCategoriesViewController.button.close"] forState:UIControlStateNormal];
    @weakify(self)
    [self.close handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        @strongify(self)
        [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    }];
    [self.view addSubview:self.close];

}

- (void)setupTableView {
    self.categories.delegate = self;
    self.categories.dataSource = self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.viewModel.locationType) {
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

    switch (self.viewModel.locationType) {
        case LocationTypeDining: {
            catString = (NSString *) CategoryString(indexPath.row);
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

    switch (self.viewModel.locationType) {
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

    switch (self.viewModel.locationType) {
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
            for (UITableViewCell *cell in [self.categories visibleCells]) {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }

            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.viewModel.language = indexPath.row;
            break;
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:true];

}

- (void)updateViewConstraints {

    [self.categories mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self.close mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view.mas_top);
        make.center.equalTo(self.view.mas_left);
        make.width.equalTo(@(31));
        make.height.equalTo(@(31));
    }];

    [super updateViewConstraints];
}


@end