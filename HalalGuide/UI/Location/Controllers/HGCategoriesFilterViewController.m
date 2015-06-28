//
// Created by Privat on 29/11/14.
// Copyright (c) 2014 Eazy It. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "HGCategoriesFilterViewController.h"
#import "HGLocationViewController.h"
#import "HGCategoryViewModel.h"
#import "HGCategoryViewController.h"

@interface HGCategoriesFilterViewController () <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UITableView *categories;
@property(nonatomic) LocationType locationType;

@end

@implementation HGCategoriesFilterViewController {

}

- (instancetype)initWithLocationType:(LocationType)locationType {
    self = [super init];
    if (self) {
        self.locationType = locationType;
        [self setupViews];
        [self setupTableView];
        [self updateViewConstraints];
    }

    return self;
}

+ (instancetype)controllerWithLocationType:(LocationType)locationType {
    return [[self alloc] initWithLocationType:locationType];
}


- (void)setupViews {

    self.screenName = @"Categories filter";

    self.categories = [[UITableView alloc] initWithFrame:CGRectZero];
    self.categories.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.categories];


}

- (void)setupTableView {
    self.categories.delegate = self;
    self.categories.dataSource = self;
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

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:true];

    HGCategoryViewModel *model = [HGCategoryViewModel modelWithLocationType:self.locationType];
    HGCategoryViewController *vc = [HGCategoryViewController controllerWithViewModel:model];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    vc.title = cell.textLabel.text;

    switch (self.locationType) {
        case LocationTypeDining: {
            DiningCategory cat = (DiningCategory) indexPath.row;
            model.categories = [@[@(cat)] mutableCopy];
            break;
        }
        case LocationTypeShop: {
            ShopType type = (ShopType) indexPath.row;
            model.shopCategories = [@[@(type)] mutableCopy];
            break;
        }
        case LocationTypeMosque: {
            Language language = (Language) indexPath.row;
            model.language = language;
            break;
        }
    }


    [model refreshLocations];
    [self.navigationController pushViewController:vc animated:true];

}

- (void)updateViewConstraints {

    [self.categories mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [super updateViewConstraints];
}


@end